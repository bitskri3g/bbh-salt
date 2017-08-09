{% set sfutils_version = '6.3.0.1005-2' %}

solarflare_packages:
  pkg.installed:
    - version: {{ sfutils_version }}
    - sources:
      - sfutils: https://git.cybbh.space/vta/saltstack/raw/master/apps/openonload/files/sfutils-{{ sfutils_version }}.x86_64.deb
