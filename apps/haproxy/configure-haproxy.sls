include:
  - /apps/haproxy/install-haproxy

set_up_ssl:
  cmd.script:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/haproxy/files/mkcert.sh
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/haproxy/files/hash
    - creates: /etc/letsencrypt/live/vta.cybbh.space/fullchain.pem

/etc/haproxy/haproxy.cfg:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/haproxy/files/haproxy.cfg
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/haproxy/files/hash
    - template: jinja
    - defaults:

haproxy_service:
  service.running:
    - name: haproxy
    - watch:
      - file: /etc/haproxy/haproxy.cfg

systemctl stop haproxy.service && letsencrypt renew --agree-tos && cat /etc/letsencrypt/live/vta.cybbh.space/fullchain.pem /etc/letsencrypt/live/vta.cybbh.space/privkey.pem > /etc/letsencrypt/live/vta.cybbh.space/master.pem && systemctl start haproxy.service:
  cron.present:
    - minute: 30
    - hour: 6

systemctl stop haproxy.service && letsencrypt renew --agree-tos && cat /etc/letsencrypt/live/console.cybbh.space/fullchain.pem /etc/letsencrypt/live/console.cybbh.space/privkey.pem > /etc/letsencrypt/live/console.cybbh.space/master.pem && systemctl start haproxy.service:
  cron.present:
    - minute: 35
    - hour: 6
