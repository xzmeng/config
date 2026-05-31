#!/usr/bin/bash

if [[ $(uname) == "Darwin" ]]; then
    brew bundle
else
    package_list=(
        stow
        btop
        gh
        bat
        eza
        fzf
        starship
        tmux
        zoxide
        zsh-autosuggestions
        zsh-syntax-highlighting
        neovim
    )
    sudo apt update
    sudo apt install -y "${package_list[@]}"
fi

stow home

# Ensure tmux helper scripts are executable (stow preserves permissions,
# but we set it explicitly in case the repo was cloned on a different OS)
chmod +x "$HOME/.config/tmux/detect-container-icon.sh" 2>/dev/null || true
