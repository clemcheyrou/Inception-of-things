apt-get install curl

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --server https://$1 --token 12345" sh -s -
