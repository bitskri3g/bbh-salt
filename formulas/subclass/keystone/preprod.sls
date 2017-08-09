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

  - /states/net/keystone

### Application States

  - /apps/openstack/keystone/install-keystone

### Status upgrade

### State that transitions 'status' from prov to preprod

upgrade_status_to_preprod:
  grains.present:
    - name: status
    - value: preprod
    - force: true
    - require:
      - sls: /states/auth/root-ssh
      - sls: /states/net/keystone
      - sls: /apps/openstack/keystone/install-keystone

{% endif %}
