/etc/ceph/ceph.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ceph/files/ceph.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ceph/files/hash
    - template: jinja
    - makedirs: True
    - defaults:
        fsid: {{ pillar['configuration']['fsid'] }}
        mon_members: |
          {% for host in pillar['configuration']['mon_members'] -%}
          [mon.{{ host }}]
          host = {{ host }}
          mon addr = {{ pillar['configuration']['mon_members'][host][0] }}
          {% endfor %}
        rgw_members: |
          {% for host in pillar['configuration']['rgw_members'] -%}
          [client.radosgw.{{ host }}]
          host = {{ host }}
          keyring = /etc/ceph/ceph.client.radosgw.keyring
          rgw keystone url = {{ pillar['keystone_configuration']['internal_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['internal_endpoint']['url'] }}{{ pillar['keystone_configuration']['internal_endpoint']['port'] }}
          rgw keystone api version = 3
          rgw keystone admin user = keystone
          rgw keystone admin password = {{ pillar['keystone_service_password'] }}
          rgw keystone admin project = service
          rgw keystone admin domain = default
          rgw keystone accepted roles = admin,user
          rgw keystone token cache size = 10
          rgw keystone revocation interval = 300
          rgw keystone implicit tenants = true
          rgw swift account in url = true
          {% endfor %}
