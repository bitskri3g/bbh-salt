{% set service = 'graylog' %}

include:
  - /apps/graylog/graylog-repos

{% for package in pillar[ service + '_configuration']['pkgs'] %}
{{ package }}:
  pkg.installed
{% endfor %}
