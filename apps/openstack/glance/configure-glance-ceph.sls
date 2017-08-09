include:
  - /apps/ceph/conf-file
  
/etc/ceph/ceph.client.images.keyring:
  file.managed:
    - contents_pillar: ceph-client-images-keyring
    - mode: 640
    - user: root
    - group: glance

ceph_user_exists:
  user.present:
    - name: ceph
    - home: /etc/ceph

/etc/sudoers.d/ceph:
  file.managed:
    - contents:
      - ceph ALL = (root) NOPASSWD:ALL
      - Defaults:ceph !requiretty
    - file_mode: 644
    
  
