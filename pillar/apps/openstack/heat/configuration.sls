heat_configuration:
  pkgs:
    - heat-api
    - heat-api-cfn
    - heat-engine
    - python-openstackclient
  hosts:
    - 10.10.5.170
  internal_endpoint:
    protocol: "http://"
    url: 10.10.5.200
    port: ":8004"
    path: /v1/%\(tenant_id\)s
  admin_endpoint:
    protocol: "http://"
    url: 10.10.5.200
    port: ":8004"
    path: /v1/%\(tenant_id\)s
  public_endpoint:
    protocol: "http://"
    url: vta.cybbh.space
    port: ":8004"
    path: /v1/%\(tenant_id\)s
  internal_endpoint_cfn:
    protocol: "http://"
    url: 10.10.5.200
    port: ":8000"
    path: /v1
  admin_endpoint_cfn:
    protocol: "http://"
    url: 10.10.5.200
    port: ":8000"
    path: /v1
  public_endpoint_cfn:
    protocol: "http://"
    url: vta.cybbh.space
    port: ":8000"
    path: /v1
