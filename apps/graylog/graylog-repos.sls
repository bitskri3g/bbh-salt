elasticsearch_repo:
  pkgrepo.managed:
    - humanname: Elastic Search
    - name: deb https://packages.elastic.co/elasticsearch/2.x/debian stable main
    - file: /etc/apt/sources.list.d/elasticsearch-2.x.list
    - key_url: https://packages.elastic.co/GPG-KEY-elasticsearch

graylog_repo:
  pkgrepo.managed:
    - humanname: Graylog
    - name: deb https://packages.graylog2.org/repo/debian/ stable 2.2
    - file: /etc/apt/sources.list.d/graylog.list
    - key_url: https://packages.graylog2.org/repo/debian/keyring.gpg
