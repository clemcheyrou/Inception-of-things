#!/bin/bash

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sleep 10

kubectl wait pod \
--all \
--for=condition=Ready \
--namespace=argocd

kubectl -n argocd get pods
echo "All pods are ready"

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo ""

kubectl apply -n argocd -f ../confs/ingress.yaml
kubectl apply -n argocd -f ../confs/project.yaml
kubectl apply -n argocd -f ../confs/argocd.yaml

kubectl port-forward svc/argocd-server -n argocd 8080:8888