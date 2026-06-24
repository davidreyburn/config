#!/usr/bin/env bash
# deploy.sh — symlink dotfiles into place on a new machine
# Run once after cloning this repo: bash deploy.sh

set -e

REPO="$(cd "$(dirname "$0")" && pwd)/dotfiles"

link() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  backing up $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sf "$src" "$dst"
  echo "  linked $dst"
}

echo "→ shell"
link "$REPO/zshrc"            "$HOME/.zshrc"

echo "→ git"
link "$REPO/gitconfig"        "$HOME/.gitconfig"
link "$REPO/gitignore_global" "$HOME/.gitignore_global"

echo "→ ssh"
link "$REPO/ssh/config"       "$HOME/.ssh/config"
chmod 644 "$HOME/.ssh/config"

echo "→ ghostty"
link "$REPO/ghostty/config"   "$HOME/.config/ghostty/config"

echo "→ neovim"
if [ ! -d "$HOME/.config/nvim" ]; then
  echo "  cloning kickstart.nvim..."
  git clone https://github.com/nvim-lua/kickstart.nvim.git "$HOME/.config/nvim"
fi
link "$REPO/nvim/init.lua"             "$HOME/.config/nvim/init.lua"
link "$REPO/nvim/colors/phosphor.lua"  "$HOME/.config/nvim/colors/phosphor.lua"

echo ""
echo "Done. Open a new terminal and run 'nvim' then :lua vim.pack.update() to install plugins."
