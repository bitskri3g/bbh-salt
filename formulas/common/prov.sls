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
  - /states/system/rsyslog
  - /states/system/package-cache

{% endif %}

{{ sls }}-nop:
  test.nop

