#!/usr/bin/env zsh
set -e

DOTFILES_DIR="$HOME/.dotfiles"

# Files to symlink: source (relative to ~/.dotfiles) → target (in ~)
files=(
  "zshrc:.zshrc"
  "tmux.conf:.tmux.conf"
)

for entry in "${files[@]}"; do
  src="${DOTFILES_DIR}/${entry%%:*}"
  dst="$HOME/${entry#*:}"

  if [[ -L "$dst" ]]; then
    echo "[skip]  $dst already exists (symlink)"
  elif [[ -e "$dst" ]]; then
    echo "[warn]  $dst already exists (not a symlink). Backing up to ${dst}.bak"
    mv "$dst" "${dst}.bak"
    ln -s "$src" "$dst"
    echo "[link]  $dst → $src"
  else
    ln -s "$src" "$dst"
    echo "[link]  $dst → $src"
  fi
done

echo "Done."
