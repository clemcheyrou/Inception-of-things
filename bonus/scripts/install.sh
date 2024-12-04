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


kubectl apply -f gitlab-admin-service-account.yaml
kubectl config view --raw \
-o=jsonpath='{.clusters[0].cluster.certificate-authority-data}' \
| base64 --decode
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep gitlab | awk '{print $1}')

kubectl create namespace gitlab-runner
helm repo add gitlab https://charts.gitlab.io
helm install --namespace gitlab-runner gitlab-runner -f gitlab-runner.yaml gitlab/gitlab-runner


