### Generally called if a state detects that the reboot_required
### grain is set to 'true'.  Sets reboot_required to 'false and reboots

reboot_not_required:
  grains.present:
    - name: reboot_required
    - value: false
    - force: true

system.reboot:
  module.run
