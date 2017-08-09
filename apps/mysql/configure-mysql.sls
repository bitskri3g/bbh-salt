include:
  - /apps/mysql/install-mysql
  - /apps/mysql/create_databases

/etc/mysql/mariadb.conf.d/99-openstack.cnf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/mysql/files/99-openstack.cnf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/mysql/files/hash
    - makedirs: True
    - template: jinja
    - defaults:
        ip_address: {{ grains['ipv4'][0] }}

root:
  mysql_user.present:
    - host: localhost
    - password: {{ pillar ['mysql_root_password'] }}
    - connection_unix_socket: /var/run/mysqld/mysqld.sock

mysql:
  service.running:
    - enable: True
    - watch:
      - file: /etc/mysql/mariadb.conf.d/99-openstack.cnf
