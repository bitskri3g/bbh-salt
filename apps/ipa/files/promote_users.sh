#!/bin/bash

### This script promotes staged users to active status.  It will by default grant everyone access to the vta.
### Services besides the VTA must still be granted manually for now.

### Current Classes
###
### CMF - Default user.  Has access to VTA and gitlab.
### Student - Has access to VTA and gitlab.
### Administration - Has access to gitlab and booked.
### Instructor - Has access to VTA, gitlab, and booked.

echo {{ promote_user_password }} | kinit promote > /dev/null

ipa stageuser-find | grep "User login" | awk '{ print $3 }' | while read uid
do
email=$(ipa stageuser-find $uid | grep "Email address" | awk '{ print $3 }')
first=$(ipa stageuser-find $uid | grep "First name" | awk '{ print $3 }')
class=$(ipa stageuser-find $uid --all | grep "Class" | awk '{ print $2 }')
if ! ipa stageuser-mod $uid --user-auth-type=otp --user-auth-type=password > /dev/null; then
  echo "Account modification failed when attempted for $uid.  Please contact your administrator." > status
elif ! ipa stageuser-activate $uid > /dev/null; then
  echo "Account activation failed when attempted for $uid.  Do you already have an account?" > status
else
  echo "$first," > status
  echo "" >> status
  echo "Your account has been promoted and assigned a class of $class." >> status
  echo "" >> status
  echo "CMF - Default user.  Has access to VTA and gitlab." >> status
  echo "Student - Has access to VTA and gitlab." >> status
  echo "Administration - Has access to gitlab and booked." >> status
  echo "Instructor - Has access to VTA, gitlab, and booked." >> status
  echo "" >> status
  echo "1. Go to https://ipa.cybbh.space.  If you are prompted with a popup login dialog, cancel it out.  This tends to happen when using IE and Chrome.  It is not the real login dialog." >> status
  echo "2. Log in with $uid and [[ random password ]].  You received [[ random password ]] in an email when you first registered." >> status
  echo "3. Reset password.  Valid passwords are >= 20 characters.  There are no entropy requirements besides length." >> status
  echo "4. Create a TOTP token once you're logged in to the web ui.  FreeOTP works well, as does google authenticator.  If you wish to use a hardware token, the protectimus slim mini works well and should in theory be allowed in a SCIF (it functions via NFC).  Clear with your SSO/G2 first." >> status
  echo "5. Log in to your services using your new credentials.  Your login name will be $uid, and your password will be [[ your new password ]] OR [[ your new password + 6-digit TOTP appended to the end ]].  TOTP is not currently required, but is highly recommended.  It will be mandated in the future." >> status
  echo "6. If you have been granted access to the VTA, your login domain is ipa, not default." >> status
  echo "" >> status
  echo "r" >> status
  echo "" >> status
  echo "The Promotion Bot" >> status
fi

message="From: no-reply@ipa.cybbh.space
To: $email
Cc: {{ admin_email }}
Subject: Account Promotion
$(cat status)"

echo "$message" | /usr/sbin/sendmail -t
done
