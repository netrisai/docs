.. meta::
    :description: Netris AI host networking

===================================
NHN - Netris Host Networking Plugin
===================================

Netris host networking (NHN) plugin runs on the GPU host to provide automatic networking configuration and monitoring. Netris NHN exchanges metadata with the switch through LLDP. Netris NHN does not need access to the Netris controller. Netris NHN only receives IP and static route information relevant to the particular host it is running - based on the topology and actual wiring. Netris NHN configures IP address and static route information for all network interfaces connected to Netris-managed switch fabrics (E-W, N-S - Ethernet only). Netris NHN package provides an optional installer for DPU firmware and settings. Netris NHN service will continuously monitor whether the DPU configuration parameters are aligned with NVIDIA Spectrum-X guide and will send alarms to Netris controller if errors are detected.

Installation
------------

This tutorial provides a step-by-step guide for installing the Netris NHN software on your host system. Please follow the instructions carefully to ensure a successful installation.

**Prerequisites**
Before you begin, ensure that you have the following:

* A compatible operating system installed on the host (Ubuntu 24.04).
* Access to the internet for downloading packages.
* The following packages downloaded and hosted in the ``/opt/nvidia/v1.2.0`` directory of the server:

    * DOCA
    * BFB
    * NVN-CC


Step 1: Install the Netris NHN Plugin
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Add the Netris Package Repository:

Download and install the GPG key for the Netris repository:

.. code-block:: shell-session

  wget -qO - https://repo.netris.ai/repo/public.key | sudo gpg --dearmor -o /usr/share/keyrings/netris.gpg


Add the Netris repository to your system's sources list:

.. code-block:: shell-session

 echo "deb [signed-by=/usr/share/keyrings/netris.gpg] http://repo.netris.ai/repo/ noble main" | sudo tee /etc/apt/sources.list.d/netris.list
 
Install the Netris NHN Package:

.. code-block:: shell-session

 sudo apt update && sudo apt install netris-hnp



Step 2: Upload Required Packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Upload the previously downloaded packages (DOCA, BFB, NVN-CC) to the specified directory on your server: 

.. code-block:: shell-session

 /opt/nvidia/v1.2.0


Step 3: Configure DPU Parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This step is configuring DPU parameters as per NVIDIA Spectrum-X deployment guide. 

.. code-block:: shell-session

 /opt/netris/bin/installer

Note: The installer may prompt a server reboot. If the server reboots, run the installer again to ensure proper configuration.


Step 5: Verify the Netris NHN Service
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Netris NHN service should autostart and run in the background. This service is exchanging metadata with the switch through LLDP to "know" what IP address and static route to configure on the server and to report any detected DPU configuration errors to the Netris controller if.

The Netris NHN software includes a systemd service that handles host configuration and monitoring. To check the status of this service, run the following command

.. code-block:: shell-session

 sudo systemctl status netris-hnp.service

If the service is not running, restart it using the following command:

.. code-block:: shell-session

 sudo systemctl restart netris-hnp.service


.. note::

    The version of Netris NHN is aligned with the Spectrum-X guide version, which ensures compatibility with NVIDIA package versions. For example, Netris version 4.4.0 corresponds to Spectrum-X version 1.2.0.


