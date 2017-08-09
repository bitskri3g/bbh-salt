include:
  - /apps/openstack/glance/install-glance
  - /apps/openstack/glance/configure-glance-ceph
  
make_glance_service:
  cmd.script:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/glance/files/mkservice.sh
    - template: jinja
    - defaults:
        os_password: {{ pillar['openstack_admin_pass'] }}
        os_username: {{ pillar['admin_openrc']['OS_USERNAME'] }}
        os_project_name: {{ pillar['admin_openrc']['OS_PROJECT_NAME'] }}
        os_user_domain_name: {{ pillar['admin_openrc']['OS_USER_DOMAIN_NAME'] }}
        os_project_domain_name: {{ pillar['admin_openrc']['OS_PROJECT_DOMAIN_NAME'] }}
        os_identity_api_version: {{ pillar['admin_openrc']['OS_IDENTITY_API_VERSION'] }}
        os_auth_url: {{ pillar['keystone_configuration']['internal_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['internal_endpoint']['url'] }}{{ pillar['keystone_configuration']['internal_endpoint']['port'] }}{{ pillar['keystone_configuration']['internal_endpoint']['path'] }}
        glance_service_password: {{ pillar['glance_service_password'] }}
        glance_public_endpoint: {{ pillar['glance_configuration']['public_endpoint']['protocol'] }}{{ pillar['glance_configuration']['public_endpoint']['url'] }}{{ pillar['glance_configuration']['public_endpoint']['port'] }}{{ pillar['glance_configuration']['public_endpoint']['path'] }}
        glance_internal_endpoint: {{ pillar['glance_configuration']['internal_endpoint']['protocol'] }}{{ pillar['glance_configuration']['internal_endpoint']['url'] }}{{ pillar['glance_configuration']['internal_endpoint']['port'] }}{{ pillar['glance_configuration']['internal_endpoint']['path'] }}
        glance_admin_endpoint: {{ pillar['glance_configuration']['admin_endpoint']['protocol'] }}{{ pillar['glance_configuration']['admin_endpoint']['url'] }}{{ pillar['glance_configuration']['admin_endpoint']['port'] }}{{ pillar['glance_configuration']['admin_endpoint']['path'] }}
    - requires:
      - /apps/openstack/glance/install-glance
        
/etc/glance/glance-api.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/glance/files/glance-api.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/glance/files/hash
    - template: jinja
    - defaults:
        sql_connection_string: 'connection = mysql+pymysql://glance:{{ pillar['glance_password'] }}@{{ pillar ['mysql_configuration']['address'] }}/glance'
        auth_uri: auth_uri = {{ pillar['keystone_configuration']['public_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['public_endpoint']['url'] }}{{ pillar['keystone_configuration']['public_endpoint']['port'] }}{{ pillar['keystone_configuration']['public_endpoint']['path'] }}
        auth_url: auth_url = {{ pillar['keystone_configuration']['internal_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['internal_endpoint']['url'] }}{{ pillar['keystone_configuration']['internal_endpoint']['port'] }}{{ pillar['keystone_configuration']['internal_endpoint']['path'] }}
        memcached_servers: memcached_servers = {{ pillar['memcached_servers']['address'] }}:11211
        auth_type: auth_type = password
        project_domain_name: project_domain_name = {{ pillar['glance_openrc']['OS_PROJECT_DOMAIN_NAME'] }}
        user_domain_name: user_domain_name = {{ pillar['glance_openrc']['OS_USER_DOMAIN_NAME'] }}
        project_name: project_name = {{ pillar['glance_openrc']['OS_PROJECT_NAME'] }}
        username: username = {{ pillar['glance_openrc']['OS_USERNAME'] }}
        password: password = {{ pillar['glance_service_password'] }}
        flavor: flavor = keystone
        stores: stores = file,http
        default_store: default_store = file
        filesystem_store_datadir: filesystem_store_datadir = /var/lib/glance/images/ 

/etc/glance/glance-registry.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/glance/files/glance-registry.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/glance/files/hash
    - template: jinja
    - defaults:
        sql_connection_string: 'connection = mysql+pymysql://glance:{{ pillar['glance_password'] }}@{{ pillar ['mysql_configuration']['address'] }}/glance'
        auth_uri: auth_uri = {{ pillar['keystone_configuration']['public_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['public_endpoint']['url'] }}{{ pillar['keystone_configuration']['public_endpoint']['port'] }}{{ pillar['keystone_configuration']['public_endpoint']['path'] }}
        auth_url: auth_url = {{ pillar['keystone_configuration']['internal_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['internal_endpoint']['url'] }}{{ pillar['keystone_configuration']['internal_endpoint']['port'] }}{{ pillar['keystone_configuration']['internal_endpoint']['path'] }}
        memcached_servers: memcached_servers = {{ pillar['memcached_servers']['address'] }}:11211
        auth_type: auth_type = password
        project_domain_name: project_domain_name = {{ pillar['glance_openrc']['OS_PROJECT_DOMAIN_NAME'] }}
        user_domain_name: user_domain_name = {{ pillar['glance_openrc']['OS_USER_DOMAIN_NAME'] }}
        project_name: project_name = {{ pillar['glance_openrc']['OS_PROJECT_NAME'] }}
        username: username = {{ pillar['glance_openrc']['OS_USERNAME'] }}
        password: password = {{ pillar['glance_service_password'] }}
        flavor: flavor = keystone
        stores: stores = file,http
        default_store: default_store = file
        filesystem_store_datadir: filesystem_store_datadir = /var/lib/glance/images/ 

/bin/sh -c "glance-manage db_sync" glance:
  cmd.run

glance_registry_service:
  service.running:
    - name: glance-registry
    - watch:
      - file: /etc/glance/glance-registry.conf

glance_api_service:
  service.running:
    - name: glance-api
    - watch:
      - file: /etc/glance/glance-api.conf
