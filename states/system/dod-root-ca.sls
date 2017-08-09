dod-root-ca-tarball:
  archive.extracted:
    - name: /usr/local/share/ca-certificates
    - source: https://git.cybbh.space/vta/saltstack/raw/master/states/system/files/dod.tar
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/states/system/files/hash
    - enforce_toplevel: False

update-ca-certificates-dod:
  cmd.run:
    - name: update-ca-certificates --fresh

