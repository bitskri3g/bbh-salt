include:
  - /apps/ipsec/install-atlas

/etc/ipsec.secrets:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipsec/files/atlas-ipsec.secrets
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipsec/files/hash
    - template: jinja
    - defaults:
        atlas_ipsec_secret: {{ pillar['atlas_ipsec_secret'] }}
    - sls: /apps/ipsec/install-atlas

/etc/ipsec.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipsec/files/atlas-ipsec.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipsec/files/hash

strongswan:
  service.running:
    - watch:
      - /etc/ipsec.conf
      - /etc/ipsec.secrets
