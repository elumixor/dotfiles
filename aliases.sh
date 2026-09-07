# Editors
alias vim=nvim
alias vi=nvim
alias :q=exit
alias c='/Applications/Zed.app/Contents/MacOS/cli'   # Zed editor
alias z='/Applications/Zed.app/Contents/MacOS/cli'
alias code='/Applications/Zed.app/Contents/MacOS/cli'
alias zed='/Applications/Zed.app/Contents/MacOS/cli'

# Claude Code
alias cl='claude --dangerously-skip-permissions'   # bypass all permission checks

# Git
alias glog="git log --graph --branches --remotes --tags --pretty --format=format:'%C(normal ul)%s%C(reset) %C(auto)%d%C(reset) %n%C(dim white)%an | %C(reset)%C(dim cyan italic)%h%C(reset) | %C(dim yellow)%cr%C(reset) %n'"
alias gpa="git patch"                          # amend-all + force-push (the `patch` alias lives in gitconfig)

# JS / package scripts (bun)
alias nrd="bun run dev"
alias nrdo="bun run dev:open"
alias nri="bun run install"
alias nre="bun run deploy"
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
