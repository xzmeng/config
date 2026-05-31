#!/usr/bin/bash

set -euo pipefail

REPO_URL="https://github.com/xzmeng/config.git"
CONFIG_DIR="$HOME/config"

BREW_PATHS=(
  /opt/homebrew/bin/brew
  /usr/local/bin/brew
  /home/linuxbrew/.linuxbrew/bin/brew
)

BREW=""
BREW_PREFIX=""

# ── helpers ──

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

ensure_brew() {
  local brew_path
  if ! brew_path=$(find_brew); then
    install_homebrew_deps
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    brew_path=$(find_brew) || {
      echo "Error: Homebrew installation completed but brew binary not found." >&2
      echo "Please add Homebrew to your PATH manually and re-run this script." >&2
      exit 1
    }
  fi

  echo "Homebrew already installed: $("$brew_path" --version | head -1)"
  eval "$("$brew_path" shellenv)"

  BREW="$brew_path"
  BREW_PREFIX=$("$brew_path" --prefix)
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

setup_zsh() {
  if ! command -v apt-get &>/dev/null; then
    return 0
  fi

  if ! command -v zsh &>/dev/null; then
    echo "Installing zsh..."
    sudo apt-get update -qq
    sudo apt-get install -y -qq zsh
  fi

  local zsh_path
  zsh_path=$(command -v zsh)
  if [[ -z "$zsh_path" ]]; then
    echo "zsh not found, skipping shell setup."
    return 0
  fi

  if ! grep -qFx "$zsh_path" /etc/shells; then
    echo "Adding $zsh_path to /etc/shells..."
    echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
  fi

  if [[ "$SHELL" != "$zsh_path" ]]; then
    echo "Changing default shell to $zsh_path..."
    sudo chsh -s "$zsh_path" "$USER"
  fi

  if [[ -z "${ZSH_VERSION:-}" ]]; then
    echo "Switching to zsh..."
    exec "$zsh_path"
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

setup_zsh
clone_repo
cd "$CONFIG_DIR"
ensure_brew
"$BREW" bundle
"$BREW_PREFIX/bin/stow" home
