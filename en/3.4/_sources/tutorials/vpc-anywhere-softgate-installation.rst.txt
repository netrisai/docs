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


SoftGate software provisioning
==============================
The SoftGate deployment needs a freshly installed Ubuntu Linux 22.04 LTS.

.. note:: 
  Netris controller ships with two SoftGate nodes pre-defined in the Default site. (softgate1-default, softgate2-default). We recommend using these if you are new to Netris. Alternatively, you can learn how to define new SoftGate nodes here: :ref:`"Adding SoftGates"<topology-management-adding-softgates>`.

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
      # Please delete or comment out the line below if Netris Controller is located in the same network with the SoftGate node, otherwise adjust the line
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
      bond-slaves ens<X>
      # Optional, please adjust the bonding mode below according to the desired functionality. 
      bond-mode active-backup

  source /etc/network/interfaces.d/*

.. note:: 
  Ensure that the Management network interface IP address is as expected so the SoftGate node will maintain IP connectivity with Netris Controller after reboot.

4) Reboot the SoftGate

.. code-block:: shell-session

  sudo reboot

Once the server boots up, you should see its heartbeat going from Critical to OK in **Net→Inventory**, **Telescope→Dashboard**, and the SoftGate color will reflect its health in **Net→Topology**.

.. image:: images/vpc-anywhere-softgates-green.png
  :align: center
