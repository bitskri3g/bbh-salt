{% if grains['status'] == '' %}

status:
  grains.present:
    - value: preprov

reboot_required:
  grains.present:
    - value: false

{% if 'notebook' not in grains['id'] and 'workstation' not in grains['id'] %}

onload_installed:
  grains.present:
    - value: false

{% endif %}

{% endif %}
