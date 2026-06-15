#!/usr/bin/env bash
# One-command bootstrap. Clones the dotfiles repo and launches the wizard.
#
#   curl -fsSL https://raw.githubusercontent.com/elumixor/dotfiles/main/bootstrap.sh | bash
#
# Pass-through flags reach setup.sh, e.g.:
#   curl -fsSL .../bootstrap.sh | bash -s -- --all
set -euo pipefail

REPO="${DOTFILES_REPO:-https://github.com/elumixor/dotfiles.git}"
DEST="${DOTFILES_DIR:-$HOME/.dotfiles}"

echo "▸ Dotfiles bootstrap"

# git is the only hard prerequisite.
if ! command -v git >/dev/null 2>&1; then
  echo "▸ Installing git…"
  if command -v brew >/dev/null 2>&1; then brew install git
  elif command -v apt-get >/dev/null 2>&1; then sudo apt-get update && sudo apt-get install -y git
  elif [ "$(uname -s)" = "Darwin" ]; then xcode-select --install || true
  else echo "✗ Please install git first." >&2; exit 1; fi
fi

if [ -d "$DEST/.git" ]; then
  echo "▸ Updating existing clone at $DEST"
  git -C "$DEST" pull --ff-only || true
else
  echo "▸ Cloning into $DEST"
  git clone --depth=1 "$REPO" "$DEST"
fi

cd "$DEST"
chmod +x setup.sh 2>/dev/null || true
exec bash setup.sh "$@"
