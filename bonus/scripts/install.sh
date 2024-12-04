#!/bin/bash

sudo apt-get update
sudo apt-get install curl

# install kubectl
if command -v kubectl &> /dev/null; then
    echo "Kubectl installation found"
else
    curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
    sudo chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    kubectl version --client

    sleep 10
fi

k3d cluster create dev-cluster

helm repo add gitlab https://charts.gitlab.io
helm repo update

kubectl create namespace gitlab
helm install gitlab-runner gitlab/gitlab-runner -f values.yaml

