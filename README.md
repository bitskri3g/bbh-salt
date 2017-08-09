This is the official USACYS saltstack repo for the configuration of the Broadband Handrail Virtual Training Area BBH VTA.  It is alpha-quality code, and changes dramatically without warning on a regular basis.

This code comes into play after vta/bootstrap-tftp and vta/bootstrap-preseed handle the initial bootstrapping of the hardware and installation of the operating system.

We currently only support Ubuntu 16.04 LTS on our hardware stack, but support for Debian, CentOS, and mixed environments is coming, as well as an abstraction layer where you can define different hardware configurations in the pillar.

We make the contents of this repository available under the Apache 2.0 license.
