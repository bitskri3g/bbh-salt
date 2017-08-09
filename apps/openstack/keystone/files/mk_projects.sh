#!/bin/bash
## This script will enumerate the directory and identify all users that are part of the vta_user_filter group.
## It will then iterate through that list one-by-one and test if a user project for that user exists.  If a 
## project does exist, it will do nothing.  If a project does not exist, it will create it.  This script
## should be periodically run as part of a highstate as well as when new users are added to the system.

# Get current project list in IPA domain and save to /tmp/ipa_projects
openstack project list --domain ipa \
--os-username {{ os_username }} \
--os-password {{ os_password }} \
--os-project-name {{ os_project_name }} \
--os-user-domain-name {{ os_user_domain_name }} \
--os-project-domain-name {{ os_project_domain_name }} \
--os-auth-url {{ os_auth_url }} \
--os-identity-api-version {{ os_identity_api_version }} > /tmp/ipa_projects

# Recurse through directory and get UID list of all users who are part of
# the vta_user_filter group
ldapsearch -H ldaps://ipa.cybbh.space                                      \
-x -b "cn=users,cn=accounts,dc=ipa,dc=cybbh,dc=space"                      \
-D "{{ bind_user }}"                                                       \
-w {{ bind_password }}                                                     \
memberOf=cn=vta_user_filter,cn=groups,cn=accounts,dc=ipa,dc=cybbh,dc=space \
uid                                                                        \
-LLL |                                                                     \
grep -v dn | grep uid | awk '{ print $2 }' | while read uid; do            \

# While iterating through user list, test for existing project based
# on data in /tmp/ipa_projects; if exist, exit.  If not, create.
# Additionally, the user will be assigned the role of 'user' in the
# new project
  project_test=$(grep $uid /tmp/ipa_projects)
  if [[ $project_test != '' ]]; then
    echo -n 'Existing '
    echo -n $uid
    echo ' project detected...skipping creation...'
    echo $project_test
  else
    openstack project create $uid --domain ipa \
    --os-username {{ os_username }} \
    --os-password {{ os_password }} \
    --os-project-name {{ os_project_name }} \
    --os-user-domain-name {{ os_user_domain_name }} \
    --os-project-domain-name {{ os_project_domain_name }} \
    --os-auth-url {{ os_auth_url }} \
    --os-identity-api-version {{ os_identity_api_version }}

    openstack role add --user $uid --user-domain ipa --project $uid --project-domain ipa user \
    --os-username {{ os_username }} \
    --os-password {{ os_password }} \
    --os-project-name {{ os_project_name }} \
    --os-user-domain-name {{ os_user_domain_name }} \
    --os-project-domain-name {{ os_project_domain_name }} \
    --os-auth-url {{ os_auth_url }} \
    --os-identity-api-version {{ os_identity_api_version }}
    fi; done

# Cleanup
rm /tmp/ipa_projects
