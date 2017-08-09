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

  - /states/net/graylog

### Application States

  - /apps/graylog/install-graylog
  - /apps/graylog/configure-graylog

### Status upgrade

### State that transitions 'status' from preprod to prod

upgrade_status_to_prod:
  grains.present:
    - name: status
    - value: prod
    - force: true
    - require:
      - sls: /states/auth/root-ssh
      - sls: /states/net/graylog
      - sls: /apps/graylog/install-graylog
      - sls: /apps/graylog/configure-graylog

{% endif %}
