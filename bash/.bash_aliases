# shortcuts
alias k="kubectl"
alias ll="ls -lG"
alias ls='ls -G'
alias gitl='git log --format="%Cgreen%as %Cblue%<|(30)%an: %Cred%h %Creset%s"'
alias q=exit

# tmux sessions
alias t="tmux"

# utilities
alias edit=nvim

alias rfc3339='date "+%Y-%m-%dT%H:%M:%SZ"'
alias timestamp='date "+%s"'

# Source local aliases (machine-specific shortcuts)
[ -f "$HOME/.bash_aliases.local" ] && source "$HOME/.bash_aliases.local"
