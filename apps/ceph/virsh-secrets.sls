include:
  - /apps/ceph/nova-key

/etc/ceph/ceph.xml:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ceph/files/ceph.xml
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ceph/files/hash
    - requires:
      - sls: /apps/ceph/nova-key

virsh secret-define --file /etc/ceph/ceph.xml:
  cmd.run

virsh secret-set-value --secret da05968d-4636-4545-aa09-e06b445cb22a --base64 $(cat /etc/ceph/client.nova.key):
  cmd.run
