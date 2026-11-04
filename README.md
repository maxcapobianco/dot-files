# Personal dotfiles

Neovim (LazyVim), tmux, Alacritty, and zsh configuration in one repository.

```text
nvim/          Neovim config, plugins, and plugin lockfile
tmux/         tmux config and plugin notes
alacritty/    Alacritty config, including Dracula+ colors
zsh/          zsh config and customized Oh My Zsh agnoster theme
install.sh     Install symlinks, preserving existing configs
```

## Install

Clone this repository to a permanent location, such as `~/dotfiles`, then run:

```sh
cd ~/dotfiles
./install.sh
```

Close Neovim before installing. Run the script as your normal user, without
`sudo`. It works from any working directory and uses its own location to find
this repository.

The installer creates:

| Link | Target |
| --- | --- |
| `${XDG_CONFIG_HOME:-~/.config}/nvim` | `<repo>/nvim` |
| `~/.tmux.conf` | `<repo>/tmux/tmux.conf` |
| `~/.config/alacritty/alacritty.toml` | `<repo>/alacritty/alacritty.toml` |
| `~/.zshrc` | `<repo>/zsh/.zshrc` |
| `~/.oh-my-zsh/custom/themes/agnoster.zsh-theme` | `<repo>/zsh/agnoster.zsh-theme` |

Existing files, directories, and different or broken symlinks are moved to a
unique sibling backup directory, such as `~/.config/nvim.backup.ABC12345/original`.
The script prints each backup path. An old Neovim repository, including its
`.git` directory, is preserved in that backup. Correct links are left alone, so
running the installer again is safe.

The installer clones [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) and
[TPM](https://github.com/tmux-plugins/tpm) if missing, runs TPM's plugin
installer on an isolated tmux server, and installs
[JetBrains Mono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/tag/v3.5.1)
(v3.5.1). Existing Oh My Zsh and TPM installations are reused, not upgraded.
Fonts go into `${XDG_DATA_HOME:-~/.local/share}/fonts/JetBrainsMonoNerdFont`
on Linux or `~/Library/Fonts/JetBrainsMonoNerdFont` on macOS. Linux's font
cache is refreshed.
Repeat runs skip the completed font download. Network access is required for
missing Oh My Zsh, plugins, and fonts; system packages are not installed
automatically.

**Select `JetBrainsMono Nerd Font Mono` in your terminal's font settings** after
installation. Restart the terminal if it does not appear. For SSH sessions,
the font must also be installed and selected on the machine running your terminal.
The script cannot choose the font in your terminal application.

If your old Neovim config has an uncommitted `lazy-lock.json`, review or copy it
into `nvim/lazy-lock.json` before switching to preserve those plugin versions.

Keep this repository in place: the links use absolute paths. If you move it,
run the installer again from the new location.

## Prerequisites

- Bash, Git, curl, unzip, Neovim compatible with the pinned LazyVim/plugins, and tmux.
- zsh and `keychain` for the captured zsh setup.
  The optional `~/.devenv_base.sh` remains machine managed.
  The customized `agnoster` theme is loaded from Oh My Zsh's custom themes directory.
- `ripgrep` and `fd` for searching. The directory picker explicitly uses
  `fdfind`, as provided by Debian/Ubuntu's `fd-find` package.
- A C compiler and build tools for native plugins; the `tree-sitter` CLI for
  parser installation with the configured Treesitter version.
- Rust tooling (`rustup`, `rust-analyzer`, and Clippy) for Rust development;
  Python and C/C++ tooling for the languages you use.
- `bc` for tmux's version-dependent navigation bindings.
- `fontconfig` on Linux to refresh the font cache. LazyGit is optional.

On Debian/Ubuntu, install the required packages with:

```sh
sudo apt install git tmux zsh keychain curl unzip fontconfig ripgrep fd-find bc
```

Open Neovim to let lazy.nvim install plugins. Use `:checkhealth` to check local
dependencies and `:Mason` to inspect language tools.

TPM and tmux plugins are installed by `./install.sh`. After adding plugins to
`tmux/tmux.conf`, rerun the script or press `Ctrl-a` followed by uppercase `I`
in tmux. To reload an existing tmux session:

```sh
tmux source-file ~/.tmux.conf
```

## Maintaining the configs

Edit files under `nvim/`, `tmux/`, `alacritty/`, and `zsh/`, or through their
installed symlinks. Commit intentional plugin-version updates in
`nvim/lazy-lock.json`.
SSH private keys and authentication settings belong outside this repository.

The original branches were imported with Git subtree; ongoing changes can be
made directly on `main` in these directories.

## Restore a backup

Remove only the installed symlink and move its printed backup back into place.
For example, for the default Neovim location (replace the backup path):

```sh
# Confirm this is a symlink before unlinking it.
ls -ld ~/.config/nvim
unlink ~/.config/nvim
mv ~/.config/nvim.backup.ABC12345/original ~/.config/nvim
```

For tmux or zsh, use the same process with `~/.tmux.conf` or `~/.zshrc` and its
printed backup path.
If you set `XDG_CONFIG_HOME`, use that directory instead of `~/.config`.
