#!/bin/bash

# install apps
app_list = "tmux git jq tmux vim wget curl"
ssh_keys="dle_rsa"

sudo apt-get install -y ${app_list}

# Check for the current user in sudoers group

# Copy ssh key
cp dle ~/.ssh/
sudo chmod 600 ~/.ssh/dle_rsa

# Copy profile files over to the home folder
files = ".tmux.conf .bashrc .git kube-ps1.sh .vimrc"

for f in files
do
  cp $f ~/
done


echo "Installing vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install Vim Plugins
echo "Installing Vim Plugins..."
vim +'PlugInstall --sync' +qa

# Copy private ssh keys
echo "Copying Private Keys"
for f in ${ssh_keys}
do
  cp ${f} ~/.ssh/
  sudo chmod 600 ~/.ssh/${f}
done
