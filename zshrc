# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set the dotfiles variable
export DOTFILES=$HOME/dotfiles

# We need this to properly display UTF-8 symbols
export LC_ALL=en_IN.UTF-8
export LANG=en_IN.UTF-8

# We need this for X11 forwarding
export DISPLAY=$(hostname).local:0

# We need this for 24bit colors
export TERM="screen-256color"

# Editor variable
# (needed for when programs search for the default editor)
export EDITOR=nvim

# Auto start TMUX
ZSH_TMUX_AUTOSTART=true

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

# Import custom zshrc
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
