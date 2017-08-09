#!/bin/bash

service_test=$(openstack service list \
--os-username {{ os_username }} \
--os-password {{ os_password }} \
--os-project-name {{ os_project_name }} \
--os-user-domain-name {{ os_user_domain_name }} \
--os-project-domain-name {{ os_project_domain_name }} \
--os-auth-url {{ os_auth_url }} \
--os-identity-api-version {{ os_identity_api_version }} \
| grep neutron)

if [[ $service_test != '' ]]; then
  echo 'Existing neutron service detected...exiting...'
  exit
fi

openstack user create --domain default --password {{ neutron_service_password }} neutron \
--os-username {{ os_username }} \
--os-password {{ os_password }} \
--os-project-name {{ os_project_name }} \
--os-user-domain-name {{ os_user_domain_name }} \
--os-project-domain-name {{ os_project_domain_name }} \
--os-auth-url {{ os_auth_url }} \
--os-identity-api-version {{ os_identity_api_version }} \

openstack role add --project service --user neutron admin \
--os-username {{ os_username }} \
--os-password {{ os_password }} \
--os-project-name {{ os_project_name }} \
--os-user-domain-name {{ os_user_domain_name }} \
--os-project-domain-name {{ os_project_domain_name }} \
--os-auth-url {{ os_auth_url }} \
--os-identity-api-version {{ os_identity_api_version }} \

openstack service create --name neutron --description "OpenStack Networking" network \
--os-username {{ os_username }} \
--os-password {{ os_password }} \
--os-project-name {{ os_project_name }} \
--os-user-domain-name {{ os_user_domain_name }} \
--os-project-domain-name {{ os_project_domain_name }} \
--os-auth-url {{ os_auth_url }} \
--os-identity-api-version {{ os_identity_api_version }} \

openstack endpoint create --region RegionOne network public {{ neutron_public_endpoint }}   \
--os-username {{ os_username }} \
--os-password {{ os_password }} \
--os-project-name {{ os_project_name }} \
--os-user-domain-name {{ os_user_domain_name }} \
--os-project-domain-name {{ os_project_domain_name }} \
--os-auth-url {{ os_auth_url }} \
--os-identity-api-version {{ os_identity_api_version }} \

openstack endpoint create --region RegionOne network internal {{ neutron_internal_endpoint }}   \
--os-username {{ os_username }} \
--os-password {{ os_password }} \
--os-project-name {{ os_project_name }} \
--os-user-domain-name {{ os_user_domain_name }} \
--os-project-domain-name {{ os_project_domain_name }} \
--os-auth-url {{ os_auth_url }} \
--os-identity-api-version {{ os_identity_api_version }} \

openstack endpoint create --region RegionOne network admin {{ neutron_admin_endpoint }}   \
--os-username {{ os_username }} \
--os-password {{ os_password }} \
--os-project-name {{ os_project_name }} \
--os-user-domain-name {{ os_user_domain_name }} \
--os-project-domain-name {{ os_project_domain_name }} \
--os-auth-url {{ os_auth_url }} \
--os-identity-api-version {{ os_identity_api_version }} \
