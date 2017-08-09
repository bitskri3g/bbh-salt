include:

### Previously Executed States ###

### Common States ###

  - /formulas/common/prov

### Network Configuration States ###

  - /apps/openonload/install-openonload
  - /states/net/compute

### Disk Configuration States ###

### Application Configuration States ###

{{ sls }}-nop:
  test.nop

### Status Configuration Changes ###
{% if grains['status'] == 'preprov' %}
upgrade_status_to_prov:
  grains.present:
    - name: status
    - value: prov
    - force: true
    - require:
      - sls: /formulas/common/prov
      - sls: /apps/openonload/install-openonload
      - sls: /states/net/compute
{% endif %}
