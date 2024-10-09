#!/bin/bash
sudo setenforce 0
sudo sed -i --follow-symlinks 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

sudo systemctl stop firewalld
sudo systemctl disable firewalld

sudo cat <<EOT >> /etc/hosts
 10.128.0.1  haproxy
 10.128.0.1  k8s-master-1
 10.128.0.1  k8s-master-2
 10.128.0.1  k8s-master-3
 10.128.0.1  k8s-worker-1
 10.128.0.1  k8s-worker-2
 10.128.0.1  k8s-worker-3
EOT

sudo yum install haproxy -y
sudo mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg_old


# Create the file with the specified content
sudo cat <<EOT > /etc/haproxy/haproxy.cfg
global
    log /dev/log  local0 warning
    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     4000
    user        haproxy
    group       haproxy
    daemon
    stats socket /var/lib/haproxy/stats

defaults
  log global
  option  httplog
  option  dontlognull
        timeout connect 5000
        timeout client 50000
        timeout server 50000

frontend kube-apiserver
  bind *:6443
  mode tcp
  option tcplog
  default_backend kube-apiserver

backend kube-apiserver
    mode tcp
    option tcplog
    option tcp-check
    balance roundrobin
    default-server inter 10s downinter 5s rise 2 fall 2 slowstart 60s maxconn 250 maxqueue 256 weight 100
    server kube-master1 "CHANGE-ME":6443 check # Replace the IP address without quotes.
    server kube-master2 "CHANGE-ME":6443 check # Replace the IP address without quotes.
    server kube-master3 "CHANGE-ME":6443 check # Replace the IP address without quotes.
EOT

