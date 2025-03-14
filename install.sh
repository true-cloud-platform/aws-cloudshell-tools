#!/bin/bash

## - Locating scripts directory
SCRIPT_DIR=$(dirname ${BASH_SOURCE[0]})


# Install the packages from package manager
# sudo yum update -y

sudo yum install -y \
  bash-completion \
  nc

#yq
[ ! -f ~/.local/bin/yq ] && wget https://github.com/mikefarah/yq/releases/download/v4.45.1/yq_linux_amd64.tar.gz -O -| tar -xz && mv ~/yq_linux_amd64 ~/.local/bin/yq

#Helm
[ ! -f ~/.local/bin/helm ] && wget https://get.helm.sh/helm-v3.17.0-linux-amd64.tar.gz -O -|tar -xz && mv ~/linux-amd64/helm ~/.local/bin/helm

#Kustomize
[ ! -f ~/.local/bin/kustomize ] && wget https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.6.0/kustomize_v5.6.0_linux_amd64.tar.gz -O -| tar -xz && mv kustomize ~/.local/bin/kustomize

# FZF
[ ! -f ~/.local/bin/fzf ] && wget https://github.com/junegunn/fzf/releases/download/v0.58.0/fzf-0.58.0-linux_amd64.tar.gz -O -| tar -xz && mv fzf ~/.local/bin/fzf

#FluxCD
[ ! -f ~/.local/bin/flux ] && wget https://github.com/fluxcd/flux2/releases/download/v2.5.1/flux_2.5.1_linux_amd64.tar.gz -O -| tar -xz && mv flux ~/.local/bin/flux

#SOPS
[ ! -f ~/.local/bin/sops ] && wget https://github.com/getsops/sops/releases/download/v3.9.3/sops-v3.9.3.linux.amd64 -O ~/.local/bin/sops && chmod +x ~/.local/bin/sops

#EKSctl
[ ! -f ~/.local/bin/eksctl ] && wget https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz -O -| tar -xz && mv eksctl ~/.local/bin/eksctl

# Install dotfiles
cp ${SCRIPT_DIR}/dotfiles/home/.bashrc ~/
cp -r ${SCRIPT_DIR}/dotfiles/home/.fzf/ ~/
cp -r ${SCRIPT_DIR}/dotfiles/home/.ps1/ ~/

source ~/.bashrc

