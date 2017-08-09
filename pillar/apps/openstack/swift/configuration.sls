rgw_configuration:
  pkgs:
    - radosgw
    - python-openstackclient
  hosts:
    - 10.10.5.190
  internal_endpoint:
    protocol: "http://"
    url: 10.10.5.200
    port: ":7480"
    path: /swift/v1/AUTH_%\(tenant_id\)s
  admin_endpoint:
    protocol: "http://"
    url: 10.10.5.200
    port: ":7480"
    path: /swift/v1
  public_endpoint:
    protocol: "https://"
    url: vta.cybbh.space
    port: ":7480"
    path: /swift/v1/AUTH_%\(tenant_id\)s
