include: 
  - /apps/ceph/repo

install_ceph:
  pkg.installed:
    - name: ceph
    - require:
      - sls: /apps/ceph/repo