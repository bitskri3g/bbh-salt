include:
  - /apps/clients/packages

/etc/sssd/sssd.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/sssd/files/sssd.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/sssd/files/hash
    - mode: 600
    - template: jinja
    - defaults:
        ldap_default_authtok: 'ldap_default_authtok = {{ pillar['bind_password'] }}'

/usr/share/pam-configs/sss:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/sssd/files/sss
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/sssd/files/hash

pam-auth-update --package --force:
  cmd.run:
    - onchanges: 
      - file: /usr/share/pam-configs/sss

/usr/local/share/ca-certificates/ipa.cybbh.space/ldap_ca.crt:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/ipa_ca.crt
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/hash
    - makedirs: True
    - mode: 644 

update-ca-certificates-ldap:
  cmd.run:
    - name: update-ca-certificates
    - onchanges:
      - file: /usr/local/share/ca-certificates/ipa.cybbh.space/ldap_ca.crt

sssd_service:
  service.running:
    - name: sssd
    - watch:
      - /etc/sssd/sssd.conf
      - /usr/local/share/ca-certificates/ipa.cybbh.space/ldap_ca.crt
