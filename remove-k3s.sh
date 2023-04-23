#!/bin/bash

echo "Stopping k3s service..."
sudo systemctl stop k3s

echo "Uninstalling k3s..."
sudo /usr/local/bin/k3s-uninstall.sh

echo "Removing k3s data directory..."
sudo rm -rf /var/lib/rancher/k3s/

echo "Removing k3s binary and config files..."
sudo rm -rf /usr/local/bin/k3s /etc/systemd/system/k3s.service /etc/systemd/system/k3s.service.env

echo "Removing iptables rules..."
sudo iptables -F && sudo iptables -X && sudo iptables -t nat -F && sudo iptables -t nat -X && sudo iptables -t mangle -F && sudo iptables -t mangle -X && sudo iptables -P INPUT ACCEPT && sudo iptables -P FORWARD ACCEPT && sudo iptables -P OUTPUT ACCEPT

echo "Removing systemctl settings..."
sudo sysctl -w net.bridge.bridge-nf-call-iptables=0 && sudo sysctl -w net.ipv4.conf.all.rp_filter=1 && sudo sysctl -w net.ipv4.conf.default.rp_filter=1

echo "Removing cgroup settings..."
sudo sed -i '/cgroup/d' /etc/fstab && sudo rm -rf /sys/fs/cgroup/systemd

echo "k3s successfully removed."
