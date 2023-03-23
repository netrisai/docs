============================
Ubuntu SwitchDev Devices
============================

.. note::

  Further installation requires a Console and Internet connectivity via management port!
  
1. NOS Uninstall

Uninstall current NOS using **Uninstall OS** from grub menu:

.. image:: images/uninstallOS.png
   :align: center
    
Once the uninstallation is completed, the switch will reboot automatically.

2. Update ONIE

Select **Update ONIE** from grub menu:

.. image:: images/updateONIE.png
   :align: center

In case you don't have DHCP in the management network, then stop ONIE discovery service and configure IP address and default gateway manually:

.. code-block:: shell-session

  onie-discovery-stop
  ip addr add <management IP address/prefix> dev eth0
  ip route add default via <gateway of management network>
  echo "nameserver <dns server>" > /etc/resolv.conf

Update ONIE to the supported version. 

.. note::

  ONIE image available for Mellanox switches only!

.. code-block:: shell-session

  onie-self-update http://downloads.netris.ai/onie-updater-x86_64-mlnx_x86-r0

3. NOS Install

Select **Install OS** from grub menu:

.. image:: images/installOS.png
   :align: center

In case you don't have DHCP in the management network, then stop ONIE discovery service and configure IP address and default gateway manually:

.. code-block:: shell-session

  onie-discovery-stop
  ip addr add <management IP address/prefix> dev eth0
  ip route add default via <gateway of management network>
  echo "nameserver <dns server>" > /etc/resolv.conf

Install Ubuntu-SwitchDev from the Netris custom image:

.. code-block:: shell-session

  onie-nos-install http://downloads.netris.ai/netris-ubuntu-18.04.1.bin

Default username/password
 
``netris/newNet0ps``

Configure the OOB Management IP address
***************************************
Configure internet connectivity via management port.

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
         dns-nameserver <dns server>
 
 source /etc/network/interfaces.d/*

.. code-block:: shell-session

 sudo ifreload -a

Continue to :ref:`"Install the Netris Agent"<switch-agent-installation-install-the-netris-agent>` section.