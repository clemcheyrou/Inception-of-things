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

kubectl create namespace gitlab

cat > pd-ssd-storage.yaml <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: pd-ssd
provisioner: kubernetes.io/gce-pd
parameters:
  type: pd-ssd
EOF
kubectl apply -f pd-ssd-storage.yaml

helm upgrade --install gitlab gitlab/gitlab \
  --namespace gitlab \
  --set global.hosts.domain=gitlab.example.com \
  --set global.hosts.gitlab.path=gitlab \
  --set global.hosts.disableCertmanager=true \
  --set certmanager-issuer.email=dummy@example.com \
  --set gitlab-runner.runners.privileged=true \
  --set global.smtp.openssl_verify_mode='none' \
  --set global.email.display_name='DevOps Gitlab'
