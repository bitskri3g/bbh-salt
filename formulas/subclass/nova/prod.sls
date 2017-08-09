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

### Application States

  - /apps/openstack/nova/install-nova
  - /apps/openstack/nova/configure-nova

### Status upgrade

### State that transitions 'status' from preprod to prod

upgrade_status_to_prod:
  grains.present:
    - name: status
    - value: prod
    - force: true
    - require:
      - sls: /states/auth/root-ssh
      - sls: /states/net/nova
      - sls: /apps/openstack/nova/install-nova
      - sls: /apps/openstack/nova/configure-nova

{% endif %}
