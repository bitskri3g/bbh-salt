#!/bin/bash

systemctl stop haproxy.service
letsencrypt certonly -d vta.cybbh.space --agree-tos
cat /etc/letsencrypt/live/vta.cybbh.space/fullchain.pem /etc/letsencrypt/live/vta.cybbh.space/privkey.pem > /etc/letsencrypt/live/vta.cybbh.space/master.pem
systemctl start haproxy.service

systemctl stop haproxy.service
letsencrypt certonly -d console.cybbh.space --agree-tos
cat /etc/letsencrypt/live/console.cybbh.space/fullchain.pem /etc/letsencrypt/live/console.cybbh.space/privkey.pem > /etc/letsencrypt/live/console.cybbh.space/master.pem
systemctl start haproxy.service
