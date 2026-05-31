# config

Personal dotfiles and development environment, managed via [Homebrew](https://brew.sh) and [GNU Stow](https://www.gnu.org/software/stow/).

## One-line install

```bash
curl -fsSL https://raw.githubusercontent.com/xzmeng/config/main/install.sh | bash
```

## What gets installed

**CLI tools** — stow, gh, bat, eza, fzf, starship, tmux, zoxide, neovim, lazygit, btop, zsh-autosuggestions, zsh-syntax-highlighting

**macOS apps** (via Homebrew Cask & MAS) — Ghostty, Alfred, VS Code, Google Chrome, Claude, Stats, Magnet, Thor, and more

**Linux** — zsh via Homebrew, plus build-essential and other dependencies

**Dotfiles** — stowed from the `home/` directory into `$HOME`

## What's in this repo

```
.
├── Brewfile        # Homebrew packages, casks, and MAS apps
├── home/           # Dotfiles (stowed to $HOME)
├── install.sh      # Bootstrap script
└── TODO.md
```
