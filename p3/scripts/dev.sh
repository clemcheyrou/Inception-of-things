#!/bin/bash

kubectl create namespace dev
kubectl apply -f '../dev/dev.yaml'

kubectl wait pod \
--all \
--for=condition=Ready \
--namespace=dev

kubectl -n dev get pods
echo "All pods are ready"