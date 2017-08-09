include:
  - /apps/clients/packages

/etc/samba/smb.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/samba/files/smb.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/samba/files/hash
    - require:
      - sls: /apps/clients/packages

nmbd:
  service.running:
    - watch:
      - /etc/samba/smb.conf

smbd:
  service.running:
    - watch:
      - /etc/samba/smb.conf

