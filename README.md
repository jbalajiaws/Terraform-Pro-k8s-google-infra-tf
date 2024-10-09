  Haproxy check:
===============

#Note: 
**  Please check this after 5 minutes once server has been created. **


**cat /etc/hosts**

      [balaji_jothimani2023@haproxy ~]$ cat /etc/hosts
      127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
      ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
      10.128.0.2 haproxy.us-central1-c.c.studied-biplane-437904-h9.internal haproxy  # Added by Google
      169.254.169.254 metadata.google.internal  # Added by Google
       10.128.0.2  haproxy
       10.128.0.3  k8s-master-1
       10.128.0.4  k8s-master-2
       10.128.0.5  k8s-master-3
       10.128.0.6  k8s-worker-1
       10.128.0.7  k8s-worker-2
       10.128.0.8  k8s-worker-3

**grep '^SELINUX=' /etc/selinux/config**

      [balaji_jothimani2023@haproxy ~]$ grep '^SELINUX=' /etc/selinux/config
      SELINUX=disabled

**cat /etc/fstab**

      [balaji_jothimani2023@haproxy ~]$ cat /etc/fstab
      UUID=6a8ecdd1-b74e-424f-bb5a-8622afe13e82 /                       xfs     defaults        0 0
      UUID=914C-E55B          /boot/efi               vfat    defaults,uid=0,gid=0,umask=077,shortname=winnt 0 2

**systemctl status firewalld**

      [balaji_jothimani2023@haproxy ~]$ systemctl status firewalld
      ○ firewalld.service - firewalld - dynamic firewall daemon
           Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; preset: enabled)
           Active: inactive (dead)
             Docs: man:firewalld(1)

      Oct 09 09:19:33 localhost systemd[1]: Starting firewalld - dynamic firewall daemon...
      Oct 09 09:19:35 localhost systemd[1]: Started firewalld - dynamic firewall daemon.
      Oct 09 09:19:41 haproxy systemd[1]: Stopping firewalld - dynamic firewall daemon...
      Oct 09 09:19:41 haproxy systemd[1]: firewalld.service: Deactivated successfully.
      Oct 09 09:19:41 haproxy systemd[1]: Stopped firewalld - dynamic firewall daemon.

**ll /etc/haproxy**

      [balaji_jothimani2023@haproxy ~]$ ll /etc/haproxy
      total 8
      drwxr-xr-x. 2 root root    6 Jan 25  2024 conf.d
      -rw-r--r--. 1 root root  948 Oct  9 09:20 haproxy.cfg
      -rw-r--r--. 1 root root 3284 Jan 25  2024 haproxy.cfg_old

**cat /etc/haproxy/haproxy.cfg**

      [balaji_jothimani2023@haproxy ~]$ cat /etc/haproxy/haproxy.cfg
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
          server kube-master1 10.128.0.3:6443 check # Replace the IP address without quotes.
          server kube-master2 10.128.0.4:6443 check # Replace the IP address without quotes.
          server kube-master3 10.128.0.5:6443 check # Replace the IP address without quotes.


========================

Kube Master check:
========================

#Note: 
**  Please check this after 5 minutes once server has been created. **


**cat /etc/hosts**

    10.128.0.3 k8s-master-1.us-central1-c.c.studied-biplane-437904-h9.internal k8s-master-1  # Added by Google
    169.254.169.254 metadata.google.internal  # Added by Google
     10.128.0.2  haproxy
     10.128.0.3  k8s-master-1
     10.128.0.4  k8s-master-2
     10.128.0.5  k8s-master-3
     10.128.0.6  k8s-worker-1
     10.128.0.7  k8s-worker-2
     10.128.0.8  k8s-worker-3

**grep '^SELINUX=' /etc/selinux/config**

    [balaji_jothimani2023@k8s-master-1 ~]$ grep '^SELINUX=' /etc/selinux/config
    SELINUX=disabled

**cat /etc/fstab**

    [balaji_jothimani2023@k8s-master-1 ~]$ cat /etc/fstab
    UUID=6a8ecdd1-b74e-424f-bb5a-8622afe13e82 /                       xfs     defaults        0 0
    UUID=914C-E55B          /boot/efi               vfat    defaults,uid=0,gid=0,umask=077,shortname=winnt 0 2

**systemctl status firewalld**

    [balaji_jothimani2023@k8s-master-1 ~]$ systemctl status firewalld
    ○ firewalld.service - firewalld - dynamic firewall daemon
       Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; preset: enabled)
         Active: inactive (dead)
         Docs: man:firewalld(1)
  
      Oct 09 09:19:34 localhost systemd[1]: Starting firewalld - dynamic firewall daemon...
      Oct 09 09:19:36 localhost systemd[1]: Started firewalld - dynamic firewall daemon.
      Oct 09 09:19:43 k8s-master-1 systemd[1]: Stopping firewalld - dynamic firewall daemon...
      Oct 09 09:19:43 k8s-master-1 systemd[1]: firewalld.service: Deactivated successfully.
      Oct 09 09:19:43 k8s-master-1 systemd[1]: Stopped firewalld - dynamic firewall daemon.

**ll /etc/yum.repos.d**

    [balaji_jothimani2023@k8s-master-1 ~]$ ll /etc/yum.repos.d
    total 28
    -rw-r--r--. 1 root root 4245 Mar 20  2024 centos-addons.repo
    -rw-r--r--. 1 root root 2600 Mar 20  2024 centos.repo
    -rw-r--r--. 1 root root 1919 Oct  9 09:21 **docker-ce.repo**
    -rw-r--r--. 1 root root  591 Sep 19 13:41 google-cloud.repo
    -rw-r--r--. 1 root root  235 Oct  9 09:22 **kubernetes.repo**
    -rw-r--r--. 1 root root  358 Sep 19 13:41 redhat.repo

**sudo systemctl status containerd**

    [balaji_jothimani2023@k8s-master-1 ~]$ sudo systemctl status containerd
    ● containerd.service - containerd container runtime
         Loaded: loaded (/usr/lib/systemd/system/containerd.service; enabled; preset: disabled)
        Active: active (running) since Wed 2024-10-09 09:22:53 UTC; 13min ago
           Docs: https://containerd.io
       Main PID: 75087 (containerd)
          Tasks: 7
         Memory: 16.9M
            CPU: 692ms
         CGroup: /system.slice/containerd.service
                 └─75087 /usr/bin/containerd

        Oct 09 09:22:53 k8s-master-1 containerd[75087]: time="2024-10-09T09:22:53.859866723Z" level=info msg="Start sub>
        Oct 09 09:22:53 k8s-master-1 containerd[75087]: time="2024-10-09T09:22:53.860449460Z" level=info msg="Start rec>
        Oct 09 09:22:53 k8s-master-1 containerd[75087]: time="2024-10-09T09:22:53.860596865Z" level=info msg="Start eve>
        Oct 09 09:22:53 k8s-master-1 containerd[75087]: time="2024-10-09T09:22:53.860634160Z" level=info msg="Start sna>
        Oct 09 09:22:53 k8s-master-1 containerd[75087]: time="2024-10-09T09:22:53.860651114Z" level=info msg="Start cni>
        Oct 09 09:22:53 k8s-master-1 containerd[75087]: time="2024-10-09T09:22:53.860672977Z" level=info msg="Start str>
        Oct 09 09:22:53 k8s-master-1 containerd[75087]: time="2024-10-09T09:22:53.861035748Z" level=info msg=serving...>
        Oct 09 09:22:53 k8s-master-1 containerd[75087]: time="2024-10-09T09:22:53.861191800Z" level=info msg=serving...>
        Oct 09 09:22:53 k8s-master-1 containerd[75087]: time="2024-10-09T09:22:53.861570773Z" level=info msg="container>
        Oct 09 09:22:53 k8s-master-1 systemd[1]: Started containerd container runtime.
        lines 1-21/21 (END)

**cat /etc/containerd/config.toml | grep SystemdCgroup**

    [balaji_jothimani2023@k8s-master-1 ~]$ cat /etc/containerd/config.toml | grep SystemdCgroup
            SystemdCgroup = true

**cat /proc/sys/net/ipv4/ip_forward**

    [balaji_jothimani2023@k8s-master-1 ~]$ cat /proc/sys/net/ipv4/ip_forward
    1

**cat /etc/sysctl.d/kube.conf**

    [balaji_jothimani2023@k8s-master-1 ~]$ cat /etc/sysctl.d/kube.conf
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-ip6tables = 1
    net.ipv4.ip_forward = 1

**kubelet --version**
    [balaji_jothimani2023@k8s-master-1 ~]$ kubelet --version
       Kubernetes v1.27.16

**kubeadm version**

    [balaji_jothimani2023@k8s-master-1 ~]$ kubeadm version
    kubeadm version: &version.Info{Major:"1", Minor:"27", GitVersion:"v1.27.16", GitCommit:"cbb86e0d7f4a049666fac0551e8b02ef3d6c3d9a", GitTreeState:"clean", BuildDate:"2024-07-17T01:52:04Z",     GoVersion:"go1.22.5", Compiler:"gc", Platform:"linux/amd64"}


**kubectl version --client**

    [balaji_jothimani2023@k8s-master-1 ~]$ kubectl version --client
    **Client Version: v1.30.5-dispatcher
    Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3**
