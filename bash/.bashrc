# Keep k9s config XDG-compatible on macOS
# Point directly at dotfiles to avoid stow symlink `mkdir` clash
export K9S_CONFIG_DIR="$HOME/dotfiles/k9s/.config/k9s"

LSCOLORS="ExFxbxbxCxBxBxCxCxExEx"

PS1='\u:\w \$ '

source "$HOME/.bash_aliases"
source "$HOME/.bash_functions"

# nvm Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Cargo/Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# SDKMAN (must be at the end before local overrides)
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Source local overrides (machine-specific paths, secrets, etc.)
[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"
