#!bin/bash

# Install git
sudo apt-get update
sudo apt-get install git -y

# Clone the repository
git clone git@github.com:elumixor/dotfiles.git

# Run the install script
cd dotfiles
./install.sh
cd ..
