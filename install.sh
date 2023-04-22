#!/bin/bash

# Install dependencies
sudo apt-get update
sudo apt-get install git zsh curl -y

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

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Add kubectl plugin to Oh My Zsh and set aliases
sed -i 's/plugins=(git)/plugins=(git kubectl)/g' ~/.zshrc
echo "alias oc='kubectl'" >> ~/.zshrc
echo "function kn() { kubectl config set-context \$(kubectl config current-context) --namespace=\$1; }" >> ~/.zshrc

# Install kubectl autocompletion
mkdir -p ~/.zsh
kubectl completion zsh > ~/.zsh/_kubectl

# Update ~/.zshrc file to include kubectl autocompletion
echo "source ~/.zsh/_kubectl" >> ~/.zshrc

# Change the default shell to zsh
chsh -s $(which zsh)

echo "Zsh, kubectl alias (oc), and namespace change alias (kn) are now installed. Please restart your terminal to start using them."
