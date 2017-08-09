include:

### Previously Executed States ###

  - /formulas/class/ipa/prov

### Common States ###

### Network Configuration States ###

### Disk Configuration States ###

### Application States ###

  - /apps/ipa/install-ipa

### Status Configuration Changes ###

{% if grains['status'] == 'prov' %}
upgrade_status_to_preprod:
  grains.present:
    - name: status
    - value: preprod
    - force: true
    - require:
      - sls: /apps/ipa/install-ipa
      - sls: /formulas/class/ipa/prov
{% endif %}
