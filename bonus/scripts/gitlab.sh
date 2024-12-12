#!/bin/bash

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
