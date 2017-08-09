include:

### Previously Executed States

  - /formulas/class/storage/preprod

### Common States ###

  - /formulas/common/prod

### Application States

  - /apps/ceph/osd/initialize-osd

{% if grains['status'] == 'preprod' %}
upgrade_status:
  grains.present:
    - name: status
    - value: prod
    - force: true
    - require:
      - sls: /formulas/class/storage/preprod
      - sls: /formulas/common/prod
      - sls: /apps/ceph/osd/initialize-osd

{% endif %}
