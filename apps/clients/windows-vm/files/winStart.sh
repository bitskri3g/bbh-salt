#!/bin/bash

kvm                                                       \
-m 4096                                                   \
-smp 4                                                    \
-drive file=/home/usacys/vms/win.qcow2,if=virtio          \
-net user,smb=/home/$USERNAME/                            \
-net nic,model=virtio                                     \
-snapshot
