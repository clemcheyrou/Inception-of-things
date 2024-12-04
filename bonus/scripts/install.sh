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

# Create generic secret
sudo kubectl create secret generic gitlab-tls-secret \                                                         
  --namespace gl \
  --from-file=/root/devops/certs/devops.crt 
 
# Create TLS secret
sudo kubectl create secret tls example-tls-secret \                                                     
  --namespace gl \           
  --cert=/root/certs/devops.pem \    
  --key=/root/certs/devops.key

helm upgrade --install gitlab gitlab/gitlab \                                                            
  --namespace gl \
  --set global.hosts.domain=gitlab.example.com \
  --set global.hosts.gitlab.path=gitlab \
  --set global.hosts.disableCertmanager=true \
  --set certmanager-issuer.email=dummy@example.com \
  --set global.hosts.secretName=example-tls-secret \
  --set gitlab-runner.runners.privileged=true \
  --set global.edition=ce \
  --set gitlab.webservice.ingress.tls.secretName=example-tls-secret \
  --set global.ingress.tls.secretName=example-tls-secret \
  --set global.smtp_enabled=true \
  --set global.smtp.address='smtp-outbound.example.com' \
  --set global.smtp.port=25 \
  --set global.smtp.domain='smtp-outbound.example.com' \
  --set global.smtp.tls=false \
  --set global.smtp.openssl_verify_mode='none' \
  --set global.email.display_name='DevOps Gitlab' \
  --set global.email.from='no_reply@example.com' \
  --set global.email.reply_to='no_reply@example.com' \
  --set global.tls.secretName=example-tls-secret
