#!/bin/bash

# Install dependencies
sudo apt-get update
sudo apt-get install git zsh curl -y

################
# Install k3s
curl -sfL https://get.k3s.io | sh - 

# Create symlink 
sudo chmod a+rw /etc/rancher/k3s/k3s.yaml
sudo chmod a+rw /etc/rancher/k3s
sudo chmod a+rw /etc/rancher
sudo chmod a+rw /etc

mkdir -p /home/$USER/.kube/
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
chown $USER:$USER /home/$USER/.kube/config

#################
# Install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh

# Install kubectl-slice
echo "Installing kubectl-slice..."
curl -L "https://github.com/patrickdappollonio/kubectl-slice/releases/download/v1.2.5/kubectl-slice_linux_x86_64.tar.gz" | tar xz
sudo mv kubectl-slice /usr/local/bin/

# Install kustomize
echo "Installing kustomize..."
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
sudo mv kustomize /usr/local/bin/

echo "Installation complete!"
