/etc/ceph/ceph.client.nova.keyring:
  file.managed:
    - contents_pillar: ceph-client-nova-keyring
    - mode: 640
    - user: nova
    - group: nova
