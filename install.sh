#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"

if [[ "$config_dir" != /* ]]; then
  printf 'XDG_CONFIG_HOME must be an absolute path.\n' >&2
  exit 1
fi

data_dir="${XDG_DATA_HOME:-$HOME/.local/share}"
font_version="v3.5.1"
case "$(uname -s)" in
  Linux) font_dir="$data_dir/fonts/JetBrainsMonoNerdFont" ;;
  Darwin) font_dir="$HOME/Library/Fonts/JetBrainsMonoNerdFont" ;;
  *) printf 'Font installation supports Linux and macOS only.\n' >&2; exit 1 ;;
esac
if [[ "$data_dir" != /* ]]; then
  printf 'XDG_DATA_HOME must be an absolute path.\n' >&2
  exit 1
fi
for command in git tmux curl unzip; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf 'Missing prerequisite: %s\n' "$command" >&2
    exit 1
  fi
done
if [[ "$(uname -s)" == Linux ]] && ! command -v fc-cache >/dev/null 2>&1; then
  printf 'Install fontconfig (fc-cache) before running this script.\n' >&2
  exit 1
fi
if [[ -f "$config_dir/tmux/tmux.conf" && ! "$config_dir/tmux/tmux.conf" -ef "$repo_dir/tmux/tmux.conf" ]]; then
  printf 'Move aside %s/tmux/tmux.conf first; it overrides ~/.tmux.conf for TPM.\n' "$config_dir" >&2
  exit 1
fi

# Validate everything before changing existing configuration.
for source in "$repo_dir/nvim/init.lua" "$repo_dir/tmux/tmux.conf"; do
  if [[ ! -f "$source" ]]; then
    printf 'Missing config: %s\n' "$source" >&2
    exit 1
  fi
done

link_config() {
  local source="$1" destination="$2" backup_dir
  if [[ -L "$destination" && "$destination" -ef "$source" ]]; then
    printf 'Already linked: %s\n' "$destination"
    return
  fi
  mkdir -p -- "$(dirname -- "$destination")"
  if [[ -e "$destination" || -L "$destination" ]]; then
    backup_dir="$(mktemp -d "${destination}.backup.XXXXXXXX")"
    mv -- "$destination" "$backup_dir/original"
    printf 'Backup: %s -> %s/original\n' "$destination" "$backup_dir"
  fi
  ln -s -- "$source" "$destination"
  printf 'Linked: %s -> %s\n' "$destination" "$source"
}

link_config "$repo_dir/nvim" "$config_dir/nvim"
link_config "$repo_dir/tmux/tmux.conf" "$HOME/.tmux.conf"

# Use a private tmux server so installing plugins does not alter live sessions.
install_tmux_plugins() (
  set -e
  local tpm_dir="$HOME/.tmux/plugins/tpm" socket_dir socket
  if [[ ! -e "$tpm_dir" ]]; then
    mkdir -p "$HOME/.tmux/plugins"
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm_dir"
  fi
  if [[ ! -x "$tpm_dir/bin/install_plugins" ]]; then
    printf 'Invalid TPM installation: %s\n' "$tpm_dir" >&2
    exit 1
  fi
  socket_dir="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-tmux.XXXXXXXX")"
  socket="$socket_dir/server"
  trap 'tmux -S "$socket" kill-server 2>/dev/null || true; rmdir "$socket_dir" 2>/dev/null || true' EXIT
  tmux -S "$socket" -f /dev/null new-session -d -s dotfiles-install
  tmux -S "$socket" set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins/"
  env TMUX="$(tmux -S "$socket" display-message -p '#{socket_path},#{pid},0')" \
    "$tpm_dir/bin/install_plugins"
)

install_font() (
  set -e
  local temp_dir
  if [[ -f "$font_dir/.nerd-fonts-$font_version" && -f "$font_dir/JetBrainsMonoNerdFontMono-Regular.ttf" ]]; then
    printf 'JetBrains Mono Nerd Font %s already installed.\n' "$font_version"
    return
  fi
  temp_dir="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-font.XXXXXXXX")"
  trap 'rm -rf -- "$temp_dir"' EXIT
  curl --fail --location --retry 3 \
    "https://github.com/ryanoasis/nerd-fonts/releases/download/$font_version/JetBrainsMono.zip" \
    -o "$temp_dir/font.zip"
  unzip -q "$temp_dir/font.zip" -d "$temp_dir/extracted"
  if [[ ! -f "$temp_dir/extracted/JetBrainsMonoNerdFontMono-Regular.ttf" ]]; then
    printf 'Font archive did not contain the expected JetBrains Mono font.\n' >&2
    exit 1
  fi
  mkdir -p "$font_dir"
  cp "$temp_dir/extracted/"*.ttf "$font_dir/"
  if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f "$font_dir"
  fi
  touch "$font_dir/.nerd-fonts-$font_version"
  printf 'Installed JetBrains Mono Nerd Font in %s\n' "$font_dir"
)

install_tmux_plugins
install_font
printf '\nDone. Select "JetBrainsMono Nerd Font Mono" in your terminal settings.\n'
printf 'Reopen Neovim; reload tmux with: tmux source-file ~/.tmux.conf\n'
