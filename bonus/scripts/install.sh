#!/bin/bash

sudo apt-get update
sudo apt-get install curl

# https://docs.gitlab.com/charts/installation/tools.html
# install kubectl
if command -v kubectl &>/dev/null; then
  echo "Kubectl installation found"
else
  curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
  sudo chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin/kubectl
  kubectl version --client

  sleep 10
fi

if command -v docker &>/dev/null; then
  echo "Docker installation found"
else
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
fi

# install k3d
if command -v k3d &>/dev/null; then
  echo "K3d installation found"
else
  curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
  k3d --version
fi

# curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
# chmod 700 get_helm.sh
# ./get_helm.sh
#
# helm repo add gitlab https://charts.gitlab.io/
# helm repo update gitlab
# helm search repo -l gitlab/gitlab-runner | head -n10
# helm pull gitlab/gitlab-runner --version 0.61.0
# tar xf gitlab-runner-0.61.0.tgz
# cd gitlab-runner/

# create a single node cluster
k3d cluster create dev-cluster
bash ../scripts/gitlab.sh
