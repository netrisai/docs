.. meta::
    :description: Netris Healthchecks

################################################################
Netris Healthchecks
################################################################

Netris includes built-in healthchecks to monitor the status of various network services and applications. These healthchecks help ensure that your network infrastructure is functioning optimally by providing real-time insights into service availability and performance.

There are three main categories of healthchecks in Netris:

* **Node Health**: Node-level health checks that validate whether a node is functioning properly.
* **Fabric Health**: Control-plane and protocol-level checks that validate the network fabric as a whole is functioning properly.
* **Switch Port Health**: Port-level checks that validate whether a specific switch port is functioning properly.

.. tip:: The default threshold values can be adjusted in the Settings -> Monitoring Check Thresholds section of the Netris web interface.

.. image:: /images/monitoring-thresholds.png
   :alt: Monitoring Check Thresholds
   :align: center
   :class: with-shadow

.. raw:: html

  <br />

.. csv-table:: Netris Healthchecks
   :file: /tables/healthchecks.csv
   :widths: 10, 10, 15, 30, 15, 10
   :header-rows: 1
