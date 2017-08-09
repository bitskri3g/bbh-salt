include:
  - /states/net/common/bridge-install

{% set base_octet = grains['ipv4'][0].split('.') %}

ens2f0:
  network.managed:
    - enabled: True
    - type: eth
    - bridge: br0
    - proto: manual
    - require:
      - sls: /states/net/common/bridge-install

ens2f1:
  network.managed:
    - enabled: True
    - type: eth
    - bridge: br1
    - proto: manual
    - require:
      - sls: /states/net/common/bridge-install
ens2f2:
  network.managed:
    - enabled: True
    - type: eth
    - bridge: br2
    - proto: manual
    - require:
      - sls: /states/net/common/bridge-install

ens2f3:
  network.managed:
    - enabled: True
    - type: eth
    - bridge: br3
    - proto: manual
    - require:
      - sls: /states/net/common/bridge-install

br0:
  network.managed:
    - enabled: True
    - type: bridge
    - proto: dhcp
    - ports: ens2f0
    - require:
      - network: ens2f0

br1:
  network.managed:
    - enabled: True
    - type: bridge
    - ipaddr: 10.30.{{ base_octet[2] }}.{{ base_octet[3] }}
    - netmask: 255.255.252.0
    - ports: ens2f1
    - require:
      - network: ens2f1

br2:
  network.managed:
    - enabled: True
    - type: bridge
    - ipaddr: 10.60.{{ base_octet[2] }}.{{ base_octet[3] }}
    - netmask: 255.255.252.0
    - ports: ens2f2
    - require:
      - network: ens2f2

br3:
  network.managed:
    - enabled: True
    - type: bridge
    - ipaddr: 10.50.{{ base_octet[2] }}.{{ base_octet[3] }}
    - netmask: 255.255.0.0
    - ports: ens2f3
    - require:
      - network: ens2f3

reboot_required:
  grains.present:
    - value: true
    - force: true
    - onchanges:
      - network: br0
      - network: br1
      - network: br2
      - network: br3
