include:

### Previously Executed States ###

  - /formulas/class/compute/prov

### Common States ###

  - /formulas/common/preprod

### Network Configuration States ###

### Disk Configuration States ###

### Application States ###

  - /apps/openstack/common/uca
  - /apps/openstack/nova/install-nova-compute
  - /apps/openstack/neutron/install-neutron-compute
  - /apps/ceph/install-ceph-common

### Status Configuration Changes ###
{{ sls }}-nop:
  test.nop

{% if grains['status'] == 'prov' %}
upgrade_status_to_preprod:
  grains.present:
    - name: status
    - value: preprod
    - force: true
    - require:
      - sls: /formulas/class/compute/prov
      - sls: /apps/openstack/common/uca
      - sls: /apps/openstack/nova/install-nova-compute
      - sls: /apps/openstack/neutron/install-neutron-compute
      - sls: /apps/ceph/install-ceph-common
      - sls: /formulas/common/preprod
{% endif %}
