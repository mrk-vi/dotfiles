#!/usr/bin/env bash

# Exit on error
set -e

# Configuration
REPO_URL="https://github.com/mrk-vi/dotfiles.git"
TARGET_DIR="$HOME/repos/dotfiles"

echo "🚀 Starting dotfiles setup..."

# Function to detect the package manager
detect_package_manager() {
    if [ -f /etc/fedora-release ] || [ -f /etc/redhat-release ]; then
        echo "dnf"
    elif [ -f /etc/debian_version ]; then
        echo "apt"
    elif [ -f /etc/arch-release ]; then
        echo "pacman"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "brew"
    else
        echo "unknown"
    fi
}

PKG_MGR=$(detect_package_manager)

install_packages() {
    echo "📦 Installing bootstrap dependencies (git, ansible, stow)..."
    case $PKG_MGR in
        dnf)
            sudo dnf install -y git ansible-core stow
            ;;
        apt)
            sudo apt update && sudo apt install -y git ansible stow
            ;;
        pacman)
            sudo pacman -S --noconfirm git ansible stow
            ;;
        brew)
            # Ensure brew is installed for macOS
            if ! command -v brew &> /dev/null; then
                echo "🍺 Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install git ansible stow
            ;;
        *)
            echo "❌ Unsupported package manager. Please install git, ansible, and stow manually."
            exit 1
            ;;
    esac
}

# 1. Install dependencies first (crucial for cloning)
install_packages

# 2. Clone or Update the repository
if [ ! -d "$TARGET_DIR" ]; then
    echo "📥 Cloning dotfiles repository..."
    mkdir -p "$(dirname "$TARGET_DIR")"
    git clone "$REPO_URL" "$TARGET_DIR"
else
    echo "🔄 Dotfiles directory already exists. Pulling latest changes..."
    cd "$TARGET_DIR"
    git pull
fi

# 3. Run Ansible playbook
echo "🛠️ Running Ansible playbook..."
cd "$TARGET_DIR"
if [ -f "ansible/setup.yml" ]; then
    ansible-playbook ansible/setup.yml --ask-become-pass
else
    echo "⚠️ Warning: ansible/setup.yml not found. Skipping playbook execution."
fi

echo "✅ Dotfiles setup complete!"
