{% set base_octet = grains['ipv4'][0].split('.') %}

enp4s0f0:
  network.managed:
    - enabled: True
    - type: eth
    - proto: dhcp

enp4s0f1:
  network.managed:
    - enabled: True
    - type: slave
    - master: bond1

enp4s0f2:
  network.managed:
    - enabled: True
    - type: slave
    - master: bond1

enp4s0f3:
  network.managed:
    - enabled: True
    - type: slave
    - master: bond1

ens7f0:
  network.managed:
    - enabled: True
    - type: slave
    - master: bond0

ens7f1:
  network.managed:
    - enabled: True
    - type: slave
    - master: bond0

bond0:
  network.managed:
    - type: bond
    - ipaddr: 10.30.{{ base_octet[2] }}.{{ base_octet[3] }}
    - netmask: 255.255.252.0
    - mode: 802.3ad
    - slaves: ens7f0 ens7f1
    - require:
      - network: ens7f0
      - network: ens7f1
    - miimon: 100
    - downdelay: 200
    - lacp_rate: fast

bond1:
  network.managed:
    - type: bond
    - ipaddr: 10.40.{{ base_octet[2] }}.{{ base_octet[3] }}
    - netmask: 255.255.252.0
    - mode: 802.3ad
    - slaves: enp4s0f1 enp4s0f2 enp4s0f3
    - require:
      - network: enp4s0f1
      - network: enp4s0f2
      - network: enp4s0f3
    - miimon: 100
    - downdelay: 200
    - lacp_rate: fast
