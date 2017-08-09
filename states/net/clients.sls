{% for interface in salt['network.ifacestartswith']('192.168') %}

{{ interface }}:
  network.managed:
    - enabled: True
    - proto: dhcp
    - type: eth

reboot_required:
  grains.present:
    - value: true
    - force: true
    - onchanges:
      - network: {{ interface }}

{% endfor %}

avahi_service:
  service.dead:
    - name: avahi-daemon
    - enable: False
