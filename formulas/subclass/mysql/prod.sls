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

  - /states/net/mysql

### Application States

  - /apps/mysql/install-mysql
  - /apps/mysql/install-python-pymysql
  - /apps/mysql/configure-mysql
  
### Status upgrade

### State that transitions 'status' from preprod to prod

upgrade_status_to_prod:
  grains.present:
    - name: status
    - value: prod
    - force: true
    - require:
      - sls: /states/auth/root-ssh
      - sls: /states/net/mysql
      - sls: /apps/mysql/install-mysql
      - sls: /apps/mysql/install-python-pymysql
      - sls: /apps/mysql/configure-mysql
{% endif %}
