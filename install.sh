set -x
set -e

# Make symlinks to dotfiles in home directory
DOTFILES=$(pwd)

# Remove files if they exist
rm -rf ~/.config
rm -rf ~/.oh-my-zsh
rm -rf ~/.zshrc
rm -rf ~/.config
rm -rf ~/.tmux.conf
rm -rf ~/.tmux

# Make a directory that's needed
mkdir -p ~/.config/nvim

ln -s ${DOTFILES}/tmux.conf ~/.tmux.conf
ln -s ${DOTFILES}/init.vim ~/.config/nvim/init.vim

# Install stuff non-interactively
export DEBIAN_FRONTEND=noninteractive
TZ=Europe/Prague
sudo touch /etc/timezone
sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && sudo sh -c "echo $TZ > /etc/timezone"

# Install packages
sudo apt-get update
sudo apt-get -yqq install software-properties-common
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt-get update
sudo apt-get install \
             zsh \
             curl wget \
             git \
             tmux \
             neovim \
             python3-dev python3-pip \
             language-pack-en \
             -y

# Change the default shell to zsh
sudo chsh -s /bin/zsh $(whoami)

# Install oh-my-zsh
curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh -s -- --unattended

# Install starship
curl -sS https://starship.rs/install.sh | sudo sh -s -- --yes

# We are installing fzf via git, as the apt version is outdated
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install --completion --key-bindings --no-update-rc

# Install oh-my-zsh plugins:
# zsh-nvm
git clone --depth=1 https://github.com/lukechilds/zsh-nvm \
          ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-nvm

# auto-suggestions
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
          ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# syntax highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
          ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# base16-shell colors
git clone --depth=1 https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell && \
    mkdir ~/.oh-my-zsh/plugins/base16-shell && \
    ln -s ~/.config/base16-shell/base16-shell.plugin.zsh \
          ~/.oh-my-zsh/plugins/base16-shell/base16-shell.plugin.zsh

# vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Tmux Plugin Manager
git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# We need the following to install Tmux Plugins Automatically
tmux start-server && \
     tmux new-session -d && \
     sleep 1 && \
     ~/.tmux/plugins/tpm/scripts/install_plugins.sh && \
     tmux kill-server

# Install NVM and node.js@14
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash && \
    export NVM_DIR=~/.nvm && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install 14

# Install miniconda
curl https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh \
    -o conda.sh && \
    zsh conda.sh -b && \
    rm conda.sh

# Install the neovim plugins
nvim --headless +PlugInstall +qall

# Replace the generated zshrc and starship.toml
rm -rf ~/.zshrc && ln -s ${DOTFILES}/zshrc ~/.zshrc
rm -rf ~/.config/starshp.toml && ln -s ${DOTFILES}/starship.toml ~/.config/starship.toml

# Start the zsh shell
exec zsh
