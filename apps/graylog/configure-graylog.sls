include:
  - /apps/graylog/install-graylog

/etc/elasticsearch/elasticsearch.yml:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/graylog/files/elasticsearch.yml
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/graylog/files/hash
    - template: jinja
    - defaults:
        graylog_cluster: {{ pillar['graylog_configuration']['cluster_name'] }}

/etc/graylog/server/server.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/graylog/files/server.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/graylog/files/hash
    - template: jinja
    - defaults:
        password_secret: {{ pillar['password_secret'] }}
        root_password_sha2: {{ pillar['root_password_sha2'] }}
        web_listen_uri: http://{{ grains['ipv4'][0] }}:9000/
        rest_listen_uri: http://{{ grains['ipv4'][0] }}:9000/api/

rest_conf.sh:
  cmd.script:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/graylog/files/rest_conf.sh
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/graylog/files/hash
    - template: jinja
    - defaults:
        root_password: {{ pillar['root_password'] }}
        system_username: {{ pillar['common_ldap_configuration']['bind_user'] }}
        system_password: {{ pillar['bind_password'] }}
        ldap_uri: 'ldaps://{{ pillar['common_ldap_configuration']['address'] }}'
        search_base: '{{ pillar['common_ldap_configuration']['user_dn'] }}'
        search_pattern: '{{ pillar['graylog_ldap_configuration']['search_pattern'] }}'

elasticsearch_service:
  service.running:
    - name: elasticsearch
    - enable: True
    - watch:
      - /etc/elasticsearch/elasticsearch.yml

graylog_service:
  service.running:
    - name: graylog-server
    - enable: True
    - watch:
      - /etc/graylog/server/server.conf
