neutron_configuration:
  pkgs:
    - neutron-server
    - neutron-plugin-ml2
    - neutron-linuxbridge-agent
    - neutron-l3-agent
    - neutron-dhcp-agent
    - neutron-metadata-agent
    - python-openstackclient
  hosts:
    - 10.10.5.150
    - 10.10.5.152
    - 10.10.5.153
  internal_endpoint:
    protocol: "http://"
    url: 10.10.5.200
    port: ":9696"
    path: /
  admin_endpoint:
    protocol: "http://"
    url: 10.10.5.200
    port: ":9696"
    path: /
  public_endpoint:
    protocol: "http://"
    url: vta.cybbh.space
    port: ":9696"
    path: /
neutron_compute_configuration:
  pkgs:
    - neutron-linuxbridge-agent
