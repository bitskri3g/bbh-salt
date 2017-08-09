/home/usacys:
  file.absent

mkhomedir_helper usacys:
  cmd.run:
    - require:
      - /home/usacys
