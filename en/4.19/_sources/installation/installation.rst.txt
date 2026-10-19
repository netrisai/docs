.. meta::
    :description: Controller Installation

=======================
Controller Installation
=======================

Netris Controller is installed as a Kubernetes application on dedicated bare-metal hosts.

Start with one of the installation options below, then use the remaining pages for upgrades, day-2 maintenance, and switch provisioning.

- :doc:`controller-k3s-air-gap-ha` — install the Netris Controller as a highly available, bare-metal-based deployment, including in air-gapped environments.
- :doc:`controller-ha-upgrade` — upgrade an existing HA deployment and the Local Netris Repository.
- :doc:`controller-maintenance-backups` — take controller nodes down for maintenance safely, and locate, verify, and restore MariaDB backups.
- :doc:`controller-k8s-installation` — deploy the Netris Controller as a Kubernetes application using the official Helm chart.
- :doc:`Zero Touch Provisioning <ztp>` — automatically provision and onboard switches after you install the controller.

See :doc:`General Settings <../general-settings>` for the controller-wide settings under Settings → General.

.. toctree::
   :maxdepth: 2
   :caption: Controller Installation
   :hidden:

   controller-k3s-air-gap-ha
   controller-ha-upgrade
   controller-maintenance-backups
   controller-k8s-installation
   ztp
