#!/usr/bin/bash

set -euo pipefail

install_homebrew() {
  if command -v brew &>/dev/null; then
    echo "Homebrew already installed: $(brew --version | head -1)"
    return 0
  fi

  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Homebrew may install to a path not on the default PATH:
  #   macOS Intel:      /usr/local/bin/brew       (usually on PATH)
  #   macOS Apple Silicon: /opt/homebrew/bin/brew  (not on PATH by default)
  #   Linux:            /home/linuxbrew/.linuxbrew/bin/brew (not on PATH by default)
  for brew_path in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [[ -x "$brew_path" ]]; then
      eval "$("$brew_path" shellenv)"
      break
    fi
  done

  if ! command -v brew &>/dev/null; then
    echo "Error: Homebrew installation completed but 'brew' is still not on PATH." >&2
    echo "Please add Homebrew to your PATH manually and re-run this script." >&2
    exit 1
  fi
}

install_homebrew
brew bundle
stow home
