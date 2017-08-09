include:

### Previously Executed States ###

### These are the states that have been executed during previous host statuses
### The are re-ran to ensure that systems are still compliant
### Example:
### - /formulas/class/compute/prov

### Common States ###

### These are the states that are univerally applied across all classes and subclasses
### They typically include system-wide configurations, such as timezone, generic
### firewall configurations, and logging locations
### Example:
###  - /formulas/common/prov

  - /formulas/common/prov

### Network Configuration States ###

### These are the states that provide networking configurations that are unique to
### a class or subclass.  They typically include interface configurations.
### Example:
### - /states/net/[device_class]

  - /states/net/glance

### Disk Configuration States ###

### These are the states that provide disk configurations that are unique to
### a class or subclass.  They typically include interface configurations.
### Example:
### - /states/disk/prov/controller

### Application Configuration States ###

### These are the states that provide application-specific installations and
### configurations.  They are generally only called when hosts are in the
### preproduction and production statuses
### Example:
### - /apps/libvirt/install-libvirt

### Status Configuration Changes ###

### This special state modifies the custom 'status' grain.  It will upgrade
### the grain to the next successive status value given that all requisite
### states pass
### Example:
### {% if grains['status'] == 'prov' %}
### upgrade_status:
###   grains.present:
###     - name: status
###     - value: preprod
###     - force: true
###     - require:
###       - sls: /formulas/class/controller/prov
###       - sls: /formulas/common/preprod
###       - sls: /apps/libvirt/install-libvirt
###       - sls: /apps/libvirt/config-images
### {% endif %}

{% if grains['status'] == 'preprov' %}
upgrade_status:
  grains.present:
    - name: status
    - value: prov
    - force: true
    - require:
      - sls: /formulas/common/prov
      - sls: /states/net/glance
{% endif %}

