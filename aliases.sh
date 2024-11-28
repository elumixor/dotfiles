alias vim=nvim
alias vi=nvim

alias :q=exit

alias glog="git log --graph --branches --remotes --tags --pretty --format=format:'%C(normal ul)%s%C(reset) %C(auto)%d%C(reset) %n%C(dim white)%an | %C(reset)%C(dim cyan italic)%h%C(reset) | %C(dim yellow)%cr%C(reset) %n'"
alias nrd="bun run dev"
alias nrb="bun run build"
alias nrl="bun run lint"
alias nrel="bun run eslint"
alias m=micromamba
alias p=python3
alias pm='p -m'
alias c=code
alias ci="rm -rf node_modules package-lock.json && npm i"

update() {
    gf
    gm origin/develop
    g checkout --theirs package*
    npm i -D @webx-slots/core@replay @webx-slots/scripts@latest
    nrb
}
alias start-postgres='sudo service postgresql start'

comfyui() {
    echo "Running the ComfyUI"
    m run -n imgen python $HOME/ComfyUI/main.py --output-directory /mnt/stable_diffusion/ComfyUI \
    --input-directory /mnt/stable_diffusion/ComfyUI \
    --input-directory $HOME/ComfyUI \
    --output-directory /mnt/stable_diffusion/output
}

alias '??'='gh copilot suggest'
