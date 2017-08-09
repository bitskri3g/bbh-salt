#!/bin/bash

user_test=$(rabbitmqctl list_users | grep openstack)

if [[ $user_test != '' ]]; then
  echo 'Existing openstack user located ...exiting...'
  echo $user_test
  exit
fi

rabbitmqctl add_user openstack {{ password }}
