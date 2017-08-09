/etc/ceph/client.nova.key:
  file.managed:
    - contents_pillar: client-nova-key
    - mode: 640
    - user: nova
    - group: nova
