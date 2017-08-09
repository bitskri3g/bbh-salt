/kvmfs/vms/{% block hostname %}{% endblock hostname %}/config.xml:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/virsh/files/common.xml
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/virsh/files/hash
    - makedirs: True
    - template: jinja
    - defaults:
        name: {{ self.hostname() }}
        mem: {% block mem %}{% endblock mem %}
        cpu: {% block cpu %}{% endblock cpu %}
        network: |
        {% for network in pillar[pillar_id]['network'] %}
          <interface type='bridge'>
            <source bridge='{{ network }}'/>
            <target dev='vnet{{ loop.index0 }}'/>
            <model type='virtio'/>
            <alias name='net{{ loop.index0 }}'/>
          </interface>
        {% endfor %}


/kvmfs/vms/{{ self.hostname() }}/disk0.raw:
  file.copy:
    - source: /kvmfs/images/{% block os %}{% endblock os %}-latest

qemu-img resize -f raw /kvmfs/vms/{{ self.hostname() }}/disk0.raw {% block disk %}{% endblock disk %}:
  cmd.run:
    - onchanges:
      - /kvmfs/vms/{{ self.hostname() }}/disk0.raw

/kvmfs/vms/{{ self.hostname () }}/data/meta-data:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/virsh/files/common.metadata
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/virsh/files/hash
    - makedirs: True
    - template: jinja
    - defaults:
        hostname: {{ self.hostname() }}

/kvmfs/vms/{{ self.hostname () }}/data/user-data:
  file.managed:
    - source: https://git.cybbh.space/vta/saltstack/raw/master/apps/virsh/files/common.userdata
    - source_hash: https://git.cybbh.space/vta/saltstack/raw/master/apps/virsh/files/hash
    - makedirs: True
    - template: jinja
    - defaults:
        minion_id: {{ self.hostname() }}.bbh.cyberschool.army.mil

genisoimage -o /kvmfs/vms/{{ self.hostname () }}/config.iso -V cidata -r -J /kvmfs/vms/{{ self.hostname () }}/data/meta-data /kvmfs/vms/{{ self.hostname () }}/data/user-data:
  cmd.run:
    - onchanges:
      - /kvmfs/vms/{{ self.hostname () }}/data/meta-data
      - /kvmfs/vms/{{ self.hostname () }}/data/user-data

virsh create /kvmfs/vms/{{ pillar[pillar_id]['hostname'] }}/config.xml:
  cmd.run:
    - onchanges:
      - /kvmfs/vms/{{ self.hostname () }}/config.xml
