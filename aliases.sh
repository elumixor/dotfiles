# Editors
alias vim=nvim
alias vi=nvim
alias :q=exit
alias c=code                                   # VS Code (the `vscode` module puts `code` on PATH)

# Claude Code
alias cl='claude --dangerously-skip-permissions'   # bypass all permission checks

# Git
alias glog="git log --graph --branches --remotes --tags --pretty --format=format:'%C(normal ul)%s%C(reset) %C(auto)%d%C(reset) %n%C(dim white)%an | %C(reset)%C(dim cyan italic)%h%C(reset) | %C(dim yellow)%cr%C(reset) %n'"

# JS / package scripts (bun)
alias nrd="bun run dev"
alias nrb="bun run build"
alias nrl="bun run lint"
alias nrel="bun run eslint"
alias ci="rm -rf node_modules package-lock.json && npm i"

# Python / conda
alias p=python3
alias pm='p -m'
alias m=micromamba

# GitHub Copilot CLI
alias '??'='gh copilot suggest'

# Manage these dotfiles from anywhere
#   dotfiles update   pull latest (configs are symlinked, so they update in place)
#   dotfiles setup    re-run the install wizard (pass flags, e.g. --all)
#   dotfiles edit     open the repo in $EDITOR
#   dotfiles cd       cd into the repo
dotfiles() {
  local d="${DOTFILES:-$HOME/.dotfiles}"
  case "${1:-}" in
    update|up|pull) git -C "$d" pull --ff-only ;;
    setup|wizard)   "$d/setup.sh" "${@:2}" ;;
    edit|code)      "${EDITOR:-nvim}" "$d" ;;
    cd)             cd "$d" || return 1 ;;
    *) printf 'usage: dotfiles {update|setup|edit|cd}\n' ;;
  esac
}
