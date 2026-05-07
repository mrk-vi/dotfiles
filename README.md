# Dotfiles

Personal configs managed with **GNU Stow**.

## Why Stow?

Stow creates symlinks from this repo into `$HOME`, keeping config files in one place under version control.

- **Clean** — no copy scripts, no installers
- **Reversible** — `stow -D <package>` removes symlinks instantly
- **Selective** — `stow nvim` deploys only Neovim, `stow git` only git, etc.
- **Local overrides** — `.local` files (`.vimrc.local`, `.gitconfig.local`, etc.) are gitignored and stay machine-specific

## Install Stow

```bash
# macOS
brew install stow

# Fedora
sudo dnf install stow

# Arch (Manjaro, etc.)
sudo pacman -S stow
```

## Usage

```bash
cd ~/dotfiles
stow bash git nvim tmux vim zsh                  # deploy all
stow -D nvim                                      # remove nvim symlinks
stow --adopt nvim                                 # adopt existing files into the repo
```

