#!/usr/bin/bash

set -euo pipefail

BREW_PATHS=(
  /opt/homebrew/bin/brew
  /usr/local/bin/brew
  /home/linuxbrew/.linuxbrew/bin/brew
)

find_brew() {
  for brew_path in "${BREW_PATHS[@]}"; do
    if [[ -x "$brew_path" ]]; then
      echo "$brew_path"
      return 0
    fi
  done
  return 1
}

install_homebrew_deps() {
  if command -v apt-get &>/dev/null; then
    echo "Installing Homebrew dependencies (build-essential procps curl file git)..."
    sudo apt-get update -qq
    sudo apt-get install -y -qq build-essential procps curl file git
  fi
}

install_homebrew() {
  local brew_path
  if brew_path=$(find_brew); then
    echo "Homebrew already installed: $("$brew_path" --version | head -1)"
    return 0
  fi

  install_homebrew_deps
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Homebrew may install to a path not on the default PATH.
  for brew_path in "${BREW_PATHS[@]}"; do
    if [[ -x "$brew_path" ]]; then
      eval "$("$brew_path" shellenv)"
      break
    fi
  done

  if ! find_brew &>/dev/null; then
    echo "Error: Homebrew installation completed but 'brew' is still not found." >&2
    echo "Please add Homebrew to your PATH manually and re-run this script." >&2
    exit 1
  fi
}

install_homebrew
brew bundle
stow home
