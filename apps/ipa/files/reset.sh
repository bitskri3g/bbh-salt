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

  echo $reset_user_password | kinit reset
  if ! ipa user-mod $uid --random > status; then
    echo "Password reset failed when attempted using the below information.  Do you have an account?" > status
    echo "-------------------------------------" >> status
    echo "Attempted to reset password for user $uid" >> status
    echo "-------------------------------------" >> status
    echo "  uid: $uid" >> status
    echo "  mail: $mail" >> status
    echo "  first: ${first^}" >> status
    echo "  last: ${last^}" >> status
    echo "  gecos: $uid" >> status
  else
    echo "-------------------------------------" >> status
    echo "-------------------------------------" >> status
    echo "Your password has been reset to the above random password." >> status
    echo "1. Please go to https://ipa.cybbh.space to finish the process." >> status
    echo "2. You will initiate the reset procedure by using [[ random password ]] + [[ current_otp_value ]] to log in initially.  Users that never configured an OTP token can disregard [[ current_otp_value ]]" >> status
    echo "3. On the password reset screen, you will type [[ random password ]] as your old password and a **NEW OTP token** in the OTP field; using the token you initially used to start the process will fail.  Users that never configured an OTP token can ignore the OTP field.  You will enter your new desired password in the last two fields." >> status
    echo "New passwords must be greater than or equal to 20 characters in length.  There are no additional complexity requirements." >> status
  fi
else
  echo "-------------------------------------" > status
  echo "User verification failed.  Did you sign your reset request?" >> status
  echo "-------------------------------------" >> status
fi

message="From: no-reply@ipa.cybbh.space
To: $mail
Cc: $admin_email
Subject: Password Reset
$(cat status)"

echo "$message" > response
cat response | msmtp -t --auto-from=on --host=45.79.210.89 --port=25
