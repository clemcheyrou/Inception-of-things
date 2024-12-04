#!/bin/bash

sudo apt-get update
sudo apt-get install ca-certificates curl

# https://docs.gitlab.com/charts/installation/tools.html
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

# helm install
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh


k3d cluster create bonus-cluster

helm init
helm repo add gitlab https://charts.gitlab.io/
helm repo update

# kubectl create namespace gitlab
# kubectl create -f gitlab-role.yaml
# kubectl apply --namespace gitlab -f gitlab-role-bind.yml

# helm install --namespace gitlab --generate-name -f values.yaml gitlab/gitlab-runner
# sleep 10

# helm ls -A
# kubectl describe pods gitlab --namespace=gitlab

helm upgrade --install gitlab gitlab/gitlab \
    --version 8.6.1 \
    --set global.hosts.domain=example.com \
    --set certmanager-issuer.email=me@example.com

