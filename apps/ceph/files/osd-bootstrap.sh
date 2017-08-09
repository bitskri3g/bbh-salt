#!/bin/bash

# Create new OSD and internally keep track of metrics required for deployment and activation.  This
# script should be called in a jinja2 for loop in salt using the hdd and journal names in the pillar
# as variables.  See pillar/apps/ceph/cluster/storage-node-v1-mapping.sls

## Things this script DOES NOT do:
## 1. Include admin keyring or conf file
## This script should be for OSD bootstrapping only

## Check if mon is listening/active
nc -z 10.10.6.0 6789

if [ $? -eq 1 ]
  then
    echo 'No active monitor detected...try again later'
    exit
fi

## Check for existence of active OSD data
is_active="$(mount | grep {{ disk }})"

if [ "$is_active" != "" ]
  then
    echo 'Backing device already active...exiting'
    echo $is_active
    exit
fi

## Check for existing XFS filesystem
is_formatted="$(file -sL {{ disk }} | grep "SGI XFS")"

if [ "$is_formatted" != "" ]
  then
    echo 'Backing device already formatted with XFS...exiting'
    echo $is_formatted
    exit
fi

## Format disk with xfs
mkfs.xfs -f {{ disk }}

## Create new OSD and store OSD ID as $osd_id
osd_id="$(ceph osd create)"

## Make directory mount
mkdir -p /var/lib/ceph/osd/{{ cluster }}-$osd_id/

## Mount disk that will back the OSD.  This step assumes that you have
## already properly formatted the disk
mount {{ disk }} /var/lib/ceph/osd/{{ cluster }}-$osd_id/
echo -n '{{ disk }}        /var/lib/ceph/osd/{{ cluster }}-' >> /etc/fstab
echo -n $osd_id >> /etc/fstab
echo '    xfs     defaults        0   0' >> /etc/fstab

## Initialize new OSD
ln -s {{ journal }} /var/lib/ceph/osd/ceph-$osd_id/journal
ceph-osd -i $osd_id --mkfs --mkkey --mkjournal

## Authorize OSD for inclusion in the cluster
ceph auth add osd.$osd_id osd 'allow *' mon 'allow profile osd' -i /var/lib/ceph/osd/{{ cluster }}-$osd_id/keyring

## Add OSD to crush map
ceph osd crush add osd.$osd_id 1.0 host={{ hostname }}

## Set correct permissions
chown -R ceph:ceph /var/lib/ceph/osd/
chown ceph:ceph {{ journal }}

## Start OSD Service and enable on boot
systemctl start ceph-osd@$osd_id.service
systemctl enable ceph-osd@$osd_id.service
