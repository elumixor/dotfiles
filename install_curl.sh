#!bin/bash

# Install git
sudo apt-get update
sudo apt-get install git -y

# Clone the repository
git clone https://github.com/elumixor/dotfiles.git

# Run the install script
cd dotfiles
chmod +x install.sh
./install.sh
