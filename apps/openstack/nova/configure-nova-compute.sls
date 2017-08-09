include:
  - /apps/openstack/nova/install-nova-compute
  - /apps/ceph/virsh-secrets
  - /apps/ceph/nova-keyring

spice-html5:
  pkg.installed

/etc/nova/nova.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/nova/files/nova-compute.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/nova/files/hash
    - template: jinja
    - defaults:
        transport_url: transport_url = rabbit://openstack:{{ pillar['rmq_openstack_password'] }}@10.10.6.230
        auth_strategy: auth_strategy = keystone
        auth_uri: auth_uri = {{ pillar['keystone_configuration']['public_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['public_endpoint']['url'] }}{{ pillar['keystone_configuration']['public_endpoint']['port'] }}{{ pillar['keystone_configuration']['public_endpoint']['path'] }}
        auth_url: auth_url = {{ pillar['keystone_configuration']['internal_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['internal_endpoint']['url'] }}{{ pillar['keystone_configuration']['internal_endpoint']['port'] }}{{ pillar['keystone_configuration']['internal_endpoint']['path'] }}
        memcached_servers: memcached_servers = {{ pillar['memcached_servers']['address'] }}:11211
        auth_type: auth_type = password
        project_domain_name: project_domain_name = {{ pillar['nova_openrc']['OS_PROJECT_DOMAIN_NAME'] }}
        user_domain_name: user_domain_name = {{ pillar['nova_openrc']['OS_USER_DOMAIN_NAME'] }}
        project_name: project_name = {{ pillar['nova_openrc']['OS_PROJECT_NAME'] }}
        username: username = {{ pillar['nova_openrc']['OS_USERNAME'] }}
        password: password = {{ pillar['nova_service_password'] }}
        my_ip: my_ip = {{ grains['ipv4'][0] }}
        api_servers: api_servers = {{ pillar['glance_configuration']['internal_endpoint']['protocol'] }}{{ pillar['glance_configuration']['internal_endpoint']['url'] }}{{ pillar['glance_configuration']['internal_endpoint']['port'] }}{{ pillar['glance_configuration']['internal_endpoint']['path'] }}
        neutron_url: url = {{ pillar['neutron_configuration']['internal_endpoint']['protocol'] }}{{ pillar['neutron_configuration']['internal_endpoint']['url'] }}{{ pillar['neutron_configuration']['internal_endpoint']['port'] }}{{ pillar['neutron_configuration']['internal_endpoint']['path'] }}
        neutron_username: username = {{ pillar['neutron_openrc']['OS_USERNAME'] }} 
        neutron_password: password = {{ pillar['neutron_service_password'] }}
        placement_username: username = {{ pillar['placement_openrc']['OS_USERNAME'] }}
        placement_password: password = {{ pillar['placement_service_password'] }}

nova_compute_service:
  service.running:
    - name: nova-compute
    - watch:
      - file: /etc/nova/nova.conf
