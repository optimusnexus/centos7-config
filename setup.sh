#!/bin/bash

kubectl_version="1.18.0"
kubens_version="0.9.0"
kubectx_version="0.9.0"
terraform_version="0.12.25"
vault_version="1.4.1"
consul_version="1.7.3"
circleci_version="0.1.7868"


remove_apps="docker docker-engine docker.io"
app_list="tmux git hub jq tmux vim wget curl nodejs npm unzip -qq docker.io python3-pip"
files=".tmux.conf .bashrc .gitconfig .vimrc"
ssh_keys="dle_rsa dle_rsa.pub dle-key.pem"
coc_extension="clangd docker highlight html json python snippets xml yaml"
install_path="/tmp/install/"
create_folders="~/git/ ~/docker ~/vault ~/terraform"
original_path=""

function log () {
  echo "[$( date "+%Y-%m-%d %H:%M:%S %Z" )] (${FUNCNAME[1]}): $1"
}

function remove_apps() {
  log "Removing apps [${remove_apps}]..."
  sudo apt -qq remove -y ${remove_apps}
  log "Done."
}

function update_system() {
  log "Updating APT..."
  sudo apt -qq update -y
  log "Upgrading Packages with APT..."
  sudo apt -qq upgrade -y
  log "Cleaning up with APT..."
  sudo apt -qq autoremove -y
  log "Done."
}


function install_apps() {
  log "Installing apps [${app_list}] with APT..."
  sudo apt -qq install -y ${app_list}
  log "Post Setup..."

  sudo systemctl start docker
  sudo systemctl enable docker
  sudo groupadd docker
  sudo usermod -aG docker $USER
  log "Done."
}


function setup_install() {
  log "Working in directory [${install_path}]"
  mkdir -p ${install_path}
  original_path=$( pwd )
  cd ${install_path}
}

function install_kubectl() {
  setup_install
  if [ $# -eq 1 ]; then kubectl_version="${1}"; fi
  # setup kubectl
  log "Installing kubectl [${kubectl_version}]..."
  url="https://storage.googleapis.com/kubernetes-release/release/v${kubectl_version}/bin/linux/amd64/kubectl"
  log "Fetching kubectl at [${url}]"
  curl -LOsS ${url}
  log "Deploying kubectl..."
  sudo chmod 777 kubectl
  sudo chown root:root kubectl
  sudo mv kubectl /usr/local/bin/
  log "Done."
  cleanup_install
}

function install_kubectx() {
  setup_install
  if [ $# -eq 1 ]; then kubectx_version="${1}"; fi
  log "Installing kubectx [${kubectx_version}]..."
  COMPDIR=$(pkg-config --variable=completionsdir bash-completion)
  url="https://github.com/ahmetb/kubectx/releases/download/v${kubectx_version}/kubectx_v${kubectx_version}_linux_x86_64.tar.gz"
  log "Fetching kubectx at [${url}]..."
  curl -LOsS ${url}
  log "Deploying kubectx..."
  tar zxf kubectx_v${kubectx_version}_linux_x86_64.tar.gz
  sudo chmod 777 kubectx
  sudo chown root:root kubectx
  sudo mv kubectx /usr/local/bin/
  rm kubectx_v${kubectx_version}_linux_x86_64.tar.gz
  curl -LOsS https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/kubectx.bash -o ${COMPDIR}/kctx
  curl -LOsS https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/kubectx.bash -o ${COMPDIR}/kubectx
  log "Done."
  cleanup_install
}

function install_kubens() {
  setup_install
  if [ $# -eq 1 ]; then kubens_version="${1}"; fi
  log "Installing kubens [${kubens_version}]..."
  url="https://github.com/ahmetb/kubectx/releases/download/v${kubens_version}/kubens_v${kubens_version}_linux_x86_64.tar.gz"
  log "Fetching kubens at [${url}]..."
  curl -LOsS ${url}
  log "Deploying kubens..."
  tar zxf kubens_v${kubens_version}_linux_x86_64.tar.gz
  sudo chmod 777 kubens
  sudo chown root:root kubens
  sudo mv kubens /usr/local/bin/
  rm kubens_v${kubens_version}_linux_x86_64.tar.gz
  curl -LOsS https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/kubens.bash -o ${COMPDIR}/kns
  curl -LOsS https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/kubens.bash -o ${COMPDIR}/kubens
  log "Done."
  cleanup_install
}

function install_terraform() {
  setup_install
  if [ $# -eq 1 ]; then terraform_version="${1}"; fi
  log "Installing Terraform [${terraform_version}]..."
  url="https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip"
  log "Fetching Terraform at [${url}]..."
  curl -LOsS ${url}
  log "Deploying Terraform..."
  unzip -qq terraform_${terraform_version}_linux_amd64.zip
  sudo chmod 777 terraform
  sudo chown root:root terraform
  sudo mv terraform /usr/local/bin/
  log "Done."
  cleanup_install
}

function install_vault() {
  setup_install
  if [ $# -eq 1 ]; then vault_version="${1}"; fi
  log "Installing Vault [${vault_version}]..."
  url="https://releases.hashicorp.com/vault/${vault_version}/vault_${vault_version}_linux_amd64.zip"
  log "Fetching Vault at [${url}]..."
  curl -LOsS ${url}
  log "Deploying Vault..."
  unzip -qq vault_${vault_version}_linux_amd64.zip
  sudo chmod 777 vault
  sudo chown root:root vault
  sudo mv vault /usr/local/bin/
  log "Done."
  cleanup_install
}

function install_consul(){
  setup_install
  if [ $# -eq 1 ]; then consul_version="${1}"; fi
  log "Installing Consul [${consul_version}]..."
  url="https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip"
  log "Fetching Consul from [${url}]..."
  curl -LOsS ${url}
  log "Deploying Consul..."
  unzip -qq consul_${consul_version}_linux_amd64.zip
  sudo chmod 777 consul
  sudo chown root:root consul
  sudo mv consul /usr/local/bin/
  log "Done."
  cleanup_install
}

function install_circleci(){
  setup_install
  if [ $# -eq 1 ]; then circleci_version="${1}"; fi
  log "Installing CircleCI [${circleci_version}]..."
  url="https://github.com/CircleCI-Public/circleci-cli/releases/download/v${circleci_version}/circleci-cli_${circleci_version}_linux_amd64.tar.gz"
  log "Fetching CircleCI from [${url}]..."
  curl -LOsS ${url}
  log "Deploying CircleCI..."
  tar zxf circleci-cli_${circleci_version}_linux_amd64.tar.gz
  cd circleci-cli_${circleci_version}_linux_amd64
  sudo chown root:root circleci
  sudo chown 777 circleci
  sudo mv circleci /usr/local/bin/
  cd ..
  log "Done."
  cleanup_install
}

function install_aws(){
  setup_install
  log "Installing AWS CLI [latest]..."
  url="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
  log "Fetching AWS CLI from [${url}]..."
  curl -LOsS ${url} -o "awscliv2.zip"
  log "Deploying AWS CLI..."
  unzip -qq awscliv2.zip
  sudo ./aws/install
  log "Done."
  cleanup_install
}

function cleanup_install() {
  log "Cleaning up Installation Folder [${install_path}]..."
  cd ${original_path}
  rm -rf ${install_path}
  log "Done."
}

function copy_files(){
  log "Copying files to Home Directory..."
  for f in ${files}
  do
    log "Copying ${f} to home directory..."
    cp ./${f} ~/
  done
  log "Done."

  log "Copying SSH Keys..."
  log "Copying Private Keys"
  for f in ${ssh_keys}
  do
    cp ${f} ~/.ssh/
    sudo chmod 600 ~/.ssh/${f}
  done
  log "Done"
}

function install_vim_plugins() {
  log "Installing vim-plug"
  curl -fLOSso ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  log "Installing Coc Extensions"
  mkdir -p ~/.config/coc/extensions
  orig_path=$( pwd )
  cd ~/.config/coc/extensions
  log '{"dependencies":{}}'> package.json
  for f in ${coc_extension}
  do
    npm install coc-${f} --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
  done
  log "Done."
}

function setup_all(){
  copy_files
  remove_apps
  update_system
  install_apps
  install_kubectl
  install_kubectx
  install_kubens
  install_vault
  install_consul
  install_terraform
  install_circleci
  install_vim_plugins
}
