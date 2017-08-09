### Check for any newly-provisioned nodes without a status; give them a status of preprov.
### Install appropriate pubkeys in /root/.ssh/authorized_keys

base:
  '*bbh*mil or E@^(workstation|notebook)':
    - match: compound
    - states/status/preprov

### Run all nodes in preprov status through the prov state; apply the prov status if and 
### only if the prov state for the node class succeeds.

### Core Classes

  'G@status:preprov and controller*':
    - match: compound
    - formulas/class/controller/prov

  'G@status:preprov and storage*':
    - match: compound
    - formulas/class/storage/prov

  'G@status:preprov and compute*':
    - match: compound
    - formulas/class/compute/prov

  'G@status:preprov and ipa*':
    - match: compound
    - formulas/class/ipa/prov

  'G@status:preprov and atlas*':
    - match: compound
    - formulas/class/atlas/prov

  'P@status:(preprov|prov|preprod|prod) and E@^(workstation|notebook)':
     - match: compound
     - formulas/class/clients

### Sub-Classes
        
  'G@status:preprov and cephmon*':
    - match: compound
    - formulas/subclass/cephmon/prov

  'G@status:preprov and mysql*':
    - match: compound
    - formulas/subclass/mysql/prov

  'G@status:preprov and memcached*':
    - match: compound
    - formulas/subclass/memcached/prov

  'G@status:preprov and rabbitmq*':
    - match: compound
    - formulas/subclass/rabbitmq/prov
    
  'G@status:preprov and haproxy*':
    - match: compound
    - formulas/subclass/haproxy/prov
    
  'G@status:preprov and keystone*':
    - match: compound
    - formulas/subclass/keystone/prov

  'G@status:preprov and glance*':
    - match: compound
    - formulas/subclass/glance/prov

  'G@status:preprov and nova*':
    - match: compound
    - formulas/subclass/nova/prov

  'G@status:preprov and neutron*':
    - match: compound
    - formulas/subclass/neutron/prov

  'G@status:preprov and horizon*':
    - match: compound
    - formulas/subclass/horizon/prov

  'G@status:preprov and heat*':
    - match: compound
    - formulas/subclass/heat/prov

  'G@status:preprov and cinder*':
    - match: compound
    - formulas/subclass/cinder/prov

  'G@status:preprov and radosgw*':
    - match: compound
    - formulas/subclass/radosgw/prov

  'G@status:preprov and graylog*':
    - match: compound
    - formulas/subclass/graylog/prov

### Run all nodes in prov status through the preprod state; apply the preprod status if and
### only if the preprod state for their class succeeds.

### Core Classes

  'G@status:prov and controller*':
    - match: compound
    - formulas/class/controller/preprod

  'G@status:prov and storage*':
    - match: compound
    - formulas/class/storage/preprod

  'G@status:prov and compute*':
    - match: compound
    - formulas/class/compute/preprod

  'G@status:prov and ipa*':
    - match: compound
    - formulas/class/ipa/preprod

  'G@status:prov and atlas*':
    - match: compound
    - formulas/class/atlas/preprod

### Sub-Classes    
    

  'G@status:prov and cephmon*':
    - match: compound
    - formulas/subclass/cephmon/preprod
    
  'G@status:prov and mysql*':
    - match: compound
    - formulas/subclass/mysql/preprod

  'G@status:prov and memcached*':
    - match: compound
    - formulas/subclass/memcached/preprod

  'G@status:prov and rabbitmq*':
    - match: compound
    - formulas/subclass/rabbitmq/preprod

  'G@status:prov and haproxy*':
    - match: compound
    - formulas/subclass/haproxy/preprod
    
  'G@status:prov and keystone*':
    - match: compound
    - formulas/subclass/keystone/preprod  

  'G@status:prov and glance*':
    - match: compound
    - formulas/subclass/glance/preprod     
    
  'G@status:prov and nova*':
    - match: compound
    - formulas/subclass/nova/preprod

  'G@status:prov and neutron*':
    - match: compound
    - formulas/subclass/neutron/preprod

  'G@status:prov and horizon*':
    - match: compound
    - formulas/subclass/horizon/preprod

  'G@status:prov and heat*':
    - match: compound
    - formulas/subclass/heat/preprod

  'G@status:prov and cinder*':
    - match: compound
    - formulas/subclass/cinder/preprod

  'G@status:prov and radosgw*':
    - match: compound
    - formulas/subclass/radosgw/preprod

  'G@status:prov and graylog*':
    - match: compound
    - formulas/subclass/graylog/preprod

### Run all nodes in preprod status through the prod state; apply the prod status if and
### only if the prod state for their class succeeds.

### Core Classes

  'G@status:preprod and controller*':
    - match: compound
    - formulas/class/controller/prod

  'G@status:preprod and storage*':
    - match: compound
    - formulas/class/storage/prod

  'G@status:preprod and compute*':
    - match: compound
    - formulas/class/compute/prod

  'G@status:preprod and ipa*':
    - match: compound
    - formulas/class/ipa/prod

  'G@status:preprod and atlas*':
    - match: compound
    - formulas/class/atlas/prod

### Sub-Classes
    
  'G@status:preprod and cephmon*':
    - match: compound
    - formulas/subclass/cephmon/prod
    
  'G@status:preprod and mysql*':
    - match: compound
    - formulas/subclass/mysql/prod

  'G@status:preprod and memcached*':
    - match: compound
    - formulas/subclass/memcached/prod

  'G@status:preprod and rabbitmq*':
    - match: compound
    - formulas/subclass/rabbitmq/prod

  'G@status:preprod and haproxy*':
    - match: compound
    - formulas/subclass/haproxy/prod
    
  'G@status:preprod and keystone*':
    - match: compound
    - formulas/subclass/keystone/prod

  'G@status:preprod and glance*':
    - match: compound
    - formulas/subclass/glance/prod     
    
  'G@status:preprod and nova*':
    - match: compound
    - formulas/subclass/nova/prod

  'G@status:preprod and neutron*':
    - match: compound
    - formulas/subclass/neutron/prod

  'G@status:preprod and horizon*':
    - match: compound
    - formulas/subclass/horizon/prod

  'G@status:preprod and heat*':
    - match: compound
    - formulas/subclass/heat/prod

  'G@status:preprod and cinder*':
    - match: compound
    - formulas/subclass/cinder/prod

  'G@status:preprod and radosgw*':
    - match: compound
    - formulas/subclass/radosgw/prod

  'G@status:preprod and graylog*':
    - match: compound
    - formulas/subclass/graylog/prod

### Maintain production status

### Core Classes

  'G@status:prod and controller*':
    - match: compound
    - formulas/class/controller/prod

  'G@status:prod and storage*':
    - match: compound
    - formulas/class/storage/prod

  'G@status:prod and compute*':
    - match: compound
    - formulas/class/compute/prod

  'G@status:prod and ipa*':
    - match: compound
    - formulas/class/ipa/prod

  'G@status:prod and atlas*':
    - match: compound
    - formulas/class/atlas/prod

### Sub-Classes
    
  'G@status:prod and cephmon*':
    - match: compound
    - formulas/subclass/cephmon/prod
    
  'G@status:prod and mysql*':
    - match: compound
    - formulas/subclass/mysql/prod

  'G@status:prod and memcached*':
    - match: compound
    - formulas/subclass/memcached/prod

  'G@status:prod and rabbitmq*':
    - match: compound
    - formulas/subclass/rabbitmq/prod

  'G@status:prod and haproxy*':
    - match: compound
    - formulas/subclass/haproxy/prod

  'G@status:prod and keystone*':
    - match: compound
    - formulas/subclass/keystone/prod

  'G@status:prod and glance*':
    - match: compound
    - formulas/subclass/glance/prod       

  'G@status:prod and nova*':
    - match: compound
    - formulas/subclass/nova/prod

  'G@status:prod and neutron*':
    - match: compound
    - formulas/subclass/neutron/prod

  'G@status:prod and horizon*':
    - match: compound
    - formulas/subclass/horizon/prod

  'G@status:prod and heat*':
    - match: compound
    - formulas/subclass/heat/prod

  'G@status:prod and cinder*':
    - match: compound
    - formulas/subclass/cinder/prod

  'G@status:prod and radosgw*':
    - match: compound
    - formulas/subclass/radosgw/prod

  'G@status:prod and graylog*':
    - match: compound
    - formulas/subclass/graylog/prod
