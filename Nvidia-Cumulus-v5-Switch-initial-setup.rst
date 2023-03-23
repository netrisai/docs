.. _switch-agent-installation:
.. meta::
  :description: Network Switch initial setup

============================
Nvidia Cumulus v5 Switch Initial Setup
============================
Requirements:
* Fresh install of Cumulus Linux Cumulus v5.x.

Disable ztp:

.. code-block:: shell-session

    sudo ztp -d


After installing Cumulus Linux v5.x, you will be in the default 'mgmt' VRF. To switch to the default VRF, follow these steps:

.. code-block:: shell-session

    sudo ip vrf exec default bash


Configure the OOB Management IP address
***************************************
Configure internet connectivity via management port like following and remove "mgmt" vrf configuration:

.. code-block:: shell-session

    sudo vim /etc/network/interfaces

.. code-block:: shell-session

 # The loopback network interface
 auto lo
 iface lo inet loopback
 
 # The primary network interface
 auto eth0
 iface eth0 inet static
         address <management IP address/prefix length>
         gateway <gateway of management network>
 
 source /etc/network/interfaces.d/*

.. code-block:: shell-session

 sudo ifreload -a
 
.. note::

  You might see a one-time warning in the output of ifreload, which you can ignore:
  
  warning: mgmt: cmd '/usr/lib/vrf/vrf-helper delete mgmt 1001' failed: returned 1 (Failed to delete cgroup for vrf mgmt)
 
.. code-block:: shell-session
 
 echo "nameserver <dns server>" | sudo tee /etc/resolv.conf

Continue to :ref:`"Install the Netris Agent"<switch-agent-installation-install-the-netris-agent>` section.
