/etc/apt/apt.conf.d/02proxy:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/apt/02proxy
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/apt/hash
