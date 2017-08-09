#!/bin/bash

cd /root

while read line
do
   echo "$line" >> email
done

mail=$(grep -oP "Return-Path:.* <\K(.*)>" email | sed s/">"/""/g - | head -1)

if bash verify.sh email; then

  uid=$(grep "From " email | awk '{ print $2 }' | rev | cut -d'.' -f3- | rev | head -1)
  first=$(grep "From " email | awk '{ print $2 }' | cut -d'.' -f 1 | head -1)
  last=$(grep "From " email | awk '{ print $2 }' | rev | cut -d'.' -f 3 | rev | sed 's/[0-9]*//g' | head -1)

  echo $stage_user_password | kinit stage
  if ! ipa stageuser-add $uid --first=${first^} --last=${last^} --email=$mail --gecos=$uid --class=3 --random > status; then
    echo "Account staging failed when attempted using the below information.  Do you already have an account?" > status
    echo "-------------------------------------" >> status
    echo "Attempted to stage user $uid" >> status
    echo "-------------------------------------" >> status
    echo "  uid: $uid" >> status
    echo "  mail: $mail" >> status
    echo "  first: ${first^}" >> status
    echo "  last: ${last^}" >> status
    echo "  gecos: $uid" >> status
  else
    echo "-------------------------------------" >> status
    echo "-------------------------------------" >> status
    echo "Your account has been created, but is not yet active.  You will recieve notification once this occurs." >> status
  fi
else
  echo "-------------------------------------" > status
  echo "User verification failed.  Did you sign your registration request?" >> status
  echo "-------------------------------------" >> status
fi

message="From: no-reply@ipa.cybbh.space
To: $mail
Cc: $admin_email
Subject: Registration
$(cat status)"

echo "$message" > response
cat response | msmtp -t --auto-from=on --host=45.79.210.89 --port=25
