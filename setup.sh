#!/bin/bash

kubectl_version="1.18.0"
kubens_version="0.9.0"
kubectx_version="0.9.0"
terraform_version="0.12.24"
vault_version=""
consul_version=""

remove_apps="docker docker-engine docker.io"
app_list="tmux git hub jq tmux vim wget curl nodejs npm unzip docker.io"
files=".tmux.conf .bashrc .gitconfig .vimrc"
ssh_keys="dle_rsa dle_rsa.pub dle-key.pem"
coc_extension="clangd docker highlight html json python snippets xml yaml"

# remove apps
sudo apt remove -y ${remove_apps}

# install apps
sudo apt install -y ${app_list}

# setup kubectl
echo "Setting up kubectl"
curl -LO https://storage.googleapis.com/kubernetes-release/release/v${kubectl_version}/bin/linux/amd64/kubectl
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

# setup terraform
curl -LO https://releases.hashicorp.com/terraform/0.12.24/terraform_${terraform_version}_linux_amd64.zip
unzip terraform_${terraform_version}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_${terraform_version}_linux_amd64.zip

# Install AWS cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws/
rm LICENSE

# Copy profile files over to the home folder
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
orig_path=$( pwd )
cd ~/.config/coc/extensions
echo '{"dependencies":{}}'> package.json
for f in ${coc_extension}
do
  npm install coc-${f} --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
done
cd ${orig_path}

# Copy private ssh keys
echo "Copying Private Keys"
for f in ${ssh_keys}
do
  cp ${f} ~/.ssh/
  sudo chmod 600 ~/.ssh/${f}
done

echo "Final Setup..."
sudo systemctl start docker
sudo systemctl enable docker
sudo groupadd docker
sudo usermod -aG docker $USER
