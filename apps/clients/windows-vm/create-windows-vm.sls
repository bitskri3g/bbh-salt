include:
  - /apps/clients/packages
  - /apps/clients/samba/configure-samba

/home/usacys/share:
  file.directory:
    - user: usacys
    - group: usacys
    - makedirs: True
    - require:
      - sls: /apps/clients/samba/configure-samba

/home/usacys/vms/winStart.sh:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/windows-vm/files/winStart.sh
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/windows-vm/files/hash
    - makedirs: True
    - user: root
    - group: root
    - mode: 755

check_windows_vm:
  cmd.script:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/windows-vm/files/check_windows_vm.sh
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/windows-vm/files/hash
    - require:
      - sls: /apps/clients/packages
      - /home/usacys/vms/winStart.sh

/etc/skel/.bash_aliases:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/windows-vm/files/bash_aliases
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/windows-vm/files/hash

