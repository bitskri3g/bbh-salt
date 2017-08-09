include:

### Common States

  - /formulas/class/controller/prov
  - /formulas/common/preprod

### Application States

  - /apps/libvirt/install-libvirt
  - /apps/libvirt/config-images

{{ sls }}-nop:
  test.nop

{% if grains['status'] == 'prov' %}
### Status upgrade
### State that transitions 'status' from provisioned to preproduction

upgrade_status:
  grains.present:
    - name: status
    - value: preprod
    - force: true
    - require:
      - sls: /formulas/class/controller/prov
      - sls: /formulas/common/preprod
      - sls: /apps/libvirt/install-libvirt
      - sls: /apps/libvirt/config-images  
{% endif %}
