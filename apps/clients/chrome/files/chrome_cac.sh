#!/bin/bash

for file in /usr/local/share/ca-certificates/*.crt
do
  certutil -d /home/$USERNAME/.pki/nssdb/ -A -t "CT,C,C" -n "$file" -i "$file"
done

cac_loaded="$(modutil -dbdir sql:/home/$USERNAME/.pki/nssdb/ -list | grep 'CAC Module')"
if [ "$cac_loaded" != "" ]
  then
  echo 'CAC Module already loaded.  Exiting...'
  exit
fi

nssdb_exists="$(ls -lAh /home/$USERNAME | grep '.pki')"
if [ "$nssdb_exists" != "" ]
  then
  echo 'nssdb already initialized.  Skipping creation...'
  else
  killall chrome
  mkdir -p /home/$USERNAME/.pki/nssdb && modutil -force -create -dbdir sql:/home/$USERNAME/.pki/nssdb/
fi

killall chrome
modutil -dbdir sql:/home/$USERNAME/.pki/nssdb/ -force -add "CAC Module" -libfile /usr/lib64/libcackey.so

