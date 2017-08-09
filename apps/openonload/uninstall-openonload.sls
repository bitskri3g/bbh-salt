{% if grains['onload_installed'] == true %}

onload_uninstall:
  cmd.run

onload_installed:
  grains.present:
    - value: false
    - force: true
    - require:
      - onload_uninstall

{% endif %}
