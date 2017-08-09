include:
  - /apps/openstack/nova/install-nova

make_nova_service:
  cmd.script:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/nova/files/mkservice.sh
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/nova/files/hash
    - template: jinja
    - defaults:
        os_password: {{ pillar['openstack_admin_pass'] }}
        os_username: {{ pillar['admin_openrc']['OS_USERNAME'] }}
        os_project_name: {{ pillar['admin_openrc']['OS_PROJECT_NAME'] }}
        os_user_domain_name: {{ pillar['admin_openrc']['OS_USER_DOMAIN_NAME'] }}
        os_project_domain_name: {{ pillar['admin_openrc']['OS_PROJECT_DOMAIN_NAME'] }}
        os_identity_api_version: {{ pillar['admin_openrc']['OS_IDENTITY_API_VERSION'] }}
        os_auth_url: {{ pillar['keystone_configuration']['internal_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['internal_endpoint']['url'] }}{{ pillar['keystone_configuration']['internal_endpoint']['port'] }}{{ pillar['keystone_configuration']['internal_endpoint']['path'] }}
        nova_service_password: {{ pillar['nova_service_password'] }}
        nova_public_endpoint: {{ pillar['nova_configuration']['public_endpoint']['protocol'] }}{{ pillar['nova_configuration']['public_endpoint']['url'] }}{{ pillar['nova_configuration']['public_endpoint']['port'] }}{{ pillar['nova_configuration']['public_endpoint']['path'] }}
        nova_internal_endpoint: {{ pillar['nova_configuration']['internal_endpoint']['protocol'] }}{{ pillar['nova_configuration']['internal_endpoint']['url'] }}{{ pillar['nova_configuration']['internal_endpoint']['port'] }}{{ pillar['nova_configuration']['internal_endpoint']['path'] }}
        nova_admin_endpoint: {{ pillar['nova_configuration']['admin_endpoint']['protocol'] }}{{ pillar['nova_configuration']['admin_endpoint']['url'] }}{{ pillar['nova_configuration']['admin_endpoint']['port'] }}{{ pillar['nova_configuration']['admin_endpoint']['path'] }}
    - requires:
      - /apps/openstack/nova/install-nova

make_placement_service:
  cmd.script:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/nova/files/mkservice_placement.sh
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/nova/files/hash
    - template: jinja
    - defaults:
        os_password: {{ pillar['openstack_admin_pass'] }}
        os_username: {{ pillar['admin_openrc']['OS_USERNAME'] }}
        os_project_name: {{ pillar['admin_openrc']['OS_PROJECT_NAME'] }}
        os_user_domain_name: {{ pillar['admin_openrc']['OS_USER_DOMAIN_NAME'] }}
        os_project_domain_name: {{ pillar['admin_openrc']['OS_PROJECT_DOMAIN_NAME'] }}
        os_identity_api_version: {{ pillar['admin_openrc']['OS_IDENTITY_API_VERSION'] }}
        os_auth_url: {{ pillar['keystone_configuration']['internal_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['internal_endpoint']['url'] }}{{ pillar['keystone_configuration']['internal_endpoint']['port'] }}{{ pillar['keystone_configuration']['internal_endpoint']['path'] }}
        placement_service_password: {{ pillar['placement_service_password'] }}
        placement_public_endpoint: {{ pillar['placement_configuration']['public_endpoint']['protocol'] }}{{ pillar['placement_configuration']['public_endpoint']['url'] }}{{ pillar['placement_configuration']['public_endpoint']['port'] }}{{ pillar['placement_configuration']['public_endpoint']['path'] }}
        placement_internal_endpoint: {{ pillar['placement_configuration']['internal_endpoint']['protocol'] }}{{ pillar['placement_configuration']['internal_endpoint']['url'] }}{{ pillar['placement_configuration']['internal_endpoint']['port'] }}{{ pillar['placement_configuration']['internal_endpoint']['path'] }}
        placement_admin_endpoint: {{ pillar['placement_configuration']['admin_endpoint']['protocol'] }}{{ pillar['placement_configuration']['admin_endpoint']['url'] }}{{ pillar['placement_configuration']['admin_endpoint']['port'] }}{{ pillar['placement_configuration']['admin_endpoint']['path'] }}
    - requires:
      - /apps/openstack/nova/install-nova

/usr/share/spice-html5/spice_auto.html:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/nova/files/spice_auto.html
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/nova/files/hash
        
/usr/share/spice-html5/spice.css:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/nova/files/spice.css
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/nova/files/hash

/etc/nova/nova.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/nova/files/nova.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/nova/files/hash
    - template: jinja
    - defaults:
        api_sql_connection_string: 'connection = mysql+pymysql://nova:{{ pillar['nova_password'] }}@{{ pillar ['mysql_configuration']['address'] }}/nova_api'
        sql_connection_string: 'connection = mysql+pymysql://nova:{{ pillar['nova_password'] }}@{{ pillar ['mysql_configuration']['address'] }}/nova'
        transport_url: transport_url = rabbit://openstack:{{ pillar['rmq_openstack_password'] }}@10.10.6.230
        auth_strategy: auth_strategy = keystone
        auth_uri: auth_uri = {{ pillar['keystone_configuration']['public_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['public_endpoint']['url'] }}{{ pillar['keystone_configuration']['public_endpoint']['port'] }}{{ pillar['keystone_configuration']['public_endpoint']['path'] }}
        auth_url: auth_url = {{ pillar['keystone_configuration']['internal_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['internal_endpoint']['url'] }}{{ pillar['keystone_configuration']['internal_endpoint']['port'] }}{{ pillar['keystone_configuration']['internal_endpoint']['path'] }}
        memcached_servers: memcached_servers = {{ pillar['memcached_servers']['address'] }}:11211
        memcache_servers: memcache_servers = {{ pillar['memcached_servers']['address'] }}:11211
        auth_type: auth_type = password
        project_domain_name: project_domain_name = {{ pillar['nova_openrc']['OS_PROJECT_DOMAIN_NAME'] }}
        user_domain_name: user_domain_name = {{ pillar['nova_openrc']['OS_USER_DOMAIN_NAME'] }}
        project_name: project_name = {{ pillar['nova_openrc']['OS_PROJECT_NAME'] }}
        username: username = {{ pillar['nova_openrc']['OS_USERNAME'] }}
        password: password = {{ pillar['nova_service_password'] }}
        my_ip: my_ip = {{ grains['ipv4'][0] }}
        api_servers: api_servers = {{ pillar['glance_configuration']['internal_endpoint']['protocol'] }}{{ pillar['glance_configuration']['internal_endpoint']['url'] }}{{ pillar['glance_configuration']['internal_endpoint']['port'] }}{{ pillar['glance_configuration']['internal_endpoint']['path'] }}
        neutron_url: url = {{ pillar['neutron_configuration']['internal_endpoint']['protocol'] }}{{ pillar['neutron_configuration']['internal_endpoint']['url'] }}{{ pillar['neutron_configuration']['internal_endpoint']['port'] }}{{ pillar['neutron_configuration']['internal_endpoint']['path'] }}
        metadata_proxy_shared_secret: metadata_proxy_shared_secret = {{ pillar['metadata_secret'] }}
        neutron_username: username = {{ pillar['neutron_openrc']['OS_USERNAME'] }} 
        neutron_password: password = {{ pillar['neutron_service_password'] }}
        placement_username: username = {{ pillar['placement_openrc']['OS_USERNAME'] }} 
        placement_password: password = {{ pillar['placement_service_password'] }}
  
/bin/sh -c "nova-manage api_db sync" nova:
  cmd.run

/bin/sh -c "nova-manage cell_v2 map_cell0" nova:
  cmd.run

/bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova:
  cmd.run:
    - unless: nova-manage cell_v2 list_cells | grep cell1

/bin/sh -c "nova-manage db sync" nova:
  cmd.run

/bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova:
  cmd.run

nova_api_service:
  service.running:
    - name: nova-api
    - watch:
      - file: /etc/nova/nova.conf

nova_consoleauth_service:
  service.running:
    - name: nova-consoleauth       
    - watch:
      - file: /etc/nova/nova.conf

nova_scheduler_service:
  service.running:
    - name: nova-scheduler       
    - watch:
      - file: /etc/nova/nova.conf

nova_conductor_service:
  service.running:
    - name: nova-conductor
    - watch:
      - file: /etc/nova/nova.conf

nova_placement_api_service:
  service.running:
    - name: apache2
    - watch:
      - file: /etc/nova/nova.conf

nova-spiceproxy_service:
  service.running:
    - name: nova-spiceproxy
    - enable: True
    - requires:
      - nova-spiceproxy
    - watch:
      - file: /etc/nova/nova.conf
