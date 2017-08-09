include:
  - /apps/clients/packages
  - /states/system/dod-root-ca

/usr/lib64:
  file.directory:
    - makedirs: True

cackey:
  pkg.installed:
    - sources:
      - cackey: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/cac/files/cackey_0.7.5-1_amd64.deb
    - requires:
      - file: /usr/lib64
