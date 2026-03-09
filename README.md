# My Dotfiles

Personal configurations for my development environment, automated with **Ansible** and **Stow**.

## Quick Setup (One-Liner)

Run this on any fresh Fedora, Debian/Ubuntu, or macOS machine to install all dependencies and apply configurations:

```bash
curl -sSL https://raw.githubusercontent.com/mrk-vi/dotfiles/master/install.sh | bash
```

## Features

- **Automated Bootstrap:** Detects your OS and installs `git`, `ansible`, and `stow`.
- **Infrastructure as Code:** Uses Ansible to install applications (i3, tmux, vim, neovim).
- **Symlink Management:** GNU Stow manages configuration linking (clean and reversible).
- **Cleanup Support:** includes an `uninstall.sh` script to revert all changes safely.

## Applications Configured

- **i3:** Window manager setup.
- **tmux:** Terminal multiplexer configuration.
- **Vim / Neovim:** Editor settings and plugins.

## How to Uninstall

If you need to revert everything, run:

```bash
./uninstall.sh
```
