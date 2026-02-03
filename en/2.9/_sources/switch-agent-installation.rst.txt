.. meta::
  :description: Netris Switch Agent Installation

********************************
Netris switch agent installation
********************************

For Cumulus Linux
=================
Requirements:
* Fresh install of Cumulus Linux v. 3.7.(x) - Cumulus 4.X is in the process of validation and will be supported in the next Netris release.

Configure the OOB Management IP address
---------------------------------------
Configure out of band management IP address, and in case Netris Controller is not in the same OOB network then configure a route to Netris Controller. No default route or other IP addresses should be configured. 

.. code-block:: shell-session

    sudo vim /etc/network/interfaces

.. code-block:: shell-session

 # The loopback network interface
 auto lo
 iface lo inet loopback
 
 # The primary network interface
 auto eth0
 iface eth0 inet static
         address <Management IP address/prefix length>
         up ip ro add <Controller address> via <Management network gateway> #delete this line if Netris Controller is located in the same network with the switch.
 
 source /etc/network/interfaces.d/*

.. code-block:: shell-session

 sudo ifreload -a

Configure Cumulus Linux license
-------------------------------

.. code-block:: shell-session

 sudo cl-license -i

Copy/paste the Cumulus Linux license string then press ctrl-d.

Install the Netris Agent 
------------------------
1. Add netris repository using Netris Controller as an http proxy. Replace <Your Netris Controller address> with your actual Netris Controller address.

.. note::

 Netris Controller built-in proxy, by default, permits RFC1918 IP addresses (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16).
 If your management network is using IP addresses outside these ranges you will need to configure iptables on the Netris Controller accordingly.

.. code-block:: shell-session

 export http_proxy=http://<Your Netris Controller address>:3128

 wget -qO - http://repo.netris.ai/repo/public.key | sudo apt-key add -

 echo "deb http://repo.netris.ai/repo/ jessie main" | sudo tee /etc/apt/sources.list.d/netris.list

2. Update the apt

.. code-block:: shell-session

 echo -e 'Acquire::http::Proxy "http://<Your Netris Controller address>:3128";\nAcquire::https::Proxy "http://<Your Netris Controller address>:3128";' | sudo tee -a /etc/apt/apt.conf.d/netris-proxy
 
 sudo apt update

3. Install Netris Agent and dependencies

.. code-block:: shell-session

 sudo apt install netris-sw

4. Initialize the switch using netris-setup

Description of netris-setup parameters

.. code-block:: shell-session

 --auth - Authentication key, "6878C6DD88224981967F67EE2A73F092" is the default key.
 --controller - IP address or domain name of Netris Controller. 
 --hostname - The hostname for the current switch, this hostname should match the name defined in the Controller.
 --lo - IP address for the loopback interface, as it is defined in the controller.
 --type - Role of the switch in your topology: spine/leaf  
 
.. code-block:: shell-session

 sudo /opt/netris/bin/netris-setup --auth=<authentication key> --controller=<IP or FQDN> --hostname=<name> --lo=<loopback IP address> --type=<spine/leaf>

5. Reboot the switch

.. code-block:: shell-session

 sudo reboot

Once the switch boots up you should see its heartbeat going from Critical to OK in Net→Inventory, Telescope→Dashboard, and switch color will reflect its health in Net→Topology

Screenshot: Net→Inventory

.. image:: images/inventory_heartbeat.png
    :align: center

For Ubuntu SwitchDev
==================== 
.. note::

  Further installation requires a Console and Internet connectivity via management port!
  
1. NOS Uninstall

Fist of all uninstall current NOS using **Uninstall OS** from grub menu:

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
  echo "nameserver 1.1.1.1" > /etc/resolv.conf

Update ONIE to the supported version. 

.. note::

  ONIE image available for Mellanox switches only!

.. code-block:: shell-session

  onie-self-update http://repo.netris.ai/repo/onie-updater-x86_64-mlnx_x86-r0

3. NOS Install

Select **Install OS** from grub menu:

.. image:: images/installOS.png
    :align: center

In case you don't have DHCP in the management network, then stop ONIE discovery service and configure IP address and default gateway manually:

.. code-block:: shell-session

  onie-discovery-stop
  ip addr add <management IP address/prefix> dev eth0
  ip route add default via <gateway of management network>
  echo "nameserver 1.1.1.1" > /etc/resolv.conf

Install Ubuntu-SiwtchDev from the Netris custom image:

.. code-block:: shell-session

  onie-nos-install http://repo.netris.ai/repo/netris-ubuntu-18.04.1.bin

Default username/password
 
``netris/newNet0ps``

Configure the OOB Management IP address
---------------------------------------
Configure out of band management IP address, and in case Netris Controller is not in the same OOB network then configure a route to Netris Controller. No default route or other IP addresses should be configured.

.. code-block:: shell-session

 sudo vim /etc/network/interfaces

.. code-block:: shell-session

  # The loopback network interface
  auto lo
  iface lo inet loopback

  # The primary network interface
  auto eth0
  iface eth0 inet static
      address <Management IP address/prefix length>
      up ip ro add <Controller address> via <Management network gateway> #delete this line if Netris Controller is located in the same network with the switch.

  source /etc/network/interfaces.d/*

.. code-block:: shell-session

 sudo ifreload -a

Install the Netris Agent 
------------------------
1. Add netris repository using Netris Controller as an http proxy. Replace <Your Netris Controller address> with your actual Netris Controller address.

.. note::

  Netris Controller built-in proxy, by default, permits RFC1918 IP addresses (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16). If your management network is using IP addresses outside these ranges you will need to configure iptables on the Netris Controller accordingly.

.. code-block:: shell-session

 export http_proxy=http://<Your Netris Controller address>:3128
 
 wget -qO - http://repo.netris.ai/repo/public.key | sudo apt-key add -
 
 echo "deb http://repo.netris.ai/repo/ bionic main" | sudo tee /etc/apt/sources.list.d/netris.list
 
2. Update the apt

.. code-block:: shell-session

  echo -e 'Acquire::http::Proxy "http://<Your Netris Controller address>:3128";\nAcquire::https::Proxy "http://<Your Netris Controller address>:3128";' | sudo tee -a /etc/apt/apt.conf.d/netris-proxy
  
  sudo apt update
 
3. Install Netris Agent and dependencies
 
.. code-block:: shell-session

  sudo apt-get update && sudo apt-get install netris-sw
  
4. Initialize the switch using netris-setup

Description of netris-setup parameters

.. code-block:: shell-session

  --auth - Authentication key, "6878C6DD88224981967F67EE2A73F092" is the default key.
  --controller - IP address or domain name of Netris Controller.
  --hostname - The hostname for the current switch, this hostname should match the name defined in the Controller.
  --lo - IP address for the loopback interface, as it is defined in the controller.
  --type - Role of the switch in your topology: spine/leaf

.. code-block:: shell-session

  sudo /opt/netris/bin/netris-setup --auth=<authentication key> --controller=<IP or FQDN> --hostname=<name> --lo=<loopback IP address> --type=<spine/leaf>

5. Reboot the switch

.. code-block:: shell-session

  sudo reboot
