include: 
  - /apps/ceph/repo

install_ceph_common:
  pkg.installed:
    - name: ceph-common
    - require:
      - sls: /apps/ceph/repo
