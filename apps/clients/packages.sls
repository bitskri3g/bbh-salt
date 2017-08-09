{% for package in pillar['client_packages']['pkgs'] %}
{{ package }}:
  pkg.installed
{% endfor %}

