{% set service = 'cinder' %}
include:
  - /apps/openstack/common/uca
  - /apps/ceph/install-ceph-common

{% for package in pillar[ service + '_configuration']['pkgs'] %}
{{ package }}:
  pkg.installed:
    - requires:
      - sls: /apps/openstack/common/uca
{% endfor %}
