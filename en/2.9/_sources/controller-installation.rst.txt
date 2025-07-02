.. meta::
  :description: Netris Controller Virtual Machine Installation

**************************************
On-prem Netris Controller installation
**************************************
Netris Controller can be hosted in Netris cloud, installed locally as a VM, or deployed as a Kubernetes application. All three options provide the same functionality. Cloud-hosted Controller can be moved into on-prem anytime. 

KVM virtual machine
===================
| Minimal system requirements for the VM:
| CPU - 8 Core
| RAM - 16 Gb
| Disk - 100Gb
| Network - 1 virtual NIC

Installation steps for KVM hypervisor
=====================================
If KVM is not already installed, install Qemu/KVM on the host machine (example provided for Ubuntu Linux 18.04)

.. code-block:: shell-session

  sudo apt-get install virt-manager

Netris Controller Installation steps
====================================

1. Download the Netris Controller image. (contact Netris support for repository access permissions).

.. code-block:: shell-session

  cd /var/lib/libvirt/images 

  sudo wget http://img.netris.ai/netris-controller.qcow2 

2. Download vm definition file.

.. code-block:: shell-session

  cd /etc/libvirt/qemu

  sudo wget http://img.netris.ai/netris-controller.xml

3. Define the KVM virtual machine

.. code-block:: shell-session

  sudo virsh define netris-controller.xml

.. note::
  
  Netris controller virtual NIC will bind to the “br-mgmt” interface on the KVM host machine. See below network interface configuration exam

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

Below steps describe how to configure a **static IP** address for the Netris Controller.

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

Don’t forget to change the default password by clicking your login name in the top right corner and then clicking “Change Password”.

Security hardening
==================
| Recommended for production use.
| 

Changing the default GRPC authentication key.
---------------------------------------------

Connect to the Netris Controller CLI (SSH or Console)

Tip: You can generate a random and secure key using sha256sum.

.. code-block:: shell-session

  echo "<some random text here>" | sha256sum
  
example:

.. code-block:: shell-session

  netris@iris:~$ echo "<some random text here>" | sha256sum
  6a284d55148f81728f932b28e9d020736c8f78e1950b3d576f6e679d90516df1  -

Set your newly generated secure key into Netris Controller.

.. code-block:: shell-session

  sudo /opt/telescope/netris-set-auth.sh --key <your key>
  
Please store the auth key in a safe place as it will be required every time when installing Netris Agent for the switches and SoftGates.

Replacing the SSL certificate
------------------------------

1. Replace below file with your SSL certificate file.

.. code-block:: shell-session

  /etc/nginx/ssl/controller.cert.pem;

2. Replace below file with your SSL private key.

.. code-block:: shell-session

  /etc/nginx/ssl/controller.key.pem;

3. Restart Nginx service.

.. code-block:: shell-session

  systemctl restart nginx.service
