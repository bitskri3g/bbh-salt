include:

### Previously Executed States ###

  - /formulas/class/ipa/preprod

### Common States ###

### Network Configuration States ###

### Disk Configuration States ###

### Application States ###

  - /apps/ipa/configure-ipa

### Status Configuration Changes ###

{% if grains['status'] == 'preprod' %}
upgrade_status_to_prod:
  grains.present:
    - name: status
    - value: prod
    - force: true
    - require:
      - sls: /formulas/class/ipa/preprod
      - sls: /apps/ipa/configure-ipa
{% endif %}
