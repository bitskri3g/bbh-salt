127.0.0.1:
  host.only:
    - hostnames:
      - {{ grains['id'] }}
      - {{ grains['host'] }}
      - localhost
