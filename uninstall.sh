#!/usr/bin/env bash

# Exit on error
set -e

# Configuration
TARGET_DIR="$HOME/repos/dotfiles"

echo "🧹 Starting dotfiles removal..."

# 1. Ask for confirmation before destroying everything
read -p "⚠️  Are you sure you want to uninstall all dotfiles and the applications? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Uninstallation aborted."
    exit 1
fi

# 2. Run Ansible cleanup playbook (must be done while ansible/stow are still installed)
echo "🛠️ Running Ansible cleanup (unstow and uninstalling apps)..."
if [ -f "ansible/cleanup.yml" ]; then
    ansible-playbook ansible/cleanup.yml --ask-become-pass
else
    echo "❌ Error: ansible/cleanup.yml not found."
    exit 1
fi

# 3. Final cleanup (optional)
read -p "🗑️  Would you like to delete the local dotfiles repository at $TARGET_DIR? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Deleting $TARGET_DIR..."
    rm -rf "$TARGET_DIR"
    echo "✅ Dotfiles repository removed."
fi

echo "✅ Uninstallation complete!"
