{% set base_octet = grains['ipv4'][0].split('.') %}

ens2f0:
  network.managed:
    - enabled: True
    - type: eth
    - proto: dhcp

ens2f1:
  network.managed:
    - enabled: True
    - type: eth
    - ipaddr: 10.30.{{ base_octet[2] }}.{{ base_octet[3] }}
    - netmask: 255.255.252.0

ens2f2:
  network.managed:
    - enabled: True
    - type: eth
    - ipaddr: 10.60.{{ base_octet[2] }}.{{ base_octet[3] }}
    - netmask: 255.255.252.0

ens2f3:
  network.managed:
    - enabled: True
    - type: eth
    - ipaddr: 10.50.{{ base_octet[2] }}.{{ base_octet[3] }}
    - netmask: 255.255.0.0

