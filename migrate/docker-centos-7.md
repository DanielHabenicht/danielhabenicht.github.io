1. Prerequisite for Docker is container-se-linux, you have to install it manually (from: https://stackoverflow.com/a/46209054/9277073)
    a. Search for the latest se-linux-container: http://mirror.centos.org/centos/7/extras/x86_64/Packages/ and install it:
    b. `$ yum install -y http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.66-1.el7.noarch.rpm`
2. Go on and install Docker (https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-centos-7)
    a. `$ curl -fsSL https://get.docker.com/ | sh`
    b. `$ sudo systemctl start docker`
    c. `$ sudo systemctl enable docker`

Attention CentOS7's FirewallD and Docker do not like each other:

1. This command makes them behave (From: https://unix.stackexchange.com/questions/199966/how-to-configure-centos-7-firewalld-to-allow-docker-containers-free-access-to-th):
   `$ firewall-cmd --permanent --zone=trusted --change-interface=docker0`
2. Furthermore, to allow communication between docker Containers (From: https://support.onegini.com/hc/en-us/articles/115000769311-Firewalld-error-with-Docker-No-route-to-host-)
    a. $ firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 4 -i docker0 -j ACCEPT
3. `$ firewall-cmd --reload`
4. `$ systemctl restart docker`
 

Allow some ports:

https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-7

 sudo firewall-cmd --zone=public --permanent --add-service=http

 sudo firewall-cmd --zone=public --permanent --add-service=https

 

Install docker-compose:

https://docs.docker.com/compose/install/#install-compose

If on Puppet Image set TMP: https://github.com/docker/compose/issues/1339#issuecomment-415068438

 

If there still is an error like "no route to host":

https://forums.docker.com/t/no-route-to-host-network-request-from-container-to-host-ip-port-published-from-other-container/39063/6

Add some networks to the firewall, for example 172.17...20.0.0/16

 

Set Proxy: https://docs.docker.com/config/daemon/systemd/#httphttps-proxy

[Service]
Environment="HTTP_PROXY=http://iproxy.domain.de:8080/" "NO_PROXY=localhost,127.0.0.1,.domain.de"

Go on with installation of kubernetes: https://www.techrepublic.com/article/how-to-install-a-kubernetes-cluster-on-centos-7/

 

https://medium.com/@gargankur74/setting-up-standalone-kubernetes-cluster-behind-corporate-proxy-on-ubuntu-16-04-1f2aaa5a848

https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
