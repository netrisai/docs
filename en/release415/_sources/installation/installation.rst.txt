.. meta::
    :description: Controller Installation

=======================
Controller Installation
=======================

Netris Controller is installed as a Kubernetes application on dedicated bare-metal hosts.

.. note::

  Select ONE installation option below.

- :doc:`controller-k3s-air-gap-ha` — install the Netris Controller as a highly-available VM-based deployment, including in air-gapped environments.
- :doc:`controller-k8s-installation` — deploy the Netris Controller as a Kubernetes application using the official Helm chart.
- :doc:`ztp` — automatically provision and onboard switches once the controller is installed.

.. toctree::
   :maxdepth: 2
   :caption: Controller Installation
   :hidden:

   controller-k3s-air-gap-ha
   controller-k8s-installation
   ztp
