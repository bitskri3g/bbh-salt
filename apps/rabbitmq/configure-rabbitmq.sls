create_rmq_user:
  cmd.script:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/rabbitmq/files/mkuser.sh
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/rabbitmq/files/hash
    - template: jinja
    - defaults:
        password: {{ pillar['rmq_openstack_password'] }}

rabbitmqctl set_permissions openstack ".*" ".*" ".*":
  cmd.run
