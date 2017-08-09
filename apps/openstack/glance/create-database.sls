{% set service = 'glance' %}
create_{{ service }}_db:
  mysql_database.present:
    - name: {{ service }}
    - connection_unix_socket: /var/run/mysqld/mysqld.sock

{% for host in pillar[service + '_configuration']['hosts'] %}

create_{{ service }}_user_{{ host }}:
  mysql_user.present:
    - name: {{ service }}
    - password: {{ pillar [service + '_password'] }}
    - host: {{ pillar [service + '_configuration']['hosts'][loop.index0] }}
    - connection_unix_socket: /var/run/mysqld/mysqld.sock

grant_{{ service }}_privs_{{ host }}:
   mysql_grants.present:
    - grant: all privileges
    - database: {{ service }}.*
    - user: {{ service }}
    - host: {{ pillar [service + '_configuration']['hosts'][loop.index0] }}
    - connection_unix_socket: /var/run/mysqld/mysqld.sock

{% endfor %}
