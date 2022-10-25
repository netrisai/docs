.. meta::
  :description: Netris SoftGate Installation

.. _softgate-installation-vpc_def:

***************************
SoftGate Installation
***************************

Minimum Hardware Requirements
=============================
* 8 CPU cores
* 16 GB RAM
* 300 GB HDD

OS requirements for Netris SoftGate installation   
================================================
The SoftGate deployment needs a freshly installed Ubuntu Linux 22.04 LTS.
During the installation process please consider the following:

1) The management interface must be defined with a valid IP address from **Management IP Address** field (mng). This IP address must have internet access.
2) Most of the settings can be left with default values. For your convenience OpenSSH server should be enabled.
3) The hostname doesn't matter, the installer will set the hostname to the name defined in the controller.
4) Do not set the loopback address as it will be set by the Netris Agent.
5) After the OS installer finishes reboot is necessary. After the first boot it is recommended to remove unnecessary packages by performing:
   
.. code-block:: shell-session

  sudo apt purge -y cloud-init snapd open-iscsi modemmanager multipath-tools

Then perform cleanup of remaining orphaned packages:

.. code-block:: shell-session

  sudo apt autoremove -y

6) Finally please update the operating system to include the latest security updates.

.. code-block:: shell-session

  sudo apt update
  sudo apt upgrade -y

.. note:: Netris controller ships with two SoftGate nodes pre-defined in the Default site. (softgate1-default, softgate2-default). We recommend using settings from these if you are new to Netris. Alternatively, you can learn how to define new SoftGate nodes here: :ref:`"Adding SoftGates"<topology-management-adding-softgates>`.

Provision Netris SoftGate software
==================================
1) Navigate to the **Net-->Inventory** section and click the **three vertical dots (⋮)** on the right side of the SoftGate node you are provisioning. Then click **Install Agent** and copy the one-line installer command to your clipboard.

.. image:: /images/softgate-install-agent.png
    :align: center

2) Paste the one-line install command on your SoftGate node as an ordinary user. (keep in mind that one-line installer commands are unique for each node)

.. image:: /images/softgate-provisioning-cli-output.png
    :align: center

.. note::
  Please note that the Netris installation script replaces the default Netplan networking backend with regular ifupdown and attempts to migrate the configuration set during installation to /etc/network/interfaces.

3) Handoff Netris the bond0 interface for further automatic operations. Netris will automatically create necessary subinterfaces under your bond0 interface. (bond0.<xyz>). But you need to manually configure which physical interfaces should bind under the bond0 interface. Netris will only make changes to your bond0 and loopback interfaces; all other interfaces will remain as described in /etc/network/interfaces.

.. code-block:: shell-session

  sudo vim /etc/network/interfaces
  
.. code-block:: shell-session

  # The loopback network interface
  auto lo
  iface lo inet loopback

  # The management network interface
  auto ensZ
  iface ensZ inet static
      address <Management IP address/prefix length>
      # Please delete or comment the line below if Netris Controller is located in the same network with the SoftGate node, otherwise adjust the line
      # according to your setup. 
      up ip route add <Controller IP address> via <Management network gateway> 

  # Physical port on SoftGate node connected to a TRUNK port of your network
  auto ens<X> 
  iface ens<x> inet static 
      address 0.0.0.0/0
      
  # Optionally you can add more physical interfaces under your bond0, uncomment as needed
  #auto ens<Y>
  #iface ens<Y> inet static 
  #    address 0.0.0.0/0

  # Bond interface 
  auto bond0
  iface bond0 inet static
      address 0.0.0.0/0
      # Please replace/remove the ensX/Y with actual interface name(s) below to one(s) present in the OS.
      bond-slaves ens<X> ens<Y>
      # Optional, please adjust the bonding mode below according to the desired functionality. 
      bond-mode active-backup

  source /etc/network/interfaces.d/*


4) Reboot the SoftGate

.. code-block:: shell-session

  sudo reboot

Once the server boots up, you should see its heartbeat going from Critical to OK in **Net→Inventory**, **Telescope→Dashboard**, and the SoftGate color will reflect its health in **Net→Topology**.
