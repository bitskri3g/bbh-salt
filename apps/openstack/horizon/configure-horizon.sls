include:
  - /apps/openstack/horizon/install-horizon

/etc/openstack-dashboard/local_settings.py:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/horizon/files/local_settings.py
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/horizon/files/hash
    - template: jinja
    - defaults:
        memcached_servers: {{ pillar['memcached_servers']['address'] }}
        keystone_url: {{ pillar['keystone_configuration']['internal_endpoint']['url'] }}

/var/www/html/index.html:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/horizon/files/index.html
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/openstack/horizon/files/hash

apache2_service:
  service.running:
    - name: apache2
    - watch:
      - file: /etc/openstack-dashboard/local_settings.py

