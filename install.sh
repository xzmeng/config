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
    )
    sudo apt update
    sudo apt install -y "${package_list[@]}"
fi

stow home