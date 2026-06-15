# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Add .local/bin to path
export PATH=$PATH:$HOME/.local/bin

# Resolve the dotfiles location from this file's real path (follows the symlink)
export DOTFILES="${DOTFILES:-${${(%):-%x}:A:h}}"

# We need this to properly display UTF-8 symbols
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# We need this for 24bit colors, as well as italics
export TERM="xterm-256color"

# Editor variable
# (needed for when programs search for the default editor)
export EDITOR=nvim

# Auto start TMUX
ZSH_TMUX_AUTOSTART=false

# Set theme
ZSH_THEME="agnoster"

# How the history stamp is displayed
HIST_STAMPS="dd.mm.yyyy"

# First try to suggest from history, then from completion
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Which plugins would you like to load?
plugins=(
  git
  base16-shell
  zsh-autosuggestions
  zsh-syntax-highlighting
  tmux
)

# This should be the last line of Oh My Zsh configuration
source $ZSH/oh-my-zsh.sh

# Source our aliases
source $DOTFILES/aliases.sh

# Start starship
eval "$(starship init zsh)"

# NVM
export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Conda
source $DOTFILES/conda_init.sh

# Source FZF config and start it
source $DOTFILES/fzf.sh

# -- KEY BINDINGS -- #
# Execute suggestion on Ctrl+Space
bindkey '^ ' autosuggest-execute

# FZF file on Ctrl+E
zle     -N            fzf-file-widget
bindkey -M emacs '^E' fzf-file-widget
bindkey -M vicmd '^E' fzf-file-widget
bindkey -M viins '^E' fzf-file-widget
bindkey -r '^T'

# Homebrew (macOS arm64 / Intel / Linuxbrew) — pick whichever exists
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  [ -x "$_brew" ] && { eval "$("$_brew" shellenv)"; break; }
done
unset _brew

# bun
export BUN_INSTALL="$HOME/.bun"
[ -d "$BUN_INSTALL/bin" ] && export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"   # completions

# Go
[ -d /usr/local/go/bin ] && export PATH=/usr/local/go/bin:$PATH

# Import machine-specific config (not tracked in the repo)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
