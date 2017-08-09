include:

### Previously Executed States ###

  - /formulas/class/compute/preprod

### Common States ###

  - /formulas/common/prod

### Network Configuration States ###

### Disk Configuration States ###

### Application States ###

  - /apps/ceph/conf-file
  - /apps/openstack/nova/configure-nova-compute
  - /apps/openstack/neutron/configure-neutron-compute

### Status Configuration Changes ###
{{ sls }}-nop:
  test.nop

{% if grains['status'] == 'preprod' %}
upgrade_status_to_preprod:
  grains.present:
    - name: status
    - value: prod
    - force: true
    - require:
      - sls: /formulas/class/compute/preprod
      - sls: /apps/openstack/nova/configure-nova-compute
      - sls: /apps/openstack/neutron/configure-neutron-compute
      - sls: /apps/ceph/conf-file
      - sls: /formulas/common/prod
{% endif %}
