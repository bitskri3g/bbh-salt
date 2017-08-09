include:
  - /states/disk/controller
  - /states/system/refresh-pillar

/kvmfs/images:
  file.directory:
    - makedirs: True

{% for os, args in pillar.get('images', {}).items() %}
/kvmfs/images/{{ args['name'] }}:
  file.managed:
    - source: {{ args['url'] }}
    - source_hash: {{ args['hash'] }}
    - require:
      - /kvmfs/images
      - sls: /states/disk/controller
      - sls: /states/system/refresh-pillar

/kvmfs/images/{{ os }}-latest:
  file.symlink:
    - target: /kvmfs/images/{{ args['name'] }}
    - force: True
{% endfor %}
