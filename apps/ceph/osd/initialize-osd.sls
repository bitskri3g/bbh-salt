include: 
  - /apps/ceph/install-ceph
  - /apps/ceph/conf-file
  - /apps/ceph/admin-keyring

ceph osd crush add-bucket {{ grains['host'] }} host:
  cmd.run

ceph osd crush move {{ grains['host'] }} root=default:
  cmd.run

initialize_journal:
  cmd.script:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ceph/files/init-journal.sh
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ceph/files/hash

{% for disk, journal in pillar.get('storage-node-v1-mapping', {}).items() %}

{{ disk }}_prep_script:
  cmd.script:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ceph/files/osd-bootstrap.sh
    - template: jinja
    - defaults:
        cluster: {{ pillar['configuration']['cluster'] }}
        disk: {{ disk }}
        hostname: {{ grains['host'] }}
        journal: {{ pillar['storage-node-v1-mapping'][disk]['journal'] }}
    - requires:
      - initialize_journal
    - onlyif: 
      - is_present=$(if grep -rnq {{ disk }} /proc/mounts;then echo 1;else echo 0;fi) && test $is_present -eq 0


{{ pillar['storage-node-v1-mapping'][disk]['journal'] }}_permissions:
  file.managed:
    - name: {{ pillar['storage-node-v1-mapping'][disk]['journal'] }}
    - user: ceph
    - group: ceph

{% endfor %}

ceph-osd.target:
  service.running:
    - watch:
      - sls: /apps/ceph/conf-file

