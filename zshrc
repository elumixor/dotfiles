# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Add .local/bin to path
export PATH=$PATH:$HOME/.local/bin

# Set the dotfiles variable
export DOTFILES=$HOME/dotfiles

# We need this to properly display UTF-8 symbols
export LC_ALL=en_IN.UTF-8
export LANG=en_IN.UTF-8

# We need this for X11 forwarding
export DISPLAY=$(hostname).local:0

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

# Import custom zshrc
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# add Go to $PATH
export PATH=/usr/local/go/bin:$PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/elumixor/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/elumixor/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/elumixor/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/elumixor/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/home/elumixor/miniconda3/etc/profile.d/mamba.sh" ]; then
    . "/home/elumixor/miniconda3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE='/home/elumixor/.local/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/elumixor/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<


# bun completions
[ -s "/home/elumixor/.bun/_bun" ] && source "/home/elumixor/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Load Angular CLI autocompletion.
source <(ng completion script)
