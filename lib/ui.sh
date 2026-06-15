# shellcheck shell=bash
# Interactive checkbox UI. Reads from /dev/tty so it works under `curl | bash`.
#
# checkbox_menu sets the global array SELECTED (parallel to the labels passed in)
# to 1/0. Inputs:
#   CB_LABELS  - array of labels
#   CB_NOTES   - array of right-side annotations (e.g. "installed")
#   CB_STATE   - array of initial 0/1 defaults
# Controls: ↑/↓ or k/j move, space toggles, a all, n none, enter confirm, q quit.

checkbox_menu() {
  local title="$1"
  local n=${#CB_LABELS[@]}
  local cur=0 i key

  # Non-interactive fallback: no tty (e.g. piped, CI). Keep defaults.
  if [ ! -t 0 ] && [ ! -e /dev/tty ]; then
    SELECTED=("${CB_STATE[@]}")
    return 0
  fi

  printf '\n%s\n' "${C_BOLD}${title}${C_RESET}"
  printf '%s\n' "${C_DIM}↑/↓ move · space toggle · a all · n none · enter confirm${C_RESET}"

  _draw() {
    local j mark pointer label note
    for j in $(seq 0 $((n - 1))); do
      [ "${CB_STATE[$j]}" = "1" ] && mark="${C_GREEN}◉${C_RESET}" || mark="○"
      [ "$j" -eq "$cur" ] && pointer="${C_CYAN}❯${C_RESET}" || pointer=" "
      label="${CB_LABELS[$j]}"
      note="${CB_NOTES[$j]}"
      [ -n "$note" ] && note=" ${C_DIM}(${note})${C_RESET}"
      printf '%s %s %s%s\n' "$pointer" "$mark" "$label" "$note"
    done
  }

  _draw
  while true; do
    IFS= read -rsn1 key </dev/tty || break
    if [ "$key" = $'\033' ]; then           # arrow escape sequence: ESC [ A/B
      read -rsn2 key </dev/tty               # (no fractional -t: unsupported on bash 3.2)
      case "$key" in
        '[A') key=k ;; '[B') key=j ;;
      esac
    fi
    case "$key" in
      k) cur=$(((cur - 1 + n) % n)) ;;
      j) cur=$(((cur + 1) % n)) ;;
      ' ') [ "${CB_STATE[$cur]}" = "1" ] && CB_STATE[$cur]=0 || CB_STATE[$cur]=1 ;;
      a) for i in $(seq 0 $((n - 1))); do CB_STATE[$i]=1; done ;;
      n) for i in $(seq 0 $((n - 1))); do CB_STATE[$i]=0; done ;;
      q) err "Aborted."; exit 130 ;;
      '') break ;;                            # enter
    esac
    printf '\033[%dA' "$n"                     # move cursor back up
    _draw
  done
  SELECTED=("${CB_STATE[@]}")
}

confirm() {  # confirm "question?"  -> yes returns 0
  local q="$1" ans
  [ ! -e /dev/tty ] && return 0
  printf '%s [Y/n] ' "$q" >/dev/tty
  read -r ans </dev/tty || ans=""
  case "$ans" in [nN]*) return 1 ;; *) return 0 ;; esac
}
