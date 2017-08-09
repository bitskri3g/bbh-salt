cinder_configuration:
  pkgs:
    - cinder-api
    - cinder-scheduler
    - python-openstackclient
    - cinder-volume
    - python-memcache
  hosts:
    - 10.10.5.180
  internal_endpoint:
    protocol: "http://"
    url: 10.10.5.200
    port: ":8776"
    v3_path: /v3/%\(project_id\)s
    v2_path: /v2/%\(project_id\)s
  admin_endpoint:
    protocol: "http://"
    url: 10.10.5.200
    port: ":8776"
    v3_path: /v3/%\(project_id\)s
    v2_path: /v2/%\(project_id\)s
  public_endpoint:
    protocol: "http://"
    url: vta.cybbh.space
    port: ":8776"
    v3_path: /v3/%\(project_id\)s
    v2_path: /v2/%\(project_id\)s
