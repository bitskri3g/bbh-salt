include:

### Previously Executed States ###

### Common States ###

  - /states/system/timezone
  - /states/system/rsyslog

### Network Configuration States ###

  - /apps/ipsec/install-ipa
  - /apps/ipsec/configure-ipa

### Disk Configuration States ###

### Application Configuration States ###

### Status Configuration Changes ###
{% if grains['status'] == 'preprov' %}
upgrade_status_to_prov:
  grains.present:
    - name: status
    - value: prov
    - force: true
    - require:
      - sls: /apps/ipsec/install-ipa
      - sls: /apps/ipsec/configure-ipa
{% endif %}
