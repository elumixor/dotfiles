# Initialize FZF
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS"
    --margin=0,2
    --color=fg:-1,bg:-1,hl:#5f87af
    --color=fg+:#ff8330,bg+:,hl+:#5fd7ff
    --color=info:#afaf87,prompt:#e00061,pointer:#e00061
    --color=marker:#87ff00,spinner:#2f3770,header:#87afaf
    --preview-window noborder
    --bind ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down"

export FZF_CTRL_T_OPTS="--preview='bat {-1} --color=always'"
export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'

fd_git() {
    # Check if we're in a git repo
    if [ -d .git ]; then
        # If we are, use git ls-files
        preview="git diff $@ --color=always -- {-1}"
        git diff $@ --name-only | fzf -m --ansi --preview $preview
    fi

    # If we're not in a git repo, just do nothing
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# FZF git modified and untracked files on Ctrl+G
zle -N fd_git{,}
bindkey '^G' fd_git
