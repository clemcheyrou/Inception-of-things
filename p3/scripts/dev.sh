#!/bin/bash

kubectl create namespace dev
kubectl apply -f '../dev/dev.yaml'
sleep 10

kubectl wait pod \
--all \
--for=condition=Ready \
--namespace=dev

kubectl -n dev get pods
echo "All pods are ready"

kubectl port-forward svc/dev-service -n dev 8888:8080