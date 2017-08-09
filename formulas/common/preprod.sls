
### Check if reboot grain is set
### If set, reboot.  If unset, continue.

{% if grains['reboot_required'] == true %}
include:
  - /states/system/reboot

{% endif %}

### Previously Executed States ###

{{ sls }}-nop:
  test.nop
