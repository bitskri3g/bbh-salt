glance_configuration:
  pkgs:
    - glance
    - python-memcache
    - python-rbd
    - python-openstackclient
    - python-rados
  hosts:
    - 10.10.5.130
    - 10.10.5.132
  internal_endpoint:
    protocol: "http://"
    url: 10.10.5.200
    port: ":9292"
    path: /
  admin_endpoint:
    protocol: "http://"
    url: 10.10.5.200
    port: ":9292"
    path: /
  public_endpoint:
    protocol: "https://"
    url: vta.cybbh.space
    port: ":9292"
    path: /
