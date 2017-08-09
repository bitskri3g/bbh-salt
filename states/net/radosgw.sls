{% set identifier = grains['host'].split('-') %}


# This removes the interface configuration file placed by cloud-init.
# If left, it will override any changes that you make to your primary nic

/etc/network/interfaces.d/50-cloud-init.cfg:
  file.absent

ens3:
  network.managed:
    - enabled: True
    - proto: static
    - type: eth
    - ipaddr: 10.10.5.19{{ identifier[1] }}
    - netmask: 255.255.252.0
    - gateway: 10.10.7.254
    - dns:
      - 10.10.7.254
    - search_domain: bbh.cyberschool.army.mil
    - require:
      - /etc/network/interfaces.d/50-cloud-init.cfg
ens4:
  network.managed:
    - enabled: True
    - proto: static
    - type: eth
    - ipaddr: 10.30.5.19{{ identifier[1] }}
    - netmask: 255.255.252.0
    - require:
      - /etc/network/interfaces.d/50-cloud-init.cfg

ens5:
  network.managed:
    - enabled: True
    - proto: static
    - type: eth
    - ipaddr: 10.50.5.19{{ identifier[1] }}
    - netmask: 255.255.0.0
    - require:
      - /etc/network/interfaces.d/50-cloud-init.cfg

reboot_required:
  grains.present:
    - value: true
    - force: true
    - onchanges:
      - network: ens3
      - network: ens4
