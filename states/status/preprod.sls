{% if grains['status'] == 'prov' %}
status:
  grains.present:
    - value: preprod
{% endif %}
