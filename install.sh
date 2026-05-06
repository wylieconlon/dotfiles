#!/bin/sh
# install.sh — symlink dotfiles into $HOME and apply macOS defaults.
# Safe to re-run; existing symlinks are skipped, real files are warned about.

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
SKIP_FILES="install.sh macos.sh Brewfile README.md vim .gitignore .git .DS_Store"

# -----------------------------------------------------------------------------
# Symlink top-level dotfiles into $HOME (gitconfig -> ~/.gitconfig, etc.)
# -----------------------------------------------------------------------------
cutstring="DO NOT EDIT BELOW THIS LINE"

for name in "$DOTFILES_DIR"/*; do
  basename=$(basename "$name")
  case " $SKIP_FILES " in
    *" $basename "*) continue ;;
  esac

  target="$HOME/.$basename"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    cutline=$(grep -n -m1 "$cutstring" "$target" 2>/dev/null | sed "s/:.*//")
    if [ -n "$cutline" ]; then
      cutline=$((cutline-1))
      echo "Updating $target"
      head -n $cutline "$target" > update_tmp
      startline=$(sed '1!G;h;$!d' "$name" | grep -n -m1 "$cutstring" | sed "s/:.*//")
      if [ -n "$startline" ]; then
        tail -n $startline "$name" >> update_tmp
      else
        cat "$name" >> update_tmp
      fi
      mv update_tmp "$target"
    else
      echo "WARNING: $target exists but is not a symlink — skipping. Back it up and re-run."
    fi
  elif [ ! -e "$target" ]; then
    echo "Creating symlink $target -> $name"
    if grep -q "$cutstring" "$name" 2>/dev/null; then
      cp "$name" "$target"
    else
      ln -s "$name" "$target"
    fi
  fi
done

# Symlink the vim runtime directory
if [ ! -e "$HOME/.vim" ]; then
  echo "Creating symlink $HOME/.vim -> $DOTFILES_DIR/vim"
  ln -s "$DOTFILES_DIR/vim" "$HOME/.vim"
fi

# -----------------------------------------------------------------------------
# macOS defaults — apply system settings I rely on.
# -----------------------------------------------------------------------------
if [ "$(uname)" = "Darwin" ]; then
  echo "Applying macOS defaults..."
  sh "$DOTFILES_DIR/macos.sh"
fi

echo "Done. You may need to log out for some macOS changes to take effect."
