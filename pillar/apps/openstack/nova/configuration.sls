nova_configuration:
  pkgs:
    - nova-api
    - nova-conductor
    - nova-consoleauth
    - nova-spiceproxy
    - nova-scheduler
    - python-openstackclient
    - nova-placement-api
    - spice-html5
  hosts:
    - 10.10.5.140
    - 10.10.5.142
  internal_endpoint:
    protocol: "http://"
    url: 10.10.5.200
    port: ":8774"
    path: /v2.1/
  admin_endpoint:
    protocol: "http://"
    url: 10.10.5.200
    port: ":8774"
    path: /v2.1/
  public_endpoint:
    protocol: "https://"
    url: vta.cybbh.space
    port: ":8774"
    path: /v2.1/ 
  
