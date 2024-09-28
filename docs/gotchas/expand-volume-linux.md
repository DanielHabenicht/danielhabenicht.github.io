# Expand a volume 
e.g. after resizing the virtual disk in proxmox. 

```bash
# Check volume sizes
lsblk
sudo fdisk /dev/sdb
# p - print
# d - delete partition entry
# n - new partition entry, keep defaults or previous values
# Do NOT remove the signature
# w - write changes
sudo resize2fs /dev/sdb1
df -h

```

> Remove reserved space from partition: `sudo tune2fs -m 0 /dev/sdb1`
