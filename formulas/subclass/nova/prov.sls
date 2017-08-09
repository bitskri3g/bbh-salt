include:

### System states ###

{% if grains['reboot_required'] == true %}

### Set reboot_required grain to false and reboot

  - /states/system/reboot

{% else %}

### Set public keys in /root/.ssh/authorized_keys

  - /states/auth/root-ssh
  - /states/net/common/iptables
  - /states/system/timezone 

### Disk configuration states ###


### Network configuration states.

  - /states/net/nova

### Status upgrade

### State that transitions 'status' from preprov to prov

upgrade_status_to_prov:
  grains.present:
    - name: status
    - value: prov
    - force: true
    - require:
      - sls: /states/auth/root-ssh
      - sls: /states/net/nova

{% endif %}
