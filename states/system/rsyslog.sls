{% if 'notebook' not in grains['id'] and 'workstation' not in grains['id'] %}

/etc/rsyslog.d/10-graylog.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/rsyslog/files/10-graylog.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/rsyslog/files/hash
    - template: jinja
    - defaults:
        centralized_logger: {{ pillar['graylog_configuration']['cluster_address'] }}

rsyslog:
  service.running:
    - watch:
      - /etc/rsyslog.d/10-graylog.conf

{% else %}

/etc/logrotate.conf:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/states/system/files/logrotate.conf
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/states/system/files/hash

/etc/logrotate.d/rsyslog:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/states/system/files/rsyslog
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/states/system/files/hash

rsyslog:
  service.running:
    - watch:
      - /etc/logrotate.conf
      - /etc/logrotate.d/rsyslog

cron_hourly_symlink:
  file.symlink:
    - name: /etc/cron.hourly/logrotate
    - target: /etc/cron.daily/logrotate
    - makedirs: True

{% endif %}
