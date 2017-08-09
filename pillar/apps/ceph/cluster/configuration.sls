configuration:
  cluster: ceph
  fsid: 6a65c3d0-b84e-4c89-bbf7-a38a1966d780
  mon_members:
    cephmon-0:
      - 10.10.6.0:6789
    cephmon-1:
      - 10.10.6.1:6789
    cephmon-2:
      - 10.10.6.2:6789
  rgw_members:
    radosgw-0:
      - 10.10.5.190:7480
