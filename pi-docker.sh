#!/bin/bash
set -e

IMAGE="pi-agent"
# Resolve symlinks to find the real script location (macOS + Linux compatible)
if command -v realpath &>/dev/null; then
    DOTFILES_DIR="$(dirname "$(realpath "$0")")"
elif readlink -f "$0" &>/dev/null 2>&1; then
    DOTFILES_DIR="$(dirname "$(readlink -f "$0")")"
else
    # macOS fallback: resolve symlink manually
    SCRIPT="$0"
    while [ -L "$SCRIPT" ]; do
        SCRIPT="$(cd "$(dirname "$SCRIPT")" && readlink "$SCRIPT")"
    done
    DOTFILES_DIR="$(cd "$(dirname "$SCRIPT")" && pwd)"
fi

# Build image once (if not already built)
if ! docker image inspect "$IMAGE" &>/dev/null; then
    echo "Building pi-agent image..."
    docker build -t "$IMAGE" "$DOTFILES_DIR"
fi

exec docker run -it --rm \
    -v "$(pwd):/workspace" \
    -v ~/.pi:/root/.pi \
    -v ~/.agents:/root/.agents \
    -v ~/.claude:/root/.claude:ro \
    -v ~/.ssh:/root/.ssh:ro \
    -v ~/.gitconfig:/root/.gitconfig:ro \
    -v ~/Library/Application\ Support/glab-cli:/root/.config/glab-cli:ro \
    "$IMAGE" "$@"
