/etc/keystone/keystone.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/keystone/files/keystone.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/keystone/files/hash
    - template: jinja
    - defaults:
        token_provider: provider = fernet
        sql_connection_string: 'connection = mysql+pymysql://keystone:{{ pillar['keystone_password'] }}@{{ pillar ['mysql_configuration']['address'] }}/keystone'

/etc/keystone/domains/keystone.ipa.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/keystone/files/keystone-ldap.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/keystone/files/hash
    - makedirs: True
    - template: jinja
    - defaults:
        ldap_url: 'url = ldap://{{ pillar ['common_ldap_configuration']['address'] }}'
        ldap_user: 'user = {{ pillar ['common_ldap_configuration']['bind_user'] }}'
        ldap_password: 'password = {{ pillar ['bind_password'] }}'
        ldap_suffix: 'suffix = {{ pillar ['common_ldap_configuration']['base_dn'] }}'
        user_tree_dn: 'user_tree_dn = {{ pillar ['common_ldap_configuration']['user_dn'] }}'
        group_tree_dn: 'group_tree_dn = {{ pillar ['common_ldap_configuration']['group_dn'] }}'
        user_filter: 'user_filter = {{ pillar ['keystone_ldap_configuration']['user_filter'] }}'
        group_filter: 'group_filter = {{ pillar ['keystone_ldap_configuration']['group_filter'] }}'
        token_provider: provider = fernet
        sql_connection_string: 'connection = mysql+pymysql://keystone:{{ pillar['keystone_password'] }}@{{ pillar ['mysql_configuration']['address'] }}/keystone'

/etc/keystone/ldap_ca.crt:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/ipa_ca.crt
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/hash

/usr/local/share/ca-certificates/ldap_ca.crt:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/ipa_ca.crt
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/hash

update-ca-certificates:
  cmd.run:
    - onchanges:
      - file: /usr/local/share/ca-certificates/ldap_ca.crt

initialize_keystone:
  cmd.script:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/keystone/files/initialize.sh
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/keystone/files/hash
    - template: jinja
    - defaults:
        os_password: {{ pillar['openstack_admin_pass'] }}
        os_username: {{ pillar['admin_openrc']['OS_USERNAME'] }}
        os_project_name: {{ pillar['admin_openrc']['OS_PROJECT_NAME'] }}
        os_user_domain_name: {{ pillar['admin_openrc']['OS_USER_DOMAIN_NAME'] }}
        os_project_domain_name: {{ pillar['admin_openrc']['OS_PROJECT_DOMAIN_NAME'] }}
        os_identity_api_version: {{ pillar['admin_openrc']['OS_IDENTITY_API_VERSION'] }}
        os_auth_url: {{ pillar['keystone_configuration']['internal_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['internal_endpoint']['url'] }}{{ pillar['keystone_configuration']['internal_endpoint']['port'] }}{{ pillar['keystone_configuration']['internal_endpoint']['path'] }}
        admin_password: {{ pillar['openstack_admin_pass'] }}
        internal_endpoint: {{ pillar ['keystone_configuration']['internal_endpoint']['protocol'] }}{{ pillar ['keystone_configuration']['internal_endpoint']['url'] }}{{ pillar ['keystone_configuration']['internal_endpoint']['port'] }}{{ pillar ['keystone_configuration']['internal_endpoint']['path'] }}
        admin_endpoint: {{ pillar ['keystone_configuration']['admin_endpoint']['protocol'] }}{{ pillar ['keystone_configuration']['admin_endpoint']['url'] }}{{ pillar ['keystone_configuration']['admin_endpoint']['port'] }}{{ pillar ['keystone_configuration']['admin_endpoint']['path'] }}
        public_endpoint: {{ pillar ['keystone_configuration']['public_endpoint']['protocol'] }}{{ pillar ['keystone_configuration']['public_endpoint']['url'] }}{{ pillar ['keystone_configuration']['public_endpoint']['port'] }}{{ pillar ['keystone_configuration']['public_endpoint']['path'] }}
        keystone_service_password: {{ pillar ['keystone_service_password'] }}

/etc/apache2/apache2.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/keystone/files/apache2.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/keystone/files/hash
    - template: jinja
    - defaults:
        servername: ServerName {{ pillar ['keystone_configuration']['internal_endpoint']['url'] }}

apache2:
  service.running:
    - enable: True
    - watch:
      - file: /etc/apache2/apache2.conf
      - file: /etc/keystone/keystone.conf
      - file: /etc/keystone/domains/keystone.ipa.conf

/var/lib/keystone/keystone.db:
  file.absent

/etc/keystone/keystone-paste.ini:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/keystone/files/keystone-paste.ini
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/keystone/files/hash

make_projects:
  cmd.script:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/keystone/files/mk_projects.sh
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/keystone/files/hash
    - template: jinja
    - defaults:
        bind_user: {{ pillar['common_ldap_configuration']['bind_user'] }}
        bind_password: {{ pillar['bind_password'] }}
        os_password: {{ pillar['openstack_admin_pass'] }}
        os_username: {{ pillar['admin_openrc']['OS_USERNAME'] }}
        os_project_name: {{ pillar['admin_openrc']['OS_PROJECT_NAME'] }}
        os_user_domain_name: {{ pillar['admin_openrc']['OS_USER_DOMAIN_NAME'] }}
        os_project_domain_name: {{ pillar['admin_openrc']['OS_PROJECT_DOMAIN_NAME'] }}
        os_identity_api_version: {{ pillar['admin_openrc']['OS_IDENTITY_API_VERSION'] }}
        os_auth_url: {{ pillar['keystone_configuration']['internal_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['internal_endpoint']['url'] }}{{ pillar['keystone_configuration']['internal_endpoint']['port'] }}{{ pillar['keystone_configuration']['internal_endpoint']['path'] }}
