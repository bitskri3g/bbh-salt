/etc/ceph/ceph.client.admin.keyring:
  file.managed:
    - contents_pillar: ceph-client-admin-keyring
    - mode: 600
    - user: root
    - group: root
