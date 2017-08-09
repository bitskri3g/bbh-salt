include:

### Previously Executed States

  - /formulas/class/storage/prov

### Common States ###

  - /formulas/common/preprod

### Application States

  - /apps/ceph/install-ceph
  - /apps/ceph/conf-file
  - /apps/ceph/admin-keyring

{% if grains['status'] == 'prov' %}
### Status upgrade
### State that transitions 'status' from provisioned to preproduction

upgrade_status:
  grains.present:
    - name: status
    - value: preprod
    - force: true
    - require:
      - sls: /formulas/class/storage/prov
      - sls: /formulas/common/preprod
      - sls: /apps/ceph/install-ceph
      - sls: /apps/ceph/conf-file
      - sls: /apps/ceph/admin-keyring
{% endif %}

{{ sls }}-nop:
  test.nop
