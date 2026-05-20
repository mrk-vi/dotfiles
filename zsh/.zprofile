# macOS: Homebrew
if [[ "$OSTYPE" == "darwin"* ]] && [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# pipx
[ -d "$HOME/.local/bin" ] && export PATH="$PATH:$HOME/.local/bin"

# Source local overrides
[ -f "$HOME/.zprofile.local" ] && source "$HOME/.zprofile.local"


# Added by Antigravity CLI installer
export PATH="/Users/mirko/.local/bin:$PATH"
