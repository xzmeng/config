# Homebrew
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Path for scripts installed command
export PATH="$HOME/.local/bin:$PATH"
# Homebrew rustup is keg-only
export PATH="/usr/local/opt/rustup/bin:$PATH"

# unicode and time zone
export LANG=en_US.UTF-8
export TZ=Asia/Shanghai

# terminfo
export TERM=xterm-256color

# aliases
alias vi="nvim"

# config update
function config-update() {
    git -C $HOME/config pull
    bash $HOME/config/install.sh
    exec zsh
}

# zoxide
eval "$(zoxide init zsh)"

# fzf
source <(fzf --zsh)

# Container detection (shared by starship and one-time init below)
if [[ -f /.dockerenv ]] || [[ -n "$container" ]] || grep -qE '(docker|lxc|containerd|/podman)' /proc/1/cgroup 2>/dev/null; then
    IS_CONTAINER=1
fi

# Container-specific configuration
if [[ -n "$IS_CONTAINER" ]]; then
    export STARSHIP_CONFIG="$HOME/.config/starship-container.toml"
    export SHELL=$(which zsh)

    # One-time container initialization
    if [[ ! -f "$HOME/.config-inited" ]]; then
        if command -v gh &>/dev/null; then
            gh auth setup-git
        fi
        touch "$HOME/.config-inited"
    fi
fi

# starship
eval "$(starship init zsh)"

# zsh-completions
#FPATH=$HOMEBREW_PREFIX/share/zsh-completions:$FPATH
autoload -Uz compinit
compinit
# case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
# menu select
zstyle ':completion:*' menu select

# auto suggestions
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# syntax highlighting
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# local config
if [[ -f "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi

# secrets
if [ -f "$HOME/.secrets.env" ]; then
    # export all environment variables
    export $(grep -v '^#' "$HOME/.secrets.env" | xargs)
fi
