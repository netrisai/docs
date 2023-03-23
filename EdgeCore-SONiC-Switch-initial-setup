============================
EdgeCore SONiC Devices
============================

.. note::

  Further installation requires a Console and Internet connectivity via management port!
  
1. NOS Uninstall

Uninstall current NOS using **Uninstall OS** from grub menu:

.. image:: images/uninstallOS.png
   :align: center
    
Once the uninstallation is completed, the switch will reboot automatically.

2. NOS Install

Select **Install OS** from grub menu:

.. image:: images/installOS.png
   :align: center

In case you don't have DHCP in the management network, then stop ONIE discovery service and configure IP address and default gateway manually:

.. code-block:: shell-session

  onie-discovery-stop
  ip addr add <management IP address/prefix> dev eth0
  ip route add default via <gateway of management network>
  echo "nameserver <dns server>" > /etc/resolv.conf

Install EdgeCore SONiC image from the Netris repository:

.. code-block:: shell-session

  onie-nos-install http://downloads.netris.ai/Edgecore-SONiC_20211125_074752_ec202012_227.bin

Default username/password
 
``admin/YourPaSsWoRd``

Configure the OOB Management IP address
***************************************
Disable Zero Touch Provisioning for time being.

.. code-block:: shell-session
  
  ztp disable -y

.. note::
  This will take some time, please be patient.

Configure internet connectivity via management port.

.. code-block:: shell-session
  
  ip addr add <management IP address/prefix> dev eth0
  ip route add default via <gateway of management network>
  echo "nameserver <dns server>" > /etc/resolv.conf

Continue to :ref:`"Install the Netris Agent"<switch-agent-installation-install-the-netris-agent>` section.

.. _switch-agent-installation-install-the-netris-agent:
