#!/bin/bash

### This script will configure the graylog2 cluster as outlined below

### Obtain session token using admin user/password stored in pillar.  Place in
### session_token variable

session_token=$(curl -s                                     \
-H 'Content-Type: application/json'                         \
-H 'Accept: application/json'                               \
-X POST 'http://10.10.6.250:9000/api/system/sessions'       \
-d                                                          \
'{
  "username":"admin",
  "password":"{{ root_password }}",
  "host":""
}'                                                          \
| jq -r '.session_id')

### Configure LDAP ###

curl -u $session_token:session                              \
-H 'Content-Type: application/json'                         \
-X PUT http://10.10.6.250:9000/api/system/ldap/settings     \
-d                                                          \
'{
  "enabled": "true",
  "trust_all_certificates": "true",
  "use_start_tls": "false",
  "system_username": "{{ system_username }}",
  "system_password": "{{ system_password }}",
  "ldap_uri": "{{ ldap_uri }}:636",
  "search_base": "{{ search_base }}",
  "search_pattern": "{{ search_pattern}} ",
  "display_name_attribute": "uid",
  "default_group": "Admin"
}'

### Configure Inputs

curl -u $session_token:session                              \
-H 'Content-Type: application/json'                         \
-X POST http://10.10.6.250:9000/api/system/inputs           \
-d                                                          \
'{
  "title": "VTA UDP Input",
  "global": true,
  "type": "org.graylog2.inputs.syslog.udp.SyslogUDPInput",
  "configuration": {
    "expand_structured_data" : false,
    "recv_buffer_size" : 262144,
    "port" : 5514,
    "override_source" : null,
    "force_rdns" : false,
    "allow_override_date" : true,
    "bind_address" : "10.10.6.250",
    "store_full_message" : true
  },
  "node": "null"
}'

