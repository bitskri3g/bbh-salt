include:
  - /apps/clients/chrome/google-chrome-repo
  - /apps/clients/packages
  - /apps/clients/cac/cackey
  - /states/system/dod-root-ca

chrome_cac:
  file.managed:
    - name: /usr/lib64/chrome_cac.sh
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/chrome/files/chrome_cac.sh
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/chrome/files/hash
    - mode: 655

chrome_xdg:
  file.managed:
    - name: /etc/xdg/autostart/chrome_cac.desktop
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/chrome/files/chrome_cac.desktop
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/clients/chrome/files/hash
   
