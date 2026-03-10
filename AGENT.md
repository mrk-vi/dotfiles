# AGENT.md

This file provides guidance to AI coding agents when working with code in this repository.

## Overview

Dotfiles repo managing dev environment configs for Fedora, Debian/Ubuntu, and macOS. Uses **GNU Stow** for symlink management and **Ansible** for automated provisioning.

## Architecture

Each top-level directory is a **Stow package** — its internal structure mirrors the home directory. Stow symlinks contents into `~` from the repo at `~/repos/dotfiles`.

### Stow packages

- `bash/` — `.bashrc`, `.bash_profile`, `.profile`, `.bash_aliases`, `.bash_functions`
- `zsh/` — `.zshrc`, `.zprofile`, `.zshenv`
- `vim/` — `.vimrc`
- `nvim/` — `.config/nvim/` (kickstart.nvim-based config with lazy.nvim plugin manager)
- `tmux/` — `.tmux.conf` (uses TPM plugin manager)
- `git/` — `.gitconfig`, `.config/git/ignore`
- `htop/` — `.config/htop/htoprc`
- `i3/` — `.config/i3/config` (Linux-only, skipped on macOS)

### Machine-specific overrides

Tracked configs source `.local` variants for machine-specific settings (paths, secrets, credentials). These `.local` files are gitignored and never enter the repo.

- Shell: `~/.zshrc.local`, `~/.bashrc.local`, `~/.zprofile.local`, etc.
- Git: `~/.gitconfig.local` (for `[user]` name/email and machine-specific settings)
- Vim: `~/.vimrc.local`
- Tmux: `~/.tmux.conf.local`

### OS-conditional logic

Shell configs use OS detection for platform-specific behavior:
- macOS: Homebrew init, `macos`/`sdk` oh-my-zsh plugins
- Linux: i3 stow package applied only on non-Darwin hosts

### Automation

- `install.sh` — Bootstrap script: detects OS/package manager, installs git+ansible+stow, clones repo, runs Ansible
- `ansible/setup.yml` — Installs packages, stows all configs (platform-aware)

## Key Commands

```bash
# Install everything (bootstrap)
./install.sh

# Run setup playbook directly
ansible-playbook ansible/setup.yml --ask-become-pass

# Stow a single package manually (e.g., tmux)
stow -v -R -t ~ tmux

# Unstow a package
stow -v -D -t ~ tmux

# Unstow everything
cd ~/repos/dotfiles && for d in bash git htop nvim tmux vim zsh; do stow -D -t ~ $d; done
```

## Adding a New Config Package

1. Create a directory named after the tool (e.g., `alacritty/`)
2. Mirror the home directory structure inside it (e.g., `alacritty/.config/alacritty/alacritty.toml`)
3. Add a `.local` sourcing hook if the config format supports it
4. Add the package name to the stow loop in both `ansible/setup.yml` and `ansible/cleanup.yml`
5. Add any required system packages to the install tasks in `ansible/setup.yml` (Fedora, Debian, and macOS sections)
