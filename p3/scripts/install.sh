sudo apt-get update
sudo apt-get install ca-certificates curl

# install docker
curl -fsSL https://get.docker.com/ | sh

# install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d --version

# install kubectl
curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

# create a single node cluster
k3d cluster create dev-cluster --port 8080:80@loadbalancer --port 8080:443@loadbalancer

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

sleep 10

kubectl apply -f IOT/p3/confs/application.yaml

kubectl port-forward svc/argocd-server -n argocd 8080:443
