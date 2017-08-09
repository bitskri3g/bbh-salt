include:
  - /apps/ipsec/install-ipa

/etc/strongswan/ipsec.secrets:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipsec/files/ipa-ipsec.secrets
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipsec/files/hash
    - template: jinja
    - defaults:
        ipa_ipsec_secret: {{ pillar['ipa_ipsec_secret'] }}
    - require:
      - sls: /apps/ipsec/install-ipa

/etc/strongswan/ipsec.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipsec/files/ipa-ipsec.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipsec/files/hash

strongswan:
  service.running:
    - enable: true
    - watch:
      - /etc/strongswan/ipsec.conf
      - /etc/strongswan/ipsec.secrets
