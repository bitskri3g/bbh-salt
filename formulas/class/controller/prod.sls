include:

### Common States

  - /formulas/class/controller/preprod
  - /formulas/common/prod

### Custom Per-Controller States

{% if grains['host'] == 'controller00' %}
  
  - /apps/ceph/mon/create-mon0
  - /apps/haproxy/create-haproxy-0
  - /apps/memcached/create-memcached-0
  - /apps/mysql/create-mysql-0
  - /apps/rabbitmq/create-rabbitmq-0
  - /apps/openstack/glance/create-glance-0
  - /apps/openstack/heat/create-heat-0
  - /apps/openstack/horizon/create-horizon-0
  - /apps/openstack/keystone/create-keystone-0
  - /apps/openstack/neutron/create-neutron-0
  - /apps/openstack/nova/create-nova-0
  - /apps/openstack/cinder/create-cinder-0
  - /apps/ceph/radosgw/create-radosgw-0
  - /apps/graylog/create-graylog-0

{% endif %}

{% if grains['host'] == 'controller02' %}

  - /apps/ceph/mon/create-mon2
  - /apps/openstack/glance/create-glance-2
  - /apps/openstack/nova/create-nova-2
  - /apps/openstack/neutron/create-neutron-2

{% endif %}

{% if grains['host'] == 'controller03' %}

  - /apps/ceph/mon/create-mon1
  - /apps/openstack/neutron/create-neutron-3
  - /apps/openstack/horizon/create-horizon-3

{% endif %}

{{ sls }}-nop:
  test.nop

{% if grains['status'] == 'preprod' %}
### System status state
  
upgrade_status_to_prod:
  grains.present:
    - name: status
    - value: prod
    - force: true
    - require:
      - sls: /formulas/class/controller/preprod
      - sls: /formulas/common/prod

{% endif %}
