include:
  - /apps/ceph/conf-file
  
/etc/ceph/ceph.client.volumes.keyring:
  file.managed:
    - contents_pillar: ceph-client-volumes-keyring
    - mode: 640
    - user: root
    - group: cinder
