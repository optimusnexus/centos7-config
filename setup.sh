#!/bin/bash

kubectl_version="1.18.0"
kubens_version="0.9.0"
kubectx_version="0.9.0"

# install apps
app_list="tmux git hub jq tmux vim wget curl nodejs npm"
ssh_keys="dle_rsa"

sudo apt-get install -y ${app_list}

# Check for the current user in sudoers group

# Copy profile files over to the home folder
files=".tmux.conf .bashrc .gitconfig .vimrc"

for f in ${files}
do
  echo "Copying ${f} to home directory..."
  cp ./${f} ~/
done


echo "Installing vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install Vim Plugins
echo "Installing Vim Plugins..."
vim +'PlugInstall --sync' +qa

# Coc-Vim extensions
echo "Installing Coc Extensions"
mkdir -p ~/.config/coc/extensions
cp package.json ~/.config/coc/extensions/

vim +'CocInstall' +qa

# Copy private ssh keys
echo "Copying Private Keys"
for f in ${ssh_keys}
do
  cp ${f} ~/.ssh/
  sudo chmod 600 ~/.ssh/${f}
done

# setup kubectl
echo "Setting up kubectl"
curl -LO https://storage.googleapis.com/kubernetes-release/release/vi${kubectl_version}/bin/linux/amd64/kubectl
sudo mv kubectl /usr/local/bin/

# setup kubectx
curl -LO https://github.com/ahmetb/kubectx/releases/download/v${kubectx_version}/kubectx_v${kubectx_version}_linux_x86_64.tar.gz
tar zxvf kubectx_v${kubectx_version}_linux_x86_64.tar.gz
sudo mv kubectx /usr/local/bin/
rm kubectx_v${kubectx_version}_linux_x86_64.tar.gz

# setup kubens
curl -LO https://github.com/ahmetb/kubectx/releases/download/v${kubens_version}/kubens_v${kubens_version}_linux_x86_64.tar.gz
tar zxvf kubens_v${kubens_version}_linux_x86_64.tar.gz
sudo mv kubens /usr/local/bin/
rm kubens_v${kubens_version}_linux_x86_64.tar.gz

# Install AWS cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws/

rm LICENSE
