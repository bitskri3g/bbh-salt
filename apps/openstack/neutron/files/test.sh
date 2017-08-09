#!/bin/bash

public_test=$(openstack network list | grep public)

if [[ $public_test != '' ]]; then
  echo 'Existing public network detected...exiting...'
  exit
fi
  echo 'Creating public network...'
