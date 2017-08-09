ceph:
  pkgrepo.managed:
    - humanname: Ceph Kraken
    - name: deb https://download.ceph.com/debian-kraken/ xenial main
    - file: /etc/apt/sources.list.d/ceph.list
    - key_url: https://download.ceph.com/keys/release.asc
