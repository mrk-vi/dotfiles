c()
{
	cd $@
	ls -l
}

cheatsh()
{
	curl -s cheat.sh/$@ | less
}


# Search files with fzf and open them in vim
fv() {
  local files

  # Use fd if available, otherwise fall back to find
  local finder
  if command -v fd &>/dev/null; then
    finder="fd --type f --hidden --exclude .git"
  else
    finder="find . -type f -not -path '*/.git/*'"
  fi

  # Select one or more files with fzf (TAB for multi-select)
  files=$(eval "$finder" | fzf \
    --multi \
    --preview 'bat --color=always --style=numbers {} 2>/dev/null || cat {}' \
    --preview-window=right:60% \
    --prompt='Search file: ' \
    --header='TAB = multi-select | ENTER = open in vim' \
    --bind='ctrl-a:select-all' \
    --bind='ctrl-d:deselect-all'
  )

  # Open selected files in vim
  [[ -n "$files" ]] && vim $(echo "$files" | tr '\n' ' ')
}

# Variant: search only git-tracked files
fvg() {
  local files
  files=$(git ls-files 2>/dev/null | fzf \
    --multi \
    --preview 'bat --color=always --style=numbers {} 2>/dev/null || cat {}' \
    --preview-window=right:60% \
    --prompt='Git files: ' \
    --header='TAB = multi-select | ENTER = open in vim'
  )

  [[ -n "$files" ]] && vim $(echo "$files" | tr '\n' ' ')
}

# Variant: search by content (grep/ripgrep) and jump to the exact line
fvr() {
  local result file line

  if command -v rg &>/dev/null; then
    result=$(rg --line-number --no-heading --color=always "" | fzf \
      --ansi \
      --delimiter=':' \
      --preview 'bat --color=always --style=numbers --highlight-line {2} {1} 2>/dev/null || cat {1}' \
      --preview-window=right:60%:+{2}-5 \
      --prompt='Search content: '
    )
  else
    result=$(grep -rn "" . --include="*" 2>/dev/null | fzf \
      --delimiter=':' \
      --preview 'cat {1}' \
      --prompt='Search content: '
    )
  fi

  if [[ -n "$result" ]]; then
    file=$(echo "$result" | cut -d':' -f1)
    line=$(echo "$result" | cut -d':' -f2)
    vim +"$line" "$file"
  fi
}

# Source local functions (machine-specific)
[ -f "$HOME/.bash_functions.local" ] && source "$HOME/.bash_functions.local"
