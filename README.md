# My Dotfiles

Personal configurations for my development environment, automated with **Ansible** and **Stow**.

## Quick Setup (One-Liner)

Run this on any fresh Fedora, Debian/Ubuntu, or macOS machine to install all dependencies and apply configurations:

```bash
curl -sSL https://raw.githubusercontent.com/mrk-vi/dotfiles/master/install.sh | bash
```

## Features

- **Automated Bootstrap:** Detects your OS and installs `git`, `ansible`, and `stow`.
- **Infrastructure as Code:** Uses Ansible to install applications and stow configurations.
- **Symlink Management:** GNU Stow manages configuration linking (clean and reversible).
- **Local Overrides:** Machine-specific settings go in `.local` files (gitignored).

## Applications Configured

- **zsh / bash:** Shell configs with shared aliases and functions.
- **Vim / Neovim:** Editor settings and plugins (kickstart.nvim).
- **tmux:** Terminal multiplexer configuration with TPM.
- **git:** Global gitconfig with nvim as merge/diff tool.
- **i3:** Window manager setup (Linux-only).
- **htop:** System monitor configuration.

## How to Unstow

To remove symlinks for a single package:

```bash
stow -D -t ~ tmux
```

To unstow everything:

```bash
cd ~/repos/dotfiles && for d in bash git htop nvim tmux vim zsh; do stow -D -t ~ $d; done
```
