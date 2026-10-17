# shellcheck shell=bash
# Common helpers: logging, OS/pkg detection, symlinking. Sourced by setup.sh.

# ---- colors / logging ----------------------------------------------------
if [ -t 1 ]; then
  C_RESET=$'\033[0m'; C_DIM=$'\033[2m'; C_BOLD=$'\033[1m'
  C_BLUE=$'\033[34m'; C_GREEN=$'\033[32m'; C_YELLOW=$'\033[33m'; C_RED=$'\033[31m'; C_CYAN=$'\033[36m'
else
  C_RESET=; C_DIM=; C_BOLD=; C_BLUE=; C_GREEN=; C_YELLOW=; C_RED=; C_CYAN=
fi

log()   { printf '%s\n' "${C_DIM}·${C_RESET} $*"; }
info()  { printf '%s\n' "${C_BLUE}▸${C_RESET} $*"; }
ok()    { printf '%s\n' "${C_GREEN}✓${C_RESET} $*"; }
warn()  { printf '%s\n' "${C_YELLOW}!${C_RESET} $*" >&2; }
err()   { printf '%s\n' "${C_RED}✗${C_RESET} $*" >&2; }
step()  { printf '\n%s\n' "${C_BOLD}${C_CYAN}== $* ==${C_RESET}"; }

# ---- platform ------------------------------------------------------------
OS="unknown"
case "$(uname -s)" in
  Darwin) OS="macos" ;;
  Linux)  OS="linux" ;;
esac

PKG=""        # high-level package manager: brew | apt
if command -v brew >/dev/null 2>&1; then PKG="brew"
elif command -v apt-get >/dev/null 2>&1; then PKG="apt"; fi

have() { command -v "$1" >/dev/null 2>&1; }

# Ensure we have a usable package manager; installs Homebrew on macOS if missing.
ensure_pkg() {
  if [ -n "$PKG" ]; then return 0; fi
  if [ "$OS" = "macos" ]; then
    info "Installing Homebrew (no package manager found)…"
    # stdin may be a pipe (curl | bash); Homebrew needs a tty for sudo.
    if [ -r /dev/tty ]; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/tty
    else
      NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    local b
    for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
      [ -x "$b" ] && { eval "$("$b" shellenv)"; break; }
    done
    if ! command -v brew >/dev/null 2>&1; then
      err "Homebrew install failed. Install it manually, then re-run:"
      err '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
      return 1
    fi
    PKG="brew"
  else
    err "No supported package manager (brew/apt) found."
    return 1
  fi
}

# pkg_install <brew-formula> [apt-package]   apt name defaults to brew name
pkg_install() {
  local brew_name="$1" apt_name="${2:-$1}"
  case "$PKG" in
    brew) brew list --formula "$brew_name" >/dev/null 2>&1 || brew install "$brew_name" ;;
    apt)  sudo apt-get install -y "$apt_name" ;;
    *)    err "Cannot install $brew_name: no package manager"; return 1 ;;
  esac
}

# ---- symlinking ----------------------------------------------------------
# link_file <source-in-repo> <dest-path>   (backs up an existing real file)
link_file() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ]; then
    [ "$(readlink "$dest")" = "$src" ] && { log "linked $dest"; return 0; }
    rm -f "$dest"
  elif [ -e "$dest" ]; then
    mv "$dest" "$dest.bak.$(date +%s 2>/dev/null || echo bak)"
    warn "backed up existing $dest"
  fi
  ln -s "$src" "$dest"
  ok "linked $dest -> $src"
}
