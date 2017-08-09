sleep.target:
  module.run:
    - name: service.mask
    - m_name: sleep.target

suspend.target:
  module.run:
    - name: service.mask
    - m_name: suspend.target

hibernate.target:
  module.run:
    - name: service.mask
    - m_name: hibernate.target

hybrid-sleep.target:
  module.run:
    - name: service.mask
    - m_name: hybrid-sleep.target
