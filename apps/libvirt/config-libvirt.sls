include:
  - /apps/libvirt/install-libvirt

libvirtd:
  service.running:
    - name: libvirtd
    - require:
      - sls: /apps/libvirt/install-libvirt
