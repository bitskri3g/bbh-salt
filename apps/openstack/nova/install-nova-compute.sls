include: 
  - /apps/openstack/common/uca

nova-compute:
  pkg.installed:
    - requires:
      - sls: /apps/openstack/common/uca
