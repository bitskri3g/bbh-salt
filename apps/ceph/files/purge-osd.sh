#!/bin/bash

## This script will find all OSDs associated with the host per ceph osd tree
## and remove them from the cluster.  It will NOT rebalance prior to removal.
## This script will also wipe the filesystem of the backing device after
## unmounting.  The backing devices are derivce from the local osd mount point

## This script will also remove the host from the crush map and wipe the journals

ceph osd tree | awk '/{{ hostname }}/{flag=1;next}/storage/{flag=0}flag' | awk '{ print $1}' | while read osd_id
  do
    ceph osd down $osd_id
    ceph osd out $osd_id
    systemctl stop ceph-osd@$osd_id.service
    ceph osd crush remove osd.$osd_id
    ceph auth del osd.$osd_id
    ceph osd rm $osd_id

    disk=$(mount | grep "/ceph-$osd_id " | cut -d' ' -f1)
    mount=$(mount | grep "/ceph-$osd_id " | cut -d' ' -f3)

    sed -i '\:'$disk':d' /etc/fstab
    rm -rf $mount
    umount $mount
    wipefs -f -a $disk
  done

parted -s /dev/nvme0n1 mklabel gpt
parted -s /dev/nvme1n1 mklabel gpt
parted -s /dev/nvme2n1 mklabel gpt
parted -s /dev/nvme3n1 mklabel gpt

rm -rf /var/lib/ceph/osd/*

ceph osd crush remove {{ hostname }}
