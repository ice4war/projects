   #!/bin/env bash
   # setup packages
   sudo apt update
   sudo apt install -y samba samba-common
   sudo apt install -y lvm2 xfsprogs nfs-kernel-server

   # Create Volumes
   sudo pvcreate /dev/sdb /dev/sdc
   sudo vgcreate nfs_storage /dev/sdb /dev/sdc
   sudo lvcreate -l 100%FREE -n nfs_share nfs_storage
   sudo mkfs.xfs /dev/nfs_storage/nfs_share
   sudo mkdir -p /media/storage
   echo "/dev/nfs_storage/nfs_share /media/storage xfs defaults 0 0" |sudo tee -a /etc/fstab

   # Export filesystem
   echo "/media/storage  192.168.0.0/24(rw,sync,no_root_squash)"|sudo tee -a /etc/exports
   sudo exportfs -afs
   sudo mount -a

   # Restart Services
   sudo systemctl restart nfs-kernel-server.service  rpcbind.service
