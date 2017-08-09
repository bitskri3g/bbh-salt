include:
  - /apps/ipa/install-promotion

/etc/ipa/ipa_ca.crt:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/ipa_ca.crt
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/hash
    - makedirs: True

/etc/ipa/DSTRootCAX3.crt:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/DSTRootCAX3.crt
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/hash
    - makedirs: True

/etc/ipa/letsencryptx3.crt:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/letsencryptx3.crt
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/hash
    - makedirs: True

certutil -A -n IPA.CYBBH.SPACE -t "CT,C,C" -i /etc/ipa/ipa_ca.crt -d /etc/ipa/nssdb:
  cmd.run:
    - onchanges:
      - file: /etc/ipa/ipa_ca.crt

certutil -A -n DSTRootCAX3 -t "C,," -i /etc/ipa/DSTRootCAX3.crt -d /etc/ipa/nssdb:
  cmd.run:
    - onchanges:
      - file: /etc/ipa/DSTRootCAX3.crt

certutil -A -n letsencryptx3 -t "C,," -i /etc/ipa/letsencryptx3.crt -d /etc/ipa/nssdb:
  cmd.run:
    - onchanges:
      - file: /etc/ipa/letsencryptx3.crt

/etc/ipa/default.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/default.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/hash

/etc/krb5.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/krb5.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/hash

/var/lib/sss/pubconf/krb5.include.d/:
  file.directory:
    - makedirs: True

/etc/postfix/main.cf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/main.cf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/hash

/etc/postfix/access:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/access
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/hash

/etc/aliases:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/aliases
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/hash

postmap /etc/postfix/access:
  cmd.run:
    - onchanges:
      - file: /etc/postfix/access

newaliases:
  cmd.run:
    - onchanges:
      - file: /etc/aliases

postfix_service:
  service.running:
    - name: postfix
    - enable: true
    - watch:
      - /etc/aliases
      - /etc/postfix/access
      - /etc/postfix/main.cf
