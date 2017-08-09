#!/bin/bash

public_test=$(openstack network list \
--os-username {{ os_username }} \
--os-password {{ os_password }} \
--os-project-name {{ os_project_name }} \
--os-user-domain-name {{ os_user_domain_name }} \
--os-project-domain-name {{ os_project_domain_name }} \
--os-auth-url {{ os_auth_url }} \
--os-identity-api-version {{ os_identity_api_version }} \
| grep public)

if [[ $public_test != '' ]]; then
  echo 'Existing public network detected...exiting...'
  exit
fi

openstack network create --external --share --provider-physical-network provider --provider-network-type flat public \
--os-username {{ os_username }} \
--os-password {{ os_password }} \
--os-project-name {{ os_project_name }} \
--os-user-domain-name {{ os_user_domain_name }} \
--os-project-domain-name {{ os_project_domain_name }} \
--os-auth-url {{ os_auth_url }} \
--os-identity-api-version {{ os_identity_api_version }}


openstack subnet create --network public --allocation-pool start=10.50.20.0,end=10.50.255.100 --dns-nameserver 10.50.255.254 --gateway 10.50.255.254 --subnet-range 10.50.0.0/16 public_subnet \
--os-username {{ os_username }} \
--os-password {{ os_password }} \
--os-project-name {{ os_project_name }} \
--os-user-domain-name {{ os_user_domain_name }} \
--os-project-domain-name {{ os_project_domain_name }} \
--os-auth-url {{ os_auth_url }} \
--os-identity-api-version {{ os_identity_api_version }}
