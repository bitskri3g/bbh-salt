{% set service = 'heat' %}
include:
  - /apps/openstack/common/uca

{% for package in pillar[ service + '_configuration']['pkgs'] %}
{{ package }}:
  pkg.installed:
    - requires:
      - sls: /apps/openstack/common/uca
{% endfor %}
