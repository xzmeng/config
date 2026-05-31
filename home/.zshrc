# Homebrew
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# PATH
export PATH="$HOME/.local/bin:$PATH"

# unicode and time zone
export LANG=en_US.UTF-8
export TZ=Asia/Shanghai

# terminfo
if [[ $TERM != "xterm-ghostty" ]]; then
  export TERM=xterm-256color
fi

# config update
function config-update() {
    git -C ~/config pull
}

# zoxide
eval "$(zoxide init zsh)"

# fzf
source <(fzf --zsh)

# starship — use container config when inside a container
if [[ -f /.dockerenv ]] || [[ -n "$container" ]] || grep -qE '(docker|lxc|containerd|/podman)' /proc/1/cgroup 2>/dev/null; then
    export STARSHIP_CONFIG="$HOME/.config/starship-container.toml"
fi
eval "$(starship init zsh)"

# zsh 补全
autoload -Uz compinit
compinit

# 开启大小写不敏感补全
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# auto suggestions
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# syntax highlighting
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# local config
if [[ -f "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi

# secrets
if [[ -f "$HOME/.zsh_secrets" ]]; then
    source "$HOME/.zsh_secrets"
fi