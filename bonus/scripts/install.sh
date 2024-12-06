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

# install docker
if command -v docker &> /dev/null; then
    echo "Docker installation found"
else
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
fi

# install k3d
if command -v k3d &> /dev/null; then
    echo "K3d installation found"
else
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
    k3d --version
fi

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

k3d cluster create dev-cluster -p 8080:80@loadbalancer
kubectl create namespace gitlab

helm repo add gitlab https://charts.gitlab.io
helm repo update gitlab
sudo helm upgrade --install gitlab gitlab/gitlab \
  -n gitlab \
  -f https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml \
  --set global.hosts.domain=example.com \
  --set global.hosts.externalIP=127.0.0.1 \
  --set global.hosts.https=false \
  --timeout 600s

echo "Wait gitlab pods running"
kubectl wait pod \
--all \
--for=condition=Ready \
--namespace=gitlab

echo "$(kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath='{.data.password}' | base64 --decode)"

kubectl port-forward svc/gitlab-webservice-default -n argocd 80:8181 > /dev/null 2>&1 &

# bash argocd.sh
# bash dev.sh