#!/usr/bin/bash

set -euo pipefail

REPO_URL="https://github.com/xzmeng/config.git"
CONFIG_DIR="$HOME/config"

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

clone_repo() {
  if [[ -d "$CONFIG_DIR/.git" ]]; then
    echo "Config repo already exists at $CONFIG_DIR, pulling latest..."
    git -C "$CONFIG_DIR" pull
  else
    echo "Cloning config repo to $CONFIG_DIR..."
    git clone "$REPO_URL" "$CONFIG_DIR"
  fi
}

# ── main ──

# Ensure git is available early (needed for clone)
if ! command -v git &>/dev/null; then
  if command -v apt-get &>/dev/null; then
    sudo apt-get update -qq && sudo apt-get install -y -qq git
  else
    echo "Error: git is required but not found." >&2
    exit 1
  fi
fi

clone_repo
cd "$CONFIG_DIR"
install_homebrew
brew bundle
stow home
