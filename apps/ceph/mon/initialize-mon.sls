include: 
  - /apps/ceph/install-ceph
  - /apps/ceph/conf-file
  - /apps/ceph/admin-keyring

/tmp/ceph.mon.keyring:
  file.managed:
    - contents_pillar: ceph-mon-keyring
    - mode: 600
    - user: root
    - group: root

monmaptool --create --generate --clobber -c /etc/ceph/ceph.conf /tmp/monmap:
  cmd.run:
    - prereq: 
      - ceph-mon --cluster ceph --mkfs -i {{ grains['host'] }} --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring
  
mkdir -p /var/lib/ceph/mon/{{ pillar['configuration']['cluster'] }}-{{ grains['host'] }}:
  cmd.run:
    - onlyif: 'test ! -e /var/lib/ceph/mon/{{ grains['host'] }}-{{ grains['ipv4'][0] }}'
    - requires: monmaptool --generate --clobber /tmp/monmap
  
ceph-mon --cluster {{ pillar['configuration']['cluster'] }} --mkfs -i {{ grains['host'] }} --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring:
  cmd.run:
    - requires:
      - /var/lib/ceph/mon/ceph-{{ grains['host'] }}

/var/lib/ceph/mon/{{ pillar['configuration']['cluster'] }}-{{ grains['host'] }}:
  file.directory:
    - user: ceph
    - group: ceph
    - recurse:
      - user
      - group
    - requires: ceph-mon --cluster {{ pillar['configuration']['cluster'] }} --mkfs -i {{ grains['host'] }} --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring

/var/lib/ceph/mon/{{ pillar['configuration']['cluster'] }}-{{ grains['host'] }}/done:
  file.managed:
    - requires:
      - /var/lib/ceph/mon/{{ pillar['configuration']['cluster'] }}-{{ grains['host'] }}

ceph-mon@{{ grains['host'] }}:
  service.running:
    - watch:
      - sls: /apps/ceph/conf-file
