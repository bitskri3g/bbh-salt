#!/bin/bash

remote_image_hash=$(curl -s http://10.10.3.249/hash | grep win.qcow2 | awk '{ print $1 }')
local_image_hash=$(sha512sum /home/usacys/vms/win.qcow2 | awk '{ print $1 }')

if [ "$remote_image_hash" == "$local_image_hash" ]
then
  echo Windows image is the latest version.  No changes required.
else
  curl -s http://10.10.3.249/win.qcow2 > /home/usacys/vms/win.qcow2
  echo Windows image hash mismatch or missing.  Updated image.
fi
