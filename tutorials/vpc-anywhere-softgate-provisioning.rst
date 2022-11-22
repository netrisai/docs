.. meta::
  :description: Netris SoftGate Installation

.. _softgate-installation-vpc_def:

****************************
Adding Netris SoftGate nodes
****************************
For SoftGate nodes you can start with two servers of the smallest flavor. In the future if you happen to need to upgrade to high-performance SoftGate PRO (with DPDK acceleration) you can upgrade the servers one-by-one.

1) Request two servers from Equinix Metal with Ubuntu 22.04 OS and wait until provisioned. After provisioning complete, you should see the newly created servers as **“Equinix Metal Server”** in Netris Controller listing, in **Net-->Inventory** section.

.. image:: /tutorials/images/softgate-nodes-created-in-equinix.png
    :align: center


2) Then in Equinix console click on each server name, then click **tag**, and add a tag **netris-softgate**. This tag will signal Netris Controller that these two servers are going to be used as Netris SoftGate nodes in this particular site (Project+Location).

 After tags are added, you should see in Netris web console that description changes from **Equinix Metal Server** to **Softgate Softgate1(2)**. You will also notice the IP addresses populated per SoftGate, and Heartbeat state as **CRIT**. We will bring Heartbeat to **OK** in next step.

3) Navigate to the **Net-->Inventory** section and click the **three vertical dots (⋮)** on the right side of the SoftGate node you are provisioning. Then click **Install Agent** and copy the one-line installer command to your clipboard.

.. image:: /images/softgate-install-agent.png
    :align: center

4) Paste the one-line install command on your SoftGate node as an ordinary user. (keep in mind that one-line installer commands are unique for each node)

.. image:: /images/softgate-provisioning-cli-output.png
    :align: center

.. note::
  Please note that the Netris installation script replaces the default Netplan networking backend with regular ifupdown and attempts to migrate the configuration set during installation to /etc/network/interfaces.

3) Handoff Netris the bond0 interface for further automatic operations. Netris will automatically create necessary subinterfaces under your bond0 interface. (bond0.<xyz>). But you need to manually configure which physical interfaces should bind under the bond0 interface. Netris will only make changes to your bond0 and loopback interfaces; all other interfaces will remain as described in /etc/network/interfaces.

.. code-block:: shell-session

  user@host:~$ sudo vim /etc/network/interfaces
  
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
      bond-slaves ens<X> ens<Y>
      # Optional, please adjust the bonding mode below according to the desired functionality. 
      bond-mode active-backup

  source /etc/network/interfaces.d/*

.. note:: 
  Ensure that the Management network interface IP address is as expected so the SoftGate node will maintain IP connectivity with Netris Controller after reboot.

4) Reboot the SoftGate

.. code-block:: shell-session

  user@host:~$ sudo reboot

Once the server boots up, you should see its heartbeat going from Critical to OK in **Net→Inventory**, **Telescope→Dashboard**, and the SoftGate color will reflect its health in **Net→Topology**.

.. image:: /tutorials/images/softgate-green.png
    :align: center