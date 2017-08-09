include:
  - /states/disk/common/mdadm-install
  - /states/disk/common/xfsprogs-install

array:
  raid.present:
    - name: /dev/md1
    - level: 10
    - devices:
      - /dev/sdc
      - /dev/sdd
      - /dev/sde
      - /dev/sdf
      - /dev/sdg
      - /dev/sdh
      - /dev/sdi
      - /dev/sdj
    - chunk: 512
    - run: True
    - require:
      - sls: /states/disk/common/mdadm-install

pv_config:
  lvm.pv_present:
    - name: /dev/md1
    - require:
      - array

vg_config:
  lvm.vg_present:
    - name: vg1
    - devices:
      - /dev/md1
    - require:
      - pv_config

lv_config:
  lvm.lv_present:
    - name: kvmfs
    - vgname: vg1
    - extents: 100%FREE
    - require:
      - vg_config

fs:
  blockdev.formatted:
    - name: /dev/mapper/vg1-kvmfs
    - fs_type: xfs
    - require:
      - sls: /states/disk/common/xfsprogs-install
      - lv_config
  
/kvmfs:
  mount.mounted:
    - device: /dev/mapper/vg1-kvmfs
    - fstype: xfs
    - mkmnt: true
    - require:
      - fs
