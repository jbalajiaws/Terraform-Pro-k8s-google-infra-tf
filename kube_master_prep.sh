#!/bin/bash
sudo su -
sudo setenforce 0
sudo sed -i --follow-symlinks 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fsta

sudo systemctl stop firewalld
sudo systemctl disable firewalld

sudo cat <<EOT >> /etc/hosts
 10.128.0.2  haproxy
 10.128.0.3  k8s-master-1
 10.128.0.4  k8s-master-2
 10.128.0.5  k8s-master-3
 10.128.0.6  k8s-worker-1
 10.128.0.7  k8s-worker-2
 10.128.0.8  k8s-worker-3
EOT

#Docker Installation
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install containerd.io  -y
sudo systemctl start containerd
sudo systemctl enable containerd

# Set up the containerd config
sudo mkdir /etc/containerd
sudo containerd config default | tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

systemctl restart containerd

#netfilter config
sudo modprobe br_netfilter
sudo echo 1 > /proc/sys/net/ipv4/ip_forward

# This overwrites any existing configuration in /etc/yum.repos.d/kubernetes.repo
sudo cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.27/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.27/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF


sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet


sudo cat <<EOT > /etc/sysctl.d/kube.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOT


sudo sudo yum install nmap-ncat -y  #installing netcat tool


