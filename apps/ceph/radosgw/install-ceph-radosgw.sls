include: 
  - /apps/ceph/repo
  - /apps/openstack/common/uca

{% for package in pillar[ 'rgw_configuration']['pkgs'] %}
{{ package }}:
  pkg.installed:
    - requires:
      - sls: /apps/ceph/repo
{% endfor %}
