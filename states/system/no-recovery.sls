/etc/default/grub:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/states/system/files/grub
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/states/system/files/hash

update-grub:
  cmd.run:
    - onchanges:
      - file: /etc/default/grub
