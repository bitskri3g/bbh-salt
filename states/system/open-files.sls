/etc/security/limits.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/states/system/files/limits.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/states/system/files/hash
