#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname -s)"
ARCH="$(uname -m)"

echo "==> Detected: $OS on $ARCH"

# --- Resolve brew path based on OS and arch ---
if [[ "$OS" == "Darwin" ]]; then
  if [[ "$ARCH" == "arm64" ]]; then
    BREW_BIN="/opt/homebrew/bin/brew"
  else
    BREW_BIN="/usr/local/bin/brew"
  fi
elif [[ "$OS" == "Linux" ]]; then
  BREW_BIN="/home/linuxbrew/.linuxbrew/bin/brew"
else
  echo "Error: unsupported OS: $OS"
  exit 1
fi

# --- Install Homebrew if not present ---
if [[ ! -x "$BREW_BIN" ]]; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$($BREW_BIN shellenv)"

# --- Install packages from Brewfile ---
echo "==> Installing packages from Brewfile..."
brew bundle --file="$SCRIPT_DIR/Brewfile"

# --- Stow dotfiles ---
echo "==> Stowing dotfiles..."
cd "$SCRIPT_DIR"
stow --adopt -v home

echo "==> All done!"