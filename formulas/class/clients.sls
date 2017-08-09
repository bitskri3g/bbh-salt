include:

{% if grains['reboot_required'] == true %}

  - /states/system/reboot

{% else %}

{% if (grains['status'] == 'preprov') or (grains['status'] == 'prov') or (grains['status'] == 'preprod') or (grains['status'] == 'prod') %}
  - /formulas/common/prov
  - /states/net/clients
  - /states/system/dod-root-ca
  - /states/system/nosleep
  - /states/system/no-recovery
{% endif %}

{% if (grains['status'] == 'prov') or (grains['status'] == 'preprod') or (grains['status'] == 'prod') %}
  - /formulas/common/preprod
  - /apps/clients/chrome/google-chrome-repo
  - /apps/clients/packages
  - /apps/clients/cac/cackey
{% endif %}

{% if (grains['status'] == 'preprod') or (grains['status'] == 'prod') %}
  - /formulas/common/prod
  - /apps/clients/arduino/groups
  - /apps/clients/chrome/configure-chrome-cac
  - /apps/clients/firefox/configure-firefox-cac
  - /apps/clients/windows-vm/create-windows-vm
  - /apps/clients/sssd/configure-sssd
  - /apps/clients/ssh/configure-ssh
{% endif %}

{% if grains['status'] == 'preprov' %}
upgrade_status_to_prov:
  grains.present:
    - name: status
    - value: prov
    - force: true
    - require:
      - sls: /formulas/common/prov
      - sls: /states/net/clients
      - sls: /states/system/dod-root-ca
      - sls: /states/system/nosleep
      - sls: /states/system/no-recovery
{% endif %}

{% if grains['status'] == 'prov' %}
upgrade_status_to_preprod:
  grains.present:
    - name: status
    - value: preprod
    - force: true
    - require:
      - sls: /formulas/common/prov
      - sls: /states/net/clients
      - sls: /states/system/dod-root-ca
      - sls: /states/system/nosleep
      - sls: /states/system/no-recovery
      - sls: /formulas/common/preprod
      - sls: /apps/clients/chrome/google-chrome-repo
      - sls: /apps/clients/packages
      - sls: /apps/clients/cac/cackey
{% endif %}

{% if (grains['status'] == 'preprod') or (grains['status'] == 'prod') %}
upgrade_status_to_prod:
  grains.present:
    - name: status
    - value: prod
    - force: true
    - require:
      - sls: /formulas/common/prov
      - sls: /states/net/clients
      - sls: /states/system/dod-root-ca
      - sls: /states/system/nosleep
      - sls: /states/system/no-recovery
      - sls: /formulas/common/preprod
      - sls: /apps/clients/chrome/google-chrome-repo
      - sls: /apps/clients/packages
      - sls: /apps/clients/cac/cackey
      - sls: /formulas/common/prod
      - sls: /apps/clients/arduino/groups
      - sls: /apps/clients/chrome/configure-chrome-cac
      - sls: /apps/clients/firefox/configure-firefox-cac
      - sls: /apps/clients/windows-vm/create-windows-vm
      - sls: /apps/clients/sssd/configure-sssd
      - sls: /apps/clients/ssh/configure-ssh
{% endif %}

{% endif %}
