sudo apt-get update
sudo apt-get install curl

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server" sh -s - --flannel-backend none --token 12345

# sudo mkdir -p /home/vagrant/.kube
# sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config

# TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)

# echo $TOKEN > /vagrant/token