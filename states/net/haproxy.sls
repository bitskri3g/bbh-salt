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
    - ipaddr: 10.10.5.20{{ identifier[1] }}
    - netmask: 255.255.252.0
    - require:
      - /etc/network/interfaces.d/50-cloud-init.cfg

ens4:
  network.managed:
    - name: ens4
    - enabled: True
    - proto: static
    - type: eth
    - ipaddr: 10.50.10.{{ identifier[1] }}
    - netmask: 255.255.0.0
    - gateway: 10.50.255.254
    - dns:
      - 10.50.255.254
    - require:
      - /etc/network/interfaces.d/50-cloud-init.cfg

ens4_1:
  network.managed:
    - name: "ens4:1"
    - enabled: True
    - proto: static
    - type: eth
    - ipaddr: 10.50.10.1{{ identifier[1] }}
    - netmask: 255.255.0.0
    - gateway: 10.50.255.254
    - dns:
      - 10.50.255.254
    - require:
      - /etc/network/interfaces.d/50-cloud-init.cfg

salt_master_routes:
  network.routes:
    - name: ens3
    - routes:
      - name: salt_master
        ipaddr: 192.168.200.248
        netmask: 255.255.255.255
        gateway: 10.10.7.254

reboot_required:
  grains.present:
    - value: true
    - force: true
    - onchanges:
      - network: ens3
