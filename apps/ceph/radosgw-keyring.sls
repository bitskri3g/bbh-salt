{% set host = opts.id.split('.') %}

include:
  - /apps/ceph/radosgw/install-ceph-radosgw

/etc/ceph/ceph.client.radosgw.keyring:
  file.managed:
    - contents_pillar: ceph-client-{{ host[0] }}-keyring
    - mode: 640
    - user: ceph
    - group: ceph
    - require:
      - sls: /apps/ceph/radosgw/install-ceph-radosgw
