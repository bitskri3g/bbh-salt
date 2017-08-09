iptables-persistent:
  pkg.installed

public_block_22:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: DROP
    - match: state
    - connstate: NEW
    - source: '10.50.20.0/22'
    - save: True

public_block_21:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: DROP
    - match: state
    - connstate: NEW
    - source: '10.50.24.0/21'
    - save: True

public_block_19:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: DROP
    - match: state
    - connstate: NEW
    - source: '10.50.32.0/19'
    - save: True

public_block_18:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: DROP
    - match: state
    - connstate: NEW
    - source: '10.50.64.0/18'
    - save: True

public_block_17:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: DROP
    - match: state
    - connstate: NEW
    - source: '10.50.128.0/17'
    - save: True

netfilter-persistent:
  service.running
