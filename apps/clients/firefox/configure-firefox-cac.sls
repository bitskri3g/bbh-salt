include:
  - /apps/clients/packages
  - /apps/clients/cac/cackey  
  - /states/system/dod-root-ca

firefox_cac:
  file.managed:
    - name: /usr/lib64/firefox_cac.sh
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/firefox/files/firefox_cac.sh
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/firefox/files/hash
    - mode: 655

firefox_xdg:
  file.managed:
    - name: /etc/xdg/autostart/firefox_cac.desktop
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/firefox/files/firefox_cac.desktop
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/firefox/files/hash

