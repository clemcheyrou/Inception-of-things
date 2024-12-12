#!/bin/bash

sudo apt-get update
sudo apt-get install curl

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

# install docker
if command -v docker &>/dev/null; then
  echo "Docker installation found"
else
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
fi

sudo usermod -aG docker $USER

# install k3d
if command -v k3d &>/dev/null; then
  echo "K3d installation found"
else
  curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
  k3d --version
fi

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

k3d cluster create dev-cluster
kubectl create namespace gitlab
kubectl create namespace argocd
kubectl create namespace dev

helm repo add gitlab https://charts.gitlab.io
helm repo update gitlab
sudo helm upgrade --install gitlab gitlab/gitlab \
  -n gitlab \
  -f https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml \
  --set global.hosts.domain=gitlab.example.com \
  --set global.hosts.externalIP= \
  --set global.hosts.https=false \
  --timeout 1000s

echo "Wait gitlab pods running"
kubectl wait pod \
  --all \
  --for=condition=Ready \
  --namespace=gitlab \
  --timeout=1000s

echo "Gitlab password:"
echo "$(kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath='{.data.password}' | base64 --decode)" >gitlab_passwd
echo ""

kubectl port-forward svc/gitlab-webservice-default -n gitlab 80:8181 >/dev/null 2>&1 &

#sudo bash gitlab.sh
sudo bash argocd.sh
