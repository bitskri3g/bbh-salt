#!/bin/bash

### Check for existing partitions
for nvme_dev in {0..3}
  do nvme_dev+=n1
     has_partitions="$(parted /dev/nvme$nvme_dev print | grep primary)"
     if [ "$has_partitions" != "" ]
       then
       echo -n 'Found active partitions on nvme'
       echo -n $nvme_dev
       echo '...exiting'
       echo $has_partitions
       exit
     fi
done

### Create fresh gpt labels
parted -s /dev/nvme0n1 mklabel gpt
parted -s /dev/nvme1n1 mklabel gpt
parted -s /dev/nvme2n1 mklabel gpt
parted -s /dev/nvme3n1 mklabel gpt


### Create 6 partitions per device, approximately 120G in size
for part_num in {0..5}
  do sector_start=$(( $part_num * 249856000 + (($part_num + 1) * 2048)))
     sector_end=$(expr $sector_start + 249856000)
     sector_start+=s
     sector_end+=s
     parted -s /dev/nvme0n1 mkpart primary $sector_start $sector_end
     parted -s /dev/nvme1n1 mkpart primary $sector_start $sector_end
     parted -s /dev/nvme2n1 mkpart primary $sector_start $sector_end
     parted -s /dev/nvme3n1 mkpart primary $sector_start $sector_end
done
