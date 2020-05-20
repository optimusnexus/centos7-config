#!/bin/bash

mkdir ~/git
cd ~/git

git_repos="infrops Infrops-infra-terraform infrops-helm Infrops-terraform"

for i in ${git_repos}
do
  git clone git@github.com:globalvisioninc/${i}.git

done
