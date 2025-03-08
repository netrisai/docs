.. _switch-agent-installation:
.. meta::
  :description: Network Switch Initial Setup

======================================
Nvidia Cumulus v5.9+ Switch Initial Setup
======================================


.. note::

  Further installation requires a Console and Internet connectivity via the management port!

If the switch has pre-installed network operating system (NOS), it needs to be uninstalled first


1. NOS Uninstall (if pre-installed)

To uninstall the current NOS, access **ONIE** from the GRUB menu and select the  **Uninstall OS** option.
   
.. image:: images/uninstallOS.png
   :align: center
    
Once it's done, the switch will automatically reboot and get ready for the installation of the Cumulus Linux.


2. NOS Install

If there is no DHCP in the management network, stop the onie-discovery service and configure an IP address and default gateway manually. 

.. code-block:: shell-session

  onie-stop
  
.. code-block:: shell-session

  ip addr add <management IP address/prefix> dev eth0
  
.. code-block:: shell-session

  ip route add default via <gateway of the management network>
  
.. code-block:: shell-session

  echo "nameserver <DNS server address>" > /etc/resolv.conf

The Cumulus image should be available on a web server to which the switch has access through the local network or the Internet.

Example:

.. code-block:: shell-session

  onie-nos-install http://192.168.100.10/cumulus-linux-5.9.1-mlx-amd64.bin

After completion of the installation, the switch will automatically reboot.

To login use the default username and password for Cumulus v5.9:
 
``cumulus/cumulus``


3. Set up the Out-of-Band (OOB) Management.

Upon installation of Cumulus Linux v5.9 or later ZTP must be disabled and internet connectivity must be provided to the switch via OOB management network:

Disable ztp:

.. code-block:: shell-session

    sudo ztp -d

If there is no DHCP server in the OOB management network, then IP/Gateway/DNS information must be configured manually:

.. code-block:: shell-session

    nv set interface eth0 ip address <IP-ADDRESS/MASK>
    nv set interface eth0 ip gateway <DEFAULT-GATEWAY>
    nv set service dns mgmt server <DNS-SERVER1>
    nv set service dns mgmt server <DNS-SERVER2>
    nv unset interface eth0 ip address dhcp
    nv config apply -y
    nv config save


4. Netris agent installation.

Navigate to the Net–>Inventory section and click the three vertical dots (⋮) on the right side of the switch you are provisioning. Then click Install Agent and copy the one-line installer command to your clipboard.

.. image:: images/Switch-agent-installation-Inventory-cl5.9.png
   :align: center

.. image:: images/Switch-agent-installation-oneliner-cl5.9.png
   :align: center

.. image:: images/Switch-agent-installation-cli-cl5.9.png
   :align: center

6. Reboot the switch

.. code-block:: shell-session

 sudo reboot

7. Netris agent connected to the controller.

.. image:: images/Switch-agent-installation-Inventory-online-cl5.9.png
   :align: center

Once the switch is back, the Heartbeat status should be "OK" in the Netris controller.
