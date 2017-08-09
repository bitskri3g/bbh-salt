include:
  - /apps/ipa/configure-promotion

promote_stage_users:
  cmd.script:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/promote_users.sh
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/ipa/files/hash
    - template: jinja
    - defaults:
        promote_user_password: {{ pillar['promote_user_password'] }}
        admin_email: {{ pillar['admin_email'] }}
