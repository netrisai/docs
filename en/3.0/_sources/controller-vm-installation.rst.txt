.. meta::
  :description: Controller Virtual Machine Installation

****************************
Virtual Machine Installation
****************************

Requirements
============

Minimal system requirements for the VM:

* CPU - 4 Core
* RAM - 4 Gb
* Disk - 100Gb
* Network - 1 virtual NIC

Recommended system requirements for the VM:

* CPU - 8 Core
* RAM - 16 Gb
* Disk - 100Gb
* Network - 1 virtual NIC

KVM Hypervisor Installation
===========================
If KVM is not already installed, install Qemu/KVM on the host machine (example provided for Ubuntu Linux 18.04)

.. code-block:: shell-session

  sudo apt-get install virt-manager

VM Controller Installation
==========================

1. Download the Netris Controller image. (contact Netris support for repository access permissions).

.. code-block:: shell-session

  cd /var/lib/libvirt/images 

  sudo wget http://img.netris.ai/netris-controller3.qcow2 

2. Download VM definition file.

.. code-block:: shell-session

  cd /etc/libvirt/qemu

  sudo wget http://img.netris.ai/netris-controller3.xml

3. Define the KVM virtual machine

.. code-block:: shell-session

  sudo virsh define netris-controller3.xml

.. note::
  
  Netris Controller virtual NIC will bind to the “br-mgmt” interface on the KVM host machine. See below for the network interface configuration example.

Example: Network configuration on host (hypervisor) machine. 

.. note::

  replace <Physical NIC>, <host server management IP/prefix length> and <host server default gateway>
  with the correct NIC and IP  for your host machine.
  
.. code-block:: shell-session

  sudo vim /etc/network/interfaces

.. code-block:: shell-session

  #Physical NIC connected to the management network
  auto <Physical NIC>  
  iface <Physical NIC> inet static
        		  address 0.0.0.0/0

  #bridge interface
  auto br-mgmt
  iface br-mgmt inet static
        		  address <host server management IP/prefix length>
        		  gateway <host server default gateway>
        		  bridge-ports <Physical NIC> 

  source /etc/network/interfaces.d/*
  
.. code-block:: shell-session

  sudo ifreload -a

4. Set the virtual machine to autostart and start it.
 
.. code-block:: shell-session

  sudo virsh autostart netris-controller
  
.. code-block:: shell-session
 
  sudo virsh start netris-controller
  
Accessing the Netris Controller
===============================
By default, Netris Controller will obtain an IP address from a **DHCP** server.

Below steps describe how to configure a **Static IP** address for the Netris Controller.

1. Connecting to the VM console.

default credentials. **login**: ``netris`` **password**: ``newNet0ps`` 

.. code-block:: shell-session

  sudo virsh console netris-controller
  
.. note::

  Do not forget to change the default password (using passwd command).

2. Setting a static IP address.

Edit network configuration file.

.. code-block:: shell-session

  sudo vim /etc/network/interfaces

Example: IP configuration file.

.. code-block:: shell-session

  # The loopback network interface
  auto lo
  iface lo inet loopback


  # The primary network interface
  auto eth0
  iface eth0 inet static
          address <Netris Controller IP/prefix length>
          gateway <Netris Controller default gateway>
          dns-nameserver <a DNS server address>

  source /etc/network/interfaces.d/* 

Reload the network config.

.. code-block:: shell-session

  sudo ifreload -a

.. note::
  
  Make sure Netris Controller has Internet access.
  
3. Reboot the controller

.. code-block:: shell-session

  sudo reboot
  
After reboot, the Netris Controller GUI should be accessible using a browser. Use ``netris/newNet0ps`` credentials. 

.. image:: images/credentials.png
   :align: center
   :class: with-shadow
   :alt: Netris Credentials

.. note::Don’t forget to change the default password by clicking your login name in the top right corner and then clicking “Change Password”.

Replacing the SSL certificate
=============================

1. Replace the below file with your SSL certificate file.

.. code-block:: shell-session

  /etc/nginx/ssl/controller.cert.pem;

2. Replace the below file with your SSL private key.

.. code-block:: shell-session

  /etc/nginx/ssl/controller.key.pem;

3. Restart Nginx service.

.. code-block:: shell-session

  systemctl restart nginx.service
