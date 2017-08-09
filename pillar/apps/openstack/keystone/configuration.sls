keystone_configuration:
  pkgs:
    - keystone
    - python-ldap
    - python-ldappool
    - python-openstackclient
    - ldap-utils
  hosts:
    - 10.10.5.120
  internal_endpoint:
    protocol: "http://"
    url: 10.10.5.200
    port: ":35357"
    path: /v3
  admin_endpoint:
    protocol: "http://"
    url: 10.10.5.200
    port: ":35357"
    path: /v3
  public_endpoint:
    protocol: "https://"
    url: vta.cybbh.space
    port: ":5000"
    path: /v3
