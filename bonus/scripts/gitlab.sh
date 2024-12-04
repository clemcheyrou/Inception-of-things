#! /bin/bash

kubectl create namespace gitlab

kubectl apply -n gitlab -f ../confs/gitlab/gitlab.yaml

kubectl wait pod \
  --all \
  --for=condition=Ready \
  --namespace=gitlab

kubectl -n gitlab get pods
echo "All pods are ready"
