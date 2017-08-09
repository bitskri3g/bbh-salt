include:
  - /apps/openstack/cinder/install-cinder
  - /apps/openstack/cinder/configure-cinder-ceph

make_cinder_service:
  cmd.script:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/cinder/files/mkservice.sh
    - template: jinja
    - defaults:
        os_password: {{ pillar['openstack_admin_pass'] }}
        os_username: {{ pillar['admin_openrc']['OS_USERNAME'] }}
        os_project_name: {{ pillar['admin_openrc']['OS_PROJECT_NAME'] }}
        os_user_domain_name: {{ pillar['admin_openrc']['OS_USER_DOMAIN_NAME'] }}
        os_project_domain_name: {{ pillar['admin_openrc']['OS_PROJECT_DOMAIN_NAME'] }}
        os_identity_api_version: {{ pillar['admin_openrc']['OS_IDENTITY_API_VERSION'] }}
        os_auth_url: {{ pillar['keystone_configuration']['internal_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['internal_endpoint']['url'] }}{{ pillar['keystone_configuration']['internal_endpoint']['port'] }}{{ pillar['keystone_configuration']['internal_endpoint']['path'] }}
        cinder_service_password: {{ pillar['cinder_service_password'] }}
        cinder_public_endpoint_v2: {{ pillar['cinder_configuration']['public_endpoint']['protocol'] }}{{ pillar['cinder_configuration']['public_endpoint']['url'] }}{{ pillar['cinder_configuration']['public_endpoint']['port'] }}{{ pillar['cinder_configuration']['public_endpoint']['v2_path'] }}
        cinder_internal_endpoint_v2: {{ pillar['cinder_configuration']['internal_endpoint']['protocol'] }}{{ pillar['cinder_configuration']['internal_endpoint']['url'] }}{{ pillar['cinder_configuration']['internal_endpoint']['port'] }}{{ pillar['cinder_configuration']['internal_endpoint']['v2_path'] }}
        cinder_admin_endpoint_v2: {{ pillar['cinder_configuration']['admin_endpoint']['protocol'] }}{{ pillar['cinder_configuration']['admin_endpoint']['url'] }}{{ pillar['cinder_configuration']['admin_endpoint']['port'] }}{{ pillar['cinder_configuration']['admin_endpoint']['v2_path'] }}
        cinder_public_endpoint_v3: {{ pillar['cinder_configuration']['public_endpoint']['protocol'] }}{{ pillar['cinder_configuration']['public_endpoint']['url'] }}{{ pillar['cinder_configuration']['public_endpoint']['port'] }}{{ pillar['cinder_configuration']['public_endpoint']['v3_path'] }}
        cinder_internal_endpoint_v3: {{ pillar['cinder_configuration']['internal_endpoint']['protocol'] }}{{ pillar['cinder_configuration']['internal_endpoint']['url'] }}{{ pillar['cinder_configuration']['internal_endpoint']['port'] }}{{ pillar['cinder_configuration']['internal_endpoint']['v3_path'] }}
        cinder_admin_endpoint_v3: {{ pillar['cinder_configuration']['admin_endpoint']['protocol'] }}{{ pillar['cinder_configuration']['admin_endpoint']['url'] }}{{ pillar['cinder_configuration']['admin_endpoint']['port'] }}{{ pillar['cinder_configuration']['admin_endpoint']['v3_path'] }}
    - requires:
      - /apps/openstack/cinder/install-cinder
        
/etc/cinder/cinder.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/cinder/files/cinder.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/cinder/files/hash
    - template: jinja
    - defaults:
        sql_connection_string: 'connection = mysql+pymysql://cinder:{{ pillar['cinder_password'] }}@{{ pillar ['mysql_configuration']['address'] }}/cinder'
        transport_url: transport_url = rabbit://openstack:{{ pillar['rmq_openstack_password'] }}@10.10.6.230
        my_ip: my_ip = {{ grains['ipv4'][0] }}
        auth_uri: auth_uri = {{ pillar['keystone_configuration']['public_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['public_endpoint']['url'] }}{{ pillar['keystone_configuration']['public_endpoint']['port'] }}{{ pillar['keystone_configuration']['public_endpoint']['path'] }}
        auth_url: auth_url = {{ pillar['keystone_configuration']['internal_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['internal_endpoint']['url'] }}{{ pillar['keystone_configuration']['internal_endpoint']['port'] }}{{ pillar['keystone_configuration']['internal_endpoint']['path'] }}
        memcached_servers: memcached_servers = {{ pillar['memcached_servers']['address'] }}:11211
        auth_type: auth_type = password
        project_domain_name: project_domain_name = {{ pillar['cinder_openrc']['OS_PROJECT_DOMAIN_NAME'] }}
        user_domain_name: user_domain_name = {{ pillar['cinder_openrc']['OS_USER_DOMAIN_NAME'] }}
        project_name: project_name = {{ pillar['cinder_openrc']['OS_PROJECT_NAME'] }}
        username: username = {{ pillar['cinder_openrc']['OS_USERNAME'] }}
        password: password = {{ pillar['cinder_service_password'] }}
        glance_api_servers: glance_api_servers = {{ pillar['glance_configuration']['internal_endpoint']['protocol'] }}{{ pillar['glance_configuration']['internal_endpoint']['url'] }}{{ pillar['glance_configuration']['internal_endpoint']['port'] }}{{ pillar['glance_configuration']['internal_endpoint']['path'] }}

/bin/sh -c "cinder-manage db sync" cinder:
  cmd.run

cinder_api_service:
  service.running:
    - name: apache2
    - watch:
      - file: /etc/cinder/cinder.conf

cinder_scheduler_service:
  service.running:
    - name: cinder-scheduler
    - watch:
      - file: /etc/cinder/cinder.conf

cinder_volume_service:
  service.running:
    - name: cinder-volume
    - watch:
      - file: /etc/cinder/cinder.conf
