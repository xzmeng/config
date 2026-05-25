# PATH
export PATH="$HOME/.local/bin:$PATH"

# homebrew
eval "$(brew shellenv)"

# zoxide
eval "$(zoxide init zsh)"

# fzf
source <(fzf --zsh)

# starship
eval "$(starship init zsh)"

# zsh 补全
autoload -Uz compinit
compinit

# 开启大小写不敏感补全
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# auto suggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
