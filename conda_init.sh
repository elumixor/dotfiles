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
# <<< conda initialize <<<

