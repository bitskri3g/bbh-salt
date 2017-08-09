include:
  - /apps/ipa/install-registration

/etc/sudoers.d/nobody-docker:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/nobody-docker
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/hash

/root/register/Dockerfile:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/Dockerfile-register
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/hash
    - makedirs: True
    - template: jinja
    - defaults:
        stage_user_password: {{ pillar['stage_user_password'] }}
        admin_email: {{ pillar['admin_email'] }}

/root/reset/Dockerfile:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/Dockerfile-reset
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/hash
    - makedirs: True
    - template: jinja
    - defaults:
        reset_user_password: {{ pillar['reset_user_password'] }}
        admin_email: {{ pillar['admin_email'] }}


docker build -t bbh/register:latest /root/register:
  cmd.run

docker build -t bbh/reset:latest /root/reset:
  cmd.run


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
