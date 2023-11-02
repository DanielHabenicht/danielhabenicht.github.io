# Build of Home NAS/Server

Base Hardware: 

# Considerations

- Encryption at Rest for the whole system
- energy efficient
- 
- 


# Beginners Guide to Proxmox

- Virtualization
- local and local-lvm are the same disk just that one is folder and the second is a volume on the disk.


## Installation

1. Select right ethernet port device
2. Activate PCI Passthrough
```
# From https://pve.proxmox.com/pve-docs/pve-admin-guide.html#sysboot_edit_kernel_cmdline
# and https://pve.proxmox.com/pve-docs/pve-admin-guide.html#qm_pci_passthrough
nano /etc/default/grub
# Add or update line:
# GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on"
update-grub
reboot
dmesg | grep -e DMAR -e IOMMU -e AMD-Vi
# Should output: "DMAR: IOMMU enabled"
```
3. Install TrueNAS with PCI PassThrough for the SATA Port and SATA Controller

## Guides




TrueNAS: 

https://recoverit.wondershare.com/nas-recovery/truenas-proxmox.html
