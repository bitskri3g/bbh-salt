/etc/ssh/sshd_config:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/ssh/files/sshd_config
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/ssh/files/hash

ssh_service:
  service.running:
    - name: ssh
    - enable: True
    - watch:
      - file: /etc/ssh/sshd_config
