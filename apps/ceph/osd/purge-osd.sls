include: 
  - /apps/ceph/install-ceph

osd_purge_script:
  cmd.script:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ceph/files/purge-osd.sh
    - template: jinja
    - defaults:
        hostname: {{ grains['host'] }}
