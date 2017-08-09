base:
  '*':
    - /apps/graylog/configuration
  '*notebook*':
    - /infrastructure/clients/packages
    - /apps/ldap/configuration/bind_password
  '*workstation*':
    - /infrastructure/clients/packages
    - /apps/ldap/configuration/bind_password
  'register*':
    - /apps/ipa/configuration/reset_user_password
    - /apps/ipa/configuration/stage_user_password
    - /apps/ipa/configuration/admin_email
    - /apps/ipa/configuration/promote_user_password
  'ipa*':
    - /apps/ipsec/configuration/ipa_ipsec_secret
    - /apps/ipa/configuration/directory_manager_password
    - /apps/ipa/configuration/directory_manager_hash
    - /apps/ipa/configuration/dse_ldif
  'atlas*':
    - /infrastructure/switches/ex2200
    - /infrastructure/switches/ex3300
    - /infrastructure/switches/ex3301
    - /infrastructure/switches/qfx5100
    - /infrastructure/switches/qfx5101
    - /infrastructure/switches/qfx5102
    - /infrastructure/switches/qfx5103
    - /infrastructure/services/linode_pw
    - /infrastructure/services/linode_user
    - /infrastructure/services/linode_email
    - /infrastructure/services/linode_totp
    - /infrastructure/services/cybbh_space_root_mysql_pw
    - /infrastructure/services/booked_mysql_pw
    - /infrastructure/services/booked_admin_pw
    - /infrastructure/services/ipa_admin_pw
    - /infrastructure/services/ipa_admin_user
    - /infrastructure/services/ipa_admin_totp
    - /infrastructure/firewalls/cerberus_0_admin_pw
    - /infrastructure/firewalls/cerberus_1_admin_pw
    - /infrastructure/servers/preseed_root_password
    - /infrastructure/servers/booked_root_password
    - /infrastructure/services/namecheap_pw
    - /infrastructure/services/namecheap_user
    - /infrastructure/services/namecheap_email
    - /apps/ipsec/configuration/atlas_ipsec_secret
  'controller*':
    - /resources/images
  'controller00*':
    - /apps/ceph/vm/mon-0
    - /apps/ceph/vm/rgw-0
    - /apps/mysql/vm/mysql-0
    - /apps/rabbitmq/vm/rabbitmq-0
    - /apps/memcached/vm/memcached-0
    - /apps/haproxy/vm/haproxy-0
    - /apps/graylog/vm/graylog-0
    - /apps/openstack/glance/vm/glance-0    
    - /apps/openstack/keystone/vm/keystone-0
    - /apps/openstack/nova/vm/nova-0
    - /apps/openstack/neutron/vm/neutron-0
    - /apps/openstack/horizon/vm/horizon-0
    - /apps/openstack/heat/vm/heat-0
    - /apps/openstack/cinder/vm/cinder-0
    - /apps/openstack/keystone/configuration
    - /apps/openstack/glance/configuration
    - /apps/openstack/cinder/configuration
    - /apps/openstack/heat/configuration
    - /apps/openstack/horizon/configuration
    - /apps/openstack/neutron/configuration
    - /apps/openstack/nova/configuration
  'controller03*':
    - /apps/ceph/vm/mon-1
    - /apps/openstack/neutron/vm/neutron-3
    - /apps/openstack/horizon/vm/horizon-3
  'controller02*':
    - /apps/ceph/vm/mon-2
    - /apps/openstack/neutron/vm/neutron-2
    - /apps/openstack/nova/vm/nova-2
    - /apps/openstack/glance/vm/glance-2
  'storage*':
    - /apps/ceph/cluster/configuration
    - /apps/ceph/cluster/ceph-client-admin-keyring
    - /apps/ceph/cluster/storage-node-v1-mapping
    - /apps/openstack/keystone/service_password
    - /apps/openstack/keystone/configuration
  'ceph*':
    - /apps/ceph/cluster/configuration
    - /apps/ceph/cluster/ceph-client-admin-keyring
    - /apps/ceph/cluster/ceph-mon-keyring
    - /apps/openstack/keystone/service_password
    - /apps/openstack/keystone/configuration
  'compute*':
    - /apps/ceph/cluster/configuration
    - /apps/ceph/cluster/ceph-client-admin-keyring
    - /apps/ceph/cluster/ceph-client-nova-keyring
    - /apps/ceph/cluster/client-nova-key
    - /apps/openstack/keystone/configuration
    - /apps/openstack/keystone/service_password
    - /apps/memcached/configuration
    - /apps/openstack/nova/nova_openrc
    - /apps/openstack/glance/configuration
    - /apps/rabbitmq/configuration
    - /apps/openstack/nova/service_password
    - /apps/openstack/neutron/neutron_openrc
    - /apps/openstack/neutron/configuration
    - /apps/openstack/neutron/service_password
    - /apps/openstack/nova/placement_openrc
    - /apps/openstack/nova/placement_service_password
  'mysql*':
    - /apps/mysql/configuration/root_password
    - /apps/mysql/configuration/keystone_password
    - /apps/mysql/configuration/address
    - /apps/mysql/configuration/glance_password
    - /apps/mysql/configuration/nova_password
    - /apps/mysql/configuration/neutron_password
    - /apps/mysql/configuration/heat_password
    - /apps/mysql/configuration/cinder_password
    - /apps/openstack/keystone/configuration
    - /apps/openstack/glance/configuration
    - /apps/openstack/nova/configuration
    - /apps/openstack/neutron/configuration
    - /apps/openstack/heat/configuration
    - /apps/openstack/cinder/configuration
  'rabbitmq*':
    - /apps/rabbitmq/configuration
  'graylog*':
    - /apps/graylog/configuration
    - /apps/graylog/password_secret
    - /apps/graylog/root_password
    - /apps/graylog/root_password_sha2
    - /apps/ldap/configuration/bind_password
    - /apps/ldap/configuration/common
    - /apps/ldap/configuration/graylog
  'keystone*':
    - /apps/mysql/configuration/address
    - /apps/mysql/configuration/keystone_password
    - /apps/openstack/common/admin_openrc
    - /apps/openstack/common/admin_pass
    - /apps/openstack/keystone/configuration
    - /apps/openstack/keystone/service_password
    - /apps/ldap/configuration/bind_password
    - /apps/ldap/configuration/common
    - /apps/ldap/configuration/keystone
  'glance*':
    - /apps/memcached/configuration
    - /apps/mysql/configuration/address
    - /apps/mysql/configuration/glance_password
    - /apps/openstack/common/admin_pass
    - /apps/openstack/common/admin_openrc
    - /apps/openstack/keystone/configuration
    - /apps/openstack/keystone/service_password
    - /apps/openstack/glance/configuration
    - /apps/openstack/glance/service_password
    - /apps/openstack/glance/glance_openrc
    - /apps/ceph/cluster/ceph-client-images-keyring
    - /apps/ceph/cluster/configuration
  'nova*':
    - /apps/memcached/configuration
    - /apps/mysql/configuration/address
    - /apps/mysql/configuration/nova_password
    - /apps/openstack/common/admin_pass
    - /apps/openstack/common/admin_openrc
    - /apps/openstack/glance/configuration
    - /apps/openstack/keystone/configuration
    - /apps/openstack/nova/configuration
    - /apps/openstack/nova/placement_configuration
    - /apps/openstack/nova/service_password
    - /apps/openstack/nova/placement_service_password
    - /apps/openstack/nova/nova_openrc
    - /apps/openstack/nova/placement_openrc
    - /apps/rabbitmq/configuration
    - /apps/openstack/neutron/metadata_proxy_password
    - /apps/openstack/neutron/neutron_openrc
    - /apps/openstack/neutron/service_password
    - /apps/openstack/neutron/configuration
  'neutron*':
    - /apps/memcached/configuration
    - /apps/mysql/configuration/address
    - /apps/mysql/configuration/neutron_password
    - /apps/openstack/common/admin_pass
    - /apps/openstack/common/admin_openrc
    - /apps/openstack/neutron/metadata_proxy_password
    - /apps/openstack/keystone/configuration
    - /apps/openstack/neutron/configuration
    - /apps/openstack/neutron/neutron_openrc
    - /apps/openstack/nova/nova_openrc
    - /apps/openstack/nova/configuration
    - /apps/rabbitmq/configuration
    - /apps/openstack/neutron/service_password
    - /apps/openstack/nova/service_password
  'horizon*':
    - /apps/memcached/configuration
    - /apps/openstack/keystone/configuration
    - /apps/openstack/horizon/configuration
  'heat*':
    - /apps/memcached/configuration
    - /apps/mysql/configuration/address
    - /apps/mysql/configuration/heat_password
    - /apps/openstack/common/admin_pass
    - /apps/openstack/common/admin_openrc
    - /apps/openstack/heat/heat_openrc
    - /apps/openstack/heat/configuration
    - /apps/rabbitmq/configuration
    - /apps/openstack/keystone/configuration
    - /apps/openstack/heat/service_password
    - /apps/mysql/configuration/heat_password
  'cinder*':
    - /apps/memcached/configuration
    - /apps/mysql/configuration/address
    - /apps/mysql/configuration/heat_password
    - /apps/openstack/common/admin_pass
    - /apps/openstack/common/admin_openrc
    - /apps/openstack/cinder/cinder_openrc
    - /apps/openstack/cinder/configuration
    - /apps/rabbitmq/configuration
    - /apps/openstack/keystone/configuration
    - /apps/openstack/cinder/service_password
    - /apps/mysql/configuration/cinder_password
    - /apps/ceph/cluster/ceph-client-volumes-keyring
    - /apps/ceph/cluster/configuration
    - /apps/openstack/glance/configuration
    - /apps/openstack/keystone/service_password
  'haproxy*':
    - /apps/openstack/glance/configuration
  'radosgw*':
    - /apps/ceph/cluster/configuration
    - /apps/ceph/cluster/ceph-client-admin-keyring
    - /apps/openstack/common/admin_pass
    - /apps/openstack/common/admin_openrc
    - /apps/openstack/keystone/configuration
    - /apps/openstack/swift/configuration
    - /apps/openstack/swift/service_password
    - /apps/openstack/keystone/service_password
  'radosgw-0*':
    - /apps/ceph/cluster/ceph-client-radosgw-0-keyring
