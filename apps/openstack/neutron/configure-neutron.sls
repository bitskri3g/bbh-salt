{% set base_octet = grains['ipv4'][0].split('.') %}

include:
  - /apps/openstack/neutron/install-neutron

make_neutron_service:
  cmd.script:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/mkservice.sh
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/hash
    - template: jinja
    - defaults:
        os_password: {{ pillar['openstack_admin_pass'] }}
        os_username: {{ pillar['admin_openrc']['OS_USERNAME'] }}
        os_project_name: {{ pillar['admin_openrc']['OS_PROJECT_NAME'] }}
        os_user_domain_name: {{ pillar['admin_openrc']['OS_USER_DOMAIN_NAME'] }}
        os_project_domain_name: {{ pillar['admin_openrc']['OS_PROJECT_DOMAIN_NAME'] }}
        os_identity_api_version: {{ pillar['admin_openrc']['OS_IDENTITY_API_VERSION'] }}
        os_auth_url: {{ pillar['keystone_configuration']['internal_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['internal_endpoint']['url'] }}{{ pillar['keystone_configuration']['internal_endpoint']['port'] }}{{ pillar['keystone_configuration']['internal_endpoint']['path'] }}
        neutron_service_password: {{ pillar['neutron_service_password'] }}
        neutron_public_endpoint: {{ pillar['neutron_configuration']['public_endpoint']['protocol'] }}{{ pillar['neutron_configuration']['public_endpoint']['url'] }}{{ pillar['neutron_configuration']['public_endpoint']['port'] }}{{ pillar['neutron_configuration']['public_endpoint']['path'] }}
        neutron_internal_endpoint: {{ pillar['neutron_configuration']['internal_endpoint']['protocol'] }}{{ pillar['neutron_configuration']['internal_endpoint']['url'] }}{{ pillar['neutron_configuration']['internal_endpoint']['port'] }}{{ pillar['neutron_configuration']['internal_endpoint']['path'] }}
        neutron_admin_endpoint: {{ pillar['neutron_configuration']['admin_endpoint']['protocol'] }}{{ pillar['neutron_configuration']['admin_endpoint']['url'] }}{{ pillar['neutron_configuration']['admin_endpoint']['port'] }}{{ pillar['neutron_configuration']['admin_endpoint']['path'] }}
    - requires:
      - /apps/openstack/neutron/install-neutron
        
/etc/neutron/neutron.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/neutron.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/hash
    - template: jinja
    - defaults:
        sql_connection_string: 'connection = mysql+pymysql://neutron:{{ pillar['neutron_password'] }}@{{ pillar ['mysql_configuration']['address'] }}/neutron'
        transport_url: transport_url = rabbit://openstack:{{ pillar['rmq_openstack_password'] }}@10.10.6.230
        auth_strategy: auth_strategy = keystone
        auth_uri: auth_uri = {{ pillar['keystone_configuration']['public_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['public_endpoint']['url'] }}{{ pillar['keystone_configuration']['public_endpoint']['port'] }}{{ pillar['keystone_configuration']['public_endpoint']['path'] }}
        auth_url: auth_url = {{ pillar['keystone_configuration']['internal_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['internal_endpoint']['url'] }}{{ pillar['keystone_configuration']['internal_endpoint']['port'] }}{{ pillar['keystone_configuration']['internal_endpoint']['path'] }}
        memcached_servers: memcached_servers = {{ pillar['memcached_servers']['address'] }}:11211
        auth_type: auth_type = password
        project_domain_name: project_domain_name = {{ pillar['neutron_openrc']['OS_PROJECT_DOMAIN_NAME'] }}
        user_domain_name: user_domain_name = {{ pillar['neutron_openrc']['OS_USER_DOMAIN_NAME'] }}
        project_name: project_name = {{ pillar['neutron_openrc']['OS_PROJECT_NAME'] }}
        username: username = {{ pillar['neutron_openrc']['OS_USERNAME'] }}
        password: password = {{ pillar['neutron_service_password'] }}
        my_ip: my_ip = {{ grains['ipv4'][0] }}
        nova_username: username = {{ pillar['nova_openrc']['OS_USERNAME'] }}
        nova_password: password = {{ pillar['nova_service_password'] }}
    - requires:
      - /apps/openstack/neutron/install-neutron

/etc/neutron/api-paste.ini:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/api-paste.ini
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/hash
    - template: jinja
    - defaults:
    - requires:
      - /apps/openstack/neutron/install-neutron

/etc/neutron/plugins/ml2/ml2_conf.ini:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/ml2_conf.ini
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/hash

/etc/neutron/plugins/ml2/linuxbridge_agent.ini:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/linuxbridge_agent.ini
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/hash
    - template: jinja
    - defaults:
        local_ip: local_ip = 10.60.{{ base_octet[2] }}.{{ base_octet[3] }}

/etc/neutron/l3_agent.ini:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/l3_agent.ini
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/hash

/etc/neutron/dhcp_agent.ini:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/dhcp_agent.ini
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/hash

/etc/neutron/metadata_agent.ini:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/metadata_agent.ini
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/hash
    - template: jinja
    - defaults:
        nova_metadata_ip: nova_metadata_ip = {{ pillar['nova_configuration']['internal_endpoint']['url'] }}
        metadata_proxy_shared_secret: metadata_proxy_shared_secret = {{ pillar['metadata_secret'] }}

/bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron:
  cmd.run

echo 1024 > /proc/sys/fs/inotify/max_user_instances:
  cmd.run

neutron_server_service:
  service.running:
    - name: neutron-server       
    - watch:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/plugins/ml2/ml2_conf.ini
      - file: /etc/neutron/plugins/ml2/linuxbridge_agent.ini
      - file: /etc/neutron/l3_agent.ini
      - file: /etc/neutron/dhcp_agent.ini
      - file: /etc/neutron/metadata_agent.ini
      - file: /etc/neutron/api-paste.ini

neutron_linuxbridge_agent_service:
  service.running:
    - name: neutron-linuxbridge-agent
    - watch:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/plugins/ml2/ml2_conf.ini
      - file: /etc/neutron/plugins/ml2/linuxbridge_agent.ini
      - file: /etc/neutron/l3_agent.ini
      - file: /etc/neutron/dhcp_agent.ini
      - file: /etc/neutron/metadata_agent.ini
      - file: /etc/neutron/api-paste.ini
      
neutron_dhcp_agent_service:
  service.running:
    - name: neutron-dhcp-agent
    - watch:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/plugins/ml2/ml2_conf.ini
      - file: /etc/neutron/plugins/ml2/linuxbridge_agent.ini
      - file: /etc/neutron/l3_agent.ini
      - file: /etc/neutron/dhcp_agent.ini
      - file: /etc/neutron/metadata_agent.ini
      - file: /etc/neutron/api-paste.ini
      
neutron_metadata_agent_service:
  service.running:
    - name: neutron-metadata-agent
    - watch:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/plugins/ml2/ml2_conf.ini
      - file: /etc/neutron/plugins/ml2/linuxbridge_agent.ini
      - file: /etc/neutron/l3_agent.ini
      - file: /etc/neutron/dhcp_agent.ini
      - file: /etc/neutron/metadata_agent.ini
      - file: /etc/neutron/api-paste.ini
      
neutron_l3_agent_service:
  service.running:
    - name: neutron-l3-agent
    - watch:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/plugins/ml2/ml2_conf.ini
      - file: /etc/neutron/plugins/ml2/linuxbridge_agent.ini
      - file: /etc/neutron/l3_agent.ini
      - file: /etc/neutron/dhcp_agent.ini
      - file: /etc/neutron/metadata_agent.ini
      - file: /etc/neutron/api-paste.ini
      
mk_public_network:
  cmd.script:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/mkpublic.sh
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/hash
    - template: jinja
    - defaults:
        os_password: {{ pillar['openstack_admin_pass'] }}
        os_username: {{ pillar['admin_openrc']['OS_USERNAME'] }}
        os_project_name: {{ pillar['admin_openrc']['OS_PROJECT_NAME'] }}
        os_user_domain_name: {{ pillar['admin_openrc']['OS_USER_DOMAIN_NAME'] }}
        os_project_domain_name: {{ pillar['admin_openrc']['OS_PROJECT_DOMAIN_NAME'] }}
        os_identity_api_version: {{ pillar['admin_openrc']['OS_IDENTITY_API_VERSION'] }}
        os_auth_url: {{ pillar['keystone_configuration']['internal_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['internal_endpoint']['url'] }}{{ pillar['keystone_configuration']['internal_endpoint']['port'] }}{{ pillar['keystone_configuration']['internal_endpoint']['path'] }}
