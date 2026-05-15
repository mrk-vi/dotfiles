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

# Build image if not present, or rebuild if older than 24h
NEEDS_BUILD=false
if ! docker image inspect "$IMAGE" &>/dev/null; then
    NEEDS_BUILD=true
else
    CREATED=$(docker image inspect --format '{{.Created}}' "$IMAGE" 2>/dev/null)
    if [ -n "$CREATED" ]; then
        CREATED_TS=$(date -d "$CREATED" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%S" "${CREATED%%.*}" +%s 2>/dev/null)
        NOW=$(date +%s)
        if [ $((NOW - CREATED_TS)) -gt 86400 ]; then
            NEEDS_BUILD=true
        fi
    fi
fi
if $NEEDS_BUILD; then
    echo "Building pi-agent image..."
    docker build --build-arg CACHE_BUST="$(date +%s)" -t "$IMAGE" "$DOTFILES_DIR"
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
