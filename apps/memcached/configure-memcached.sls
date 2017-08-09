/etc/memcached.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/memcached/files/memcached.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/memcached/files/hash
    - template: jinja
    - defaults:
        listen_addr: {{ grains['ipv4'][0] }}

memcached_servic_check:
  service.running:
    - name: memcached
    - enable: True
    - watch:
      - file: /etc/memcached.conf
