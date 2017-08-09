#!/bin/bash

service_test=$(openstack service list \
--os-username {{ os_username }} \
--os-password {{ os_password }} \
--os-project-name {{ os_project_name }} \
--os-user-domain-name {{ os_user_domain_name }} \
--os-project-domain-name {{ os_project_domain_name }} \
--os-auth-url {{ os_auth_url }} \
--os-identity-api-version {{ os_identity_api_version }} \
| grep placement)

if [[ $service_test != '' ]]; then
  echo 'Existing placement service detected...exiting...'
  exit
fi

openstack user create --domain default --password {{ placement_service_password }} placement \
--os-username {{ os_username }} \
--os-password {{ os_password }} \
--os-project-name {{ os_project_name }} \
--os-user-domain-name {{ os_user_domain_name }} \
--os-project-domain-name {{ os_project_domain_name }} \
--os-auth-url {{ os_auth_url }} \
--os-identity-api-version {{ os_identity_api_version }}

openstack role add --project service --user placement admin \
--os-username {{ os_username }} \
--os-password {{ os_password }} \
--os-project-name {{ os_project_name }} \
--os-user-domain-name {{ os_user_domain_name }} \
--os-project-domain-name {{ os_project_domain_name }} \
--os-auth-url {{ os_auth_url }} \
--os-identity-api-version {{ os_identity_api_version }}

openstack service create --name placement --description "Placement API" placement \
--os-username {{ os_username }} \
--os-password {{ os_password }} \
--os-project-name {{ os_project_name }} \
--os-user-domain-name {{ os_user_domain_name }} \
--os-project-domain-name {{ os_project_domain_name }} \
--os-auth-url {{ os_auth_url }} \
--os-identity-api-version {{ os_identity_api_version }}

openstack endpoint create --region RegionOne placement public {{ placement_public_endpoint }}   \
--os-username {{ os_username }} \
--os-password {{ os_password }} \
--os-project-name {{ os_project_name }} \
--os-user-domain-name {{ os_user_domain_name }} \
--os-project-domain-name {{ os_project_domain_name }} \
--os-auth-url {{ os_auth_url }} \
--os-identity-api-version {{ os_identity_api_version }}

openstack endpoint create --region RegionOne placement internal {{ placement_internal_endpoint }}   \
--os-username {{ os_username }} \
--os-password {{ os_password }} \
--os-project-name {{ os_project_name }} \
--os-user-domain-name {{ os_user_domain_name }} \
--os-project-domain-name {{ os_project_domain_name }} \
--os-auth-url {{ os_auth_url }} \
--os-identity-api-version {{ os_identity_api_version }}

openstack endpoint create --region RegionOne placement admin {{ placement_admin_endpoint }}   \
--os-username {{ os_username }} \
--os-password {{ os_password }} \
--os-project-name {{ os_project_name }} \
--os-user-domain-name {{ os_user_domain_name }} \
--os-project-domain-name {{ os_project_domain_name }} \
--os-auth-url {{ os_auth_url }} \
--os-identity-api-version {{ os_identity_api_version }}
