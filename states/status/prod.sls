{% if grains['status'] == 'preprod' %}
status:
  grains.present:
    - value: prod
{% endif %}
