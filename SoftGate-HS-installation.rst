.. meta::
  :description: Netris SoftGate Installation

***************************
SoftGate HS Installation 
***************************

Minimum Hardware Requirements
=============================
* 16 CPU cores
* 128 GB RAM
* 300 GB HDD
* 1x 1GbE NIC OOB
* 2x 10GbE NIC prod

Provision Netris SoftGate software  
==================================
Requires freshly installed **Ubuntu Linux 24.04 LTS** and internet connectivity (air-gapped installation is also avalible). 

1. Navigate to the **Net-->Inventory** section and click the **three vertical dots (⋮)** on the right side of the SoftGate node you are provisioning. Then click **Install Agent** and copy the one-line installer command to your clipboard.

.. image:: /images/softgate-hs-install-agent.png
    :align: center

.. image:: /images/softgate-hs-install-agent-onliner.png
    :align: center

2. Paste the one-line install command on your SoftGate HS node as an ordinary user. (keep in mind that one-line installer commands are unique for each node)

.. image:: /images/softgate-hs-provisioning-cli-output.png
    :align: center

.. note::
  Please note that Netris replaces Netplan with regular ifupdown and attempts to migrate any prior configuration to /etc/network/interfaces.

6. Reboot the SoftGate

.. code-block:: shell-session

  user@host:~$ sudo reboot

Once the server boots up, you should see its heartbeat going from Critical to OK in **Net→Inventory**, **Telescope→Dashboard**, and the SoftGate color will reflect its health in **Net→Topology**.
