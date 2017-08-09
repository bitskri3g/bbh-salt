include:

### Common States ###

  - /formulas/common/prov

### Network configuration states.

  - /apps/openonload/install-openonload
  - /states/net/storage

### Status upgrade

### State that transitions 'status' from preprov to prov

{% if grains['status'] == 'preprov' %}

upgrade_status_to_prov:
  grains.present:
    - name: status
    - value: prov
    - force: true
    - require:
      - sls: /formulas/common/prov
      - sls: /apps/openonload/install-openonload
      - sls: /states/net/storage

{% endif %}

{{ sls }}-nop:
  test.nop
