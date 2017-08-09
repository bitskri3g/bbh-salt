include:

### Common States

  - /formulas/common/prov

### Network configuration states ###

  - /apps/openonload/install-openonload
  - /states/net/controller

### Disk configuration states ###

  - /states/disk/controller

### Status upgrade
### State that transitions 'status' from preprov to prov

{{ sls }}-nop:
  test.nop

{% if grains['status'] == 'preprov' %}

upgrade_status:
  grains.present:
    - name: status
    - value: prov
    - force: true
    - require:
      - sls: /formulas/common/prov
      - sls: /states/disk/controller
      - sls: /apps/openonload/install-openonload
      - sls: /states/net/controller
        
{% endif %}
