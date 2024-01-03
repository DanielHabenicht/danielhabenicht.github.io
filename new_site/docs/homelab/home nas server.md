# Build of Home NAS/Server

Base Hardware:

# Considerations

- Encryption at Rest for the whole system
- energy efficient
-
-

TrueNAS:
It's all about the right tool for the job (Remember TrueNAS it built for enterprises!)

- No supported Encryption of the boot medium (which contains quite a few secrets)
- Docker Containers and Running configurations are only supported on unencrypted ZFS Volumes

This led me to Proxmox which has a "fairly easy" way of encrypting VMs, allowing me to run all my machines encrypted (at rest).

I still choose TrueNAS for data storage (but not for hosting any services).

# Beginners Guide to Proxmox

- Virtualization
- local and local-lvm are the same disk just that one is folder and the second is a volume on the disk.

## Installation

### Encryption

https://privsec.dev/posts/linux/using-native-zfs-encryption-with-proxmox/

1. Select right ethernet port device
2. Activate PCI Passthrough

```
# From https://pve.proxmox.com/pve-docs/pve-admin-guide.html#sysboot_edit_kernel_cmdline
# and https://pve.proxmox.com/pve-docs/pve-admin-guide.html#qm_pci_passthrough
# For GRUB (not used with zfs)
nano /etc/default/grub
# Add or update line:
# GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on"
update-grub
# For systemd-boot
nano /etc/kernel/cmdline
# Add or update line:
# root=ZFS=rpool/ROOT/pve-1 boot=zfs intel_iommu=on
proxmox-boot-tool refresh
reboot
dmesg | grep -e DMAR -e IOMMU -e AMD-Vi
# Should output: "DMAR: IOMMU enabled"
```

```bash
# Unlock
ssh -o StrictHostKeyChecking=no 192.168.178.147 zfsunlock


```

3. Install TrueNAS with PCI PassThrough for the SATA Port and SATA Controller

Power Optimization

```
# Enable SATA Power management
line="@reboot echo 'med_power_with_dipm' > '/sys/class/scsi_host/host0/link_power_management_policy'"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -
line="@reboot echo 'med_power_with_dipm' > '/sys/class/scsi_host/host1/link_power_management_policy'"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -
line="@reboot echo 'med_power_with_dipm' > '/sys/class/scsi_host/host2/link_power_management_policy'"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -
line="@reboot echo 'med_power_with_dipm' > '/sys/class/scsi_host/host3/link_power_management_policy'"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -
line="@reboot echo 'med_power_with_dipm' > '/sys/class/scsi_host/host4/link_power_management_policy'"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -
line="@reboot echo 'med_power_with_dipm' > '/sys/class/scsi_host/host5/link_power_management_policy'"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -
line="@reboot echo 'med_power_with_dipm' > '/sys/class/scsi_host/host6/link_power_management_policy'"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -
# Use powersaving mode
line="@reboot echo 'powersave' | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -
```

# Use community packages

```

sed -i 's/https:\/\/enterprise/http:\/\/download/g' /etc/apt/sources.list.d/pve-enterprise.list
sed -i 's/enterprise/no-subscription/g' /etc/apt/sources.list.d/pve-enterprise.list

sed -i 's/https:\/\/enterprise/http:\/\/download/g' /etc/apt/sources.list.d/ceph.list
sed -i 's/enterprise/no-subscription/g' /etc/apt/sources.list.d/ceph.list
apt-get update
apt-get dist-upgrade
```

Activate 'Datacenter>Storage>Local' add snippets

## Template

https://austinsnerdythings.com/2021/08/30/how-to-create-a-proxmox-ubuntu-cloud-init-image/

```bash
# Prepare Image
cd /var/lib/vz/template/iso
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img


#sudo virt-customize -a focal-server-cloudimg-amd64.img --run-command 'useradd austin'
#sudo virt-customize -a focal-server-cloudimg-amd64.img --run-command 'mkdir -p /home/austin/.ssh'
#sudo virt-customize -a focal-server-cloudimg-amd64.img --ssh-inject austin:file:/home/austin/.ssh/id_rsa.pub
#sudo virt-customize -a focal-server-cloudimg-amd64.img --run-command 'chown -R austin:austin /home/austin'

qm create 9000 --name "ubuntu-cloudinit-template" --memory 2048 --agent 1 --net0 virtio,bridge=vmbr0

qm importdisk 9000 ubuntu-22.04-minimal-cloudimg-amd64.img local-zfs
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-9000-disk-0,cache=writethrough,ssd=1

qm set 9000 --boot c --bootdisk scsi0

qm set 9000 --ide2 local-zfs:cloudinit
qm set 9000 --serial0 socket --vga serial0

cat << EOF | tee /var/lib/vz/snippets/vendor.yaml
#cloud-config
runcmd:
    - apt update
    - apt install -y qemu-guest-agent nano
    - systemctl start qemu-guest-agent
    - curl -fsSL https://get.docker.com -o get-docker.sh
    - sudo sh get-docker.sh
# Taken from https://forum.proxmox.com/threads/combining-custom-cloud-init-with-auto-generated.59008/page-3#post-428772
EOF

qm set 9000 --cicustom "vendor=local:snippets/vendor.yaml"
qm set 9000 --ciuser ubuntu
qm set 9000 --sshkeys ~/.ssh/authorized_keys
qm set 9000 --ipconfig0 ip=dhcp
qm resize 9000 scsi0 32G


# Create a template
qm template 9000

qm clone 9000 999 --name test-clone-cloud-init
qm set 999 --sshkey ~/.ssh/id_rsa.pub
qm set 999 --ipconfig0 ip=10.98.1.96/24,gw=10.98.1.1
qm start 999
```

On the VM:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```


## VMs

> This would be the terraform part, but because of many bugs with the proxmox provider I will do it manually for now.

## Docker VM

- [dns](https://github.com/TechnitiumSoftware/DnsServer) via `bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/technitiumdns.sh)"`
- paperless 
- traefik
- monica
grafana + prometheus
- truenas through traefik

# Traefik

```bash
touch acme.json
root@ubuntu-docker-host:/home/ubuntu/traefik# chmod 600 acme.json
root@ubuntu-docker-host:/home/ubuntu/traefik# docker compose up
```


### Paperless NGX

```bash
mkdir -v ~/paperless-ngx
wget https://raw.githubusercontent.com/paperless-ngx/paperless-ngx/dev/docker/compose/docker-compose.postgres-tika.yml
wget https://raw.githubusercontent.com/paperless-ngx/paperless-ngx/dev/docker/compose/docker-compose.env

mkdir -v ~/traefik


mkdir -v ~/monica
# Change PAPERLESS_URL
```

# Backup:

```bash
sudo apt install cifs-utils psmisc

# ngx-paperless
## Export
cd /home/ubuntu/paperless-ngx
docker compose exec -T webserver document_exporter ../export --no-thumbnail --use-folder-prefix --zip
## Import 
document_importer source

## Trilium automatically creates backups in the data/backups directory

## Monica
docker-compose exec mysql /usr/bin/mysqldump -u root --password=sekret_root_password monica > monica.sql

cat << EOF | tee ~/.credentials
username=share
password=y7WXgvd@rZmG_h2fDAVNZdiBxghWuLdigXGd9BAFfM*T.J*_r7dct_mRsEE9xhzhjbgzd.qxN4sjWGDo9bh**66iULBQtc_UZQbg
domain=192.168.178.152
EOF

mkdir /mnt/truenas_backup
mount -t cifs -o credentials=~/.credentials //192.168.178.152/apps-backup /mnt/truenas_backup
# Check if it works
mount -t cifs

mkdir /mnt/truenas_backup/paperless-ngx
cp /home/ubuntu/paperless-ngx/export/*.zip /mnt/truenas_backup/paperless-ngx/
cp /home/ubuntu/trilium/trilium-data/backup/*.db /mnt/truenas_backup/trilium/

umount -t cifs /mnt/truenas_backup
```


# Updates

## Proxmox
    
```bash
apt update
apt full-upgrade

# Once you are sure you don't need to roll back
zpool status
zpool upgrade
```


## Guides

Everything: https://tteck.github.io/Proxmox/

TrueNAS:

https://recoverit.wondershare.com/nas-recovery/truenas-proxmox.html

## Other

https://github.com/danitso/terraform-provider-proxmox
https://olav.ninja/deploying-kubernetes-cluster-on-proxmox-part-1
