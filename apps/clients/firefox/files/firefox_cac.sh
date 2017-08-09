#!/bin/bash

firefox-esr --version

nssdb_exists="$(ls -lAh /home/$USERNAME/.mozilla/firefox/ | grep '.default')"
if [ "$nssdb_exists" != "" ]
  then
  echo 'firefox nssdb already initialized.  Skipping creation...'
  else
  Xvfb :1337& firefox-esr --display=:1337& sleep 3 && killall firefox-esr && killall Xvfb
fi

export ffdir="$(grep Path /home/$USERNAME/.mozilla/firefox/profiles.ini | cut -d'=' -f 2)"

for file in /usr/local/share/ca-certificates/*.crt
do
  certutil -d /home/$USERNAME/.mozilla/firefox/$ffdir/ -A -t "CT,C,C" -n "$file" -i "$file"
done

cac_loaded="$(export ffdir="$(grep Path /home/$USERNAME/.mozilla/firefox/profiles.ini | cut -d'=' -f 2)" && modutil -list -dbdir /home/$USERNAME/.mozilla/firefox/$ffdir | grep CAC)"
if [ "$cac_loaded" != "" ]
  then
  echo 'CAC Module already loaded.  Exiting...'
  exit
  else
  echo "No CAC Module detected..."
fi

modutil -add CAC -force -dbdir /home/$USERNAME/.mozilla/firefox/$ffdir/ -libfile /usr/lib64/libcackey.so
