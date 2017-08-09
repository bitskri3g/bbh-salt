include:
  - /apps/openonload/install-sfutils

{% set onload_version = 'openonload-201606-u1.3' %}
{% if grains['onload_installed'] == false %}

extract_onload:
  archive.extracted:
    - name: /root/
    - source: salt://apps/openonload/files/{{ onload_version }}.tgz
    - source_hash: salt://apps/openonload/files/hash
    - require:
      - sls: /apps/openonload/install-sfutils

install_build_essential:
  pkg.installed:
    - name: build-essential

/root/{{ onload_version }}/scripts/onload_install:
  cmd.run:
    - require:
      - extract_onload
    - require_in: 
      - remove_build_essential
      - onload_installed
      - cleanup_directory
      - reboot_required
    - creates:
      - /etc/depmod.d/onload.conf
      - /sbin/onload_tool
      - /usr/bin/onload
      - /etc/init.d/openonload

onload_tool reload:
  cmd.run:
    - requires_in:
      - grains: reboot_is_required
      - grains: onload_installed
  
remove_build_essential:
  pkg.removed:
    - name: build-essential

cleanup_directory:
  file.absent: 
    - name: /root/{{ onload_version }}/
  
onload_installed:
  grains.present:
    - value: true
    - force: true

reboot_is_required:
  grains.present:
    - name: reboot_required
    - value: true
    - force: true

{% else %}

onload_already_installed:
  test.configurable_test_state:
    - name: onload
    - changes: false
    - comment: dummy state that represents valid openonload installation
    - result: true

{% endif %}
