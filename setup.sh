#!/usr/bin/env bash
# Dotfiles setup wizard. Run directly after cloning, or via bootstrap.sh.
#
# Usage:
#   ./setup.sh                 interactive checkbox wizard
#   ./setup.sh --all           install everything (no prompts)
#   ./setup.sh --yes           accept the auto-detected defaults (no prompts)
#   ./setup.sh shell nvim ...  only the named modules (no prompts)
#   ./setup.sh --list          list module keys and exit
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES

# shellcheck source=lib/common.sh
. "$DOTFILES/lib/common.sh"
# shellcheck source=lib/ui.sh
. "$DOTFILES/lib/ui.sh"
# shellcheck source=lib/modules.sh
. "$DOTFILES/lib/modules.sh"

# ---- parse args ----------------------------------------------------------
MODE="wizard"        # wizard | yes | all | explicit
EXPLICIT=()
for a in "$@"; do
  case "$a" in
    --all)  MODE="all" ;;
    --yes|-y) MODE="yes" ;;
    --list) printf '%s\n' "${MODULES[@]}"; exit 0 ;;
    -h|--help) sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*) err "unknown flag: $a"; exit 2 ;;
    *)  MODE="explicit"; EXPLICIT+=("$a") ;;
  esac
done

step "Dotfiles setup  (${OS}, pkg: ${PKG:-none})"
ensure_pkg || { err "Need a package manager to continue."; exit 1; }

# ---- detect + build defaults --------------------------------------------
# Default ON for everything detected-useful except conda. Already-installed
# modules stay selectable so their config still gets (re)linked.
CB_LABELS=(); CB_NOTES=(); CB_STATE=()
for key in "${MODULES[@]}"; do
  label="$(eval "echo \"\$mod_${key}_label\"")"
  desc="$(eval "echo \"\$mod_${key}_desc\"")"
  if "mod_${key}_detect" >/dev/null 2>&1; then note="installed"; else note=""; fi
  default=1; [ "$key" = "conda" ] && default=0
  CB_LABELS+=("$(printf '%-22s %s' "$label" "${C_DIM}$desc${C_RESET}")")
  CB_NOTES+=("$note")
  CB_STATE+=("$default")
done

# ---- choose what to run --------------------------------------------------
SELECTED=()
case "$MODE" in
  all)      SELECTED=(); for _ in "${MODULES[@]}"; do SELECTED+=(1); done ;;
  yes)      SELECTED=("${CB_STATE[@]}") ;;
  explicit) SELECTED=(); for key in "${MODULES[@]}"; do
              hit=0; for e in "${EXPLICIT[@]}"; do [ "$e" = "$key" ] && hit=1; done
              SELECTED+=("$hit"); done ;;
  wizard)   checkbox_menu "Select what to install / configure:" ;;
esac

# ---- run -----------------------------------------------------------------
ran=0
for i in "${!MODULES[@]}"; do
  [ "${SELECTED[$i]}" = "1" ] || continue
  key="${MODULES[$i]}"
  step "$(eval "echo \"\$mod_${key}_label\"")"
  if "mod_${key}_run"; then ok "${key} done"; ran=$((ran + 1)); else err "${key} failed"; fi
done

if [ "$ran" -eq 0 ]; then warn "Nothing selected."; exit 0; fi
step "Done — ${ran} module(s) configured"
log "Open a new terminal or run: ${C_BOLD}exec zsh${C_RESET}"
