ipmitool chassis bootdev pxe options=efiboot:
  cmd.run:
    - require_in:
      - ipmitool chassis power reset

ipmitool chassis power reset:
  cmd.run
