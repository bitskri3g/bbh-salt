sudo:
  pkg.installed

postfix:
  pkg.installed

python-setuptools:
  pkg.installed

docker_pkg:
  pkg.installed:
    - name: docker

pip-install:
  cmd.run:
    - name: easy_install pip
    - require:
      - pkg: python-setuptools
    - reload_modules: True

dockerpy:
  pip.installed:
    - name: docker-py >=1.4.0
    - require:
      - cmd: pip-install
    - reload_modules: True

docker_svc:
  service.running:
    - name: docker
    - enable: True
    - require:
      - pkg: docker_pkg

centos_image_present:
  dockerng.image_present:
    - name: docker.io/centos:latest
    - require:
      - pip: dockerpy
