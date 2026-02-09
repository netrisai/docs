
.. meta::
  :description: Controller Helm Chart Installation

#######################
Helm Chart Installation
#######################

Requirements
------------

* Kubernetes 1.12+
* Helm 3.1+
* PV provisioner support in the underlying infrastructure

Get Repo Info
-------------

Add the Netris Helm repository:

.. code-block:: shell-session

   helm repo add netrisai https://netrisai.github.io/charts
   helm repo update

Installing the Chart
--------------------

In order to install the Helm chart, you must follow these steps:

1. Create the namespace for netris-controller:

.. code-block:: shell-session

   kubectl create namespace netris-controller

1. Install helm chart with netris-controller:

.. code-block::

  helm install netris-controller netrisai/netris-controller \
    --namespace netris-controller \
    --set ingress.hosts={my.domain.com}

Uninstalling the Chart
---------------------------

To uninstall/delete the ``netris-controller`` helm release:

.. code-block::

   helm uninstall netris-controller

Chart Configuration
-------------------

See the `netris-controller README <https://github.com/netrisai/charts/tree/main/charts/netris-controller>`_ for details about configurable parameters and their default values.
