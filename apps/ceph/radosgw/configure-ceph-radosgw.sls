{% set host = opts.id.split('.') %}

include: 
  - /apps/ceph/radosgw/install-ceph-radosgw
  - /apps/ceph/conf-file
  - /apps/ceph/admin-keyring
  - /apps/ceph/radosgw-keyring

make_swift_service:
  cmd.script:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ceph/files/mkservice_rgw.sh
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ceph/files/hash
    - template: jinja
    - defaults:
        os_password: {{ pillar['openstack_admin_pass'] }}
        os_username: {{ pillar['admin_openrc']['OS_USERNAME'] }}
        os_project_name: {{ pillar['admin_openrc']['OS_PROJECT_NAME'] }}
        os_user_domain_name: {{ pillar['admin_openrc']['OS_USER_DOMAIN_NAME'] }}
        os_project_domain_name: {{ pillar['admin_openrc']['OS_PROJECT_DOMAIN_NAME'] }}
        os_identity_api_version: {{ pillar['admin_openrc']['OS_IDENTITY_API_VERSION'] }}
        os_auth_url: {{ pillar['keystone_configuration']['internal_endpoint']['protocol'] }}{{ pillar['keystone_configuration']['internal_endpoint']['url'] }}{{ pillar['keystone_configuration']['internal_endpoint']['port'] }}{{ pillar['keystone_configuration']['internal_endpoint']['path'] }}
        swift_service_password: {{ pillar['swift_service_password'] }}
        rgw_public_endpoint: {{ pillar['rgw_configuration']['public_endpoint']['protocol'] }}{{ pillar['rgw_configuration']['public_endpoint']['url'] }}{{ pillar['rgw_configuration']['public_endpoint']['port'] }}{{ pillar['rgw_configuration']['public_endpoint']['path'] }}
        rgw_internal_endpoint: {{ pillar['rgw_configuration']['internal_endpoint']['protocol'] }}{{ pillar['rgw_configuration']['internal_endpoint']['url'] }}{{ pillar['rgw_configuration']['internal_endpoint']['port'] }}{{ pillar['rgw_configuration']['internal_endpoint']['path'] }}
        rgw_admin_endpoint: {{ pillar['rgw_configuration']['admin_endpoint']['protocol'] }}{{ pillar['rgw_configuration']['admin_endpoint']['url'] }}{{ pillar['rgw_configuration']['admin_endpoint']['port'] }}{{ pillar['rgw_configuration']['admin_endpoint']['path'] }}
    - requires:
      - /apps/ceph/radosgw-keyring

ceph auth import -i /etc/ceph/ceph.client.radosgw.keyring:
  cmd.run:
    - unless: ceph auth get client.radosgw.{{ host[0] }}
    - requires:
      - sls: /apps/ceph/radosgw-keyring

ceph auth caps client.radosgw.{{ host[0] }} osd 'allow rwx' mon 'allow rwx':
  cmd.run:
    - requires:
      - cmd: ceph auth import -i /etc/ceph/ceph.client.radosgw.keyring

ceph osd pool set default.rgw.buckets.data pg_num 1024:
  cmd.run:
    - unless: 'ceph osd pool get default.rgw.buckets.data pg_num | grep -e "^pg_num: 1024$"'

ceph osd pool set default.rgw.buckets.data pgp_num 1024:
  cmd.run:
    - unless: 'ceph osd pool get default.rgw.buckets.data pgp_num | grep -e "^pgp_num: 1024$"'

radosgw_service:
  service.running:
    - name: radosgw
    - enable: true
    - watch:
      - sls: /apps/ceph/conf-file
