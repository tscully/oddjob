#!/bin/bash 
echo "create k8s head node ubuntu"
sleep 3
echo
echo "Disable swap until next reboot"
echo 
sudo swapoff -a

echo "Update the local node"
sudo apt-get update && sudo apt-get upgrade -y
echo
echo "Install Docker"
sleep 3

sudo apt-get install -y docker.io
echo
echo "Install kubeadm and kubectl"
sleep 3

sudo sh -c "echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' >> /etc/apt/sources.list.d/kubernetes.list"

sudo sh -c "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -"

sudo apt-get update

sudo apt-get install -y kubeadm kubelet kubectl

echo
echo "Installed - now to get Calico Project network plugin"

sleep 3

sudo kubeadm init --pod-network-cidr 10.244.0.0/16

sleep 5

echo "Running the steps explained at the end of the init output for you"

mkdir -p $HOME/.kube

sleep 2

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sleep 2

sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "Download Calico and apply"

wget  https://docs.projectcalico.org/v3.8/manifests/calico.yaml -O calico.yaml

sudo sed -i 's/\"192\.168\.0\.0\/16\"/\"10\.240\.0\.0\/16\"/g' calico.yaml

kubectl apply -f calico.yaml

echo
echo
sleep 3
echo "You should see this node in the output below"
echo "It can take a minute for node to show Ready status"
echo
kubectl get node



