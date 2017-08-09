{% set base_octet = grains['ipv4'][0].split('.') %}

include:
  - /apps/openstack/neutron/install-neutron-compute

/etc/neutron/neutron.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/neutron-compute.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/hash
    - template: jinja
    - defaults:
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

/etc/neutron/plugins/ml2/linuxbridge_agent.ini:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/linuxbridge_agent_compute.ini
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/neutron/files/hash
    - template: jinja
    - defaults:
        local_ip: local_ip = 10.60.{{ base_octet[2] }}.{{ base_octet[3] }}

neutron_linuxbridge_agent_service:
  service.running:
    - name: neutron-linuxbridge-agent
    - watch:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/plugins/ml2/linuxbridge_agent.ini
