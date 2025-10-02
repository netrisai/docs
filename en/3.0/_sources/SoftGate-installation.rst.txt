.. meta::
  :description: Netris SoftGate Installation

***************************
SoftGate Installation
***************************

Minimum Hardware Requirements
=============================
* 8 physical CPU cores
* 16 GB RAM
* 300 GB HDD

Install the Netris Agent 
========================
Requires freshly installed Ubuntu Linux 22.04 LTS and internet connectivity configured from netplan via management port.

1. Add the SoftGate in the controller **Inventory** or **Topology** section. Detailed configuration documentation is available here: :ref:`"Adding SoftGates"<topology-management-adding-softgates>`.
2. Once the SoftGate is created, navigate to the **Inventory** section, click the **three vertical dots (⋮)** on the right side of the newly created SoftGate and select the **Install Agent** option.
3. Copy the agent install line to your clipboard and run it on the SoftGate as an ordinary user.
4. When the installation is complete, review the ifupdown configuration file and verify that the presented configuration corresponds to what you configured during OS installation (the file is generated based on your initial netplan configuration).

.. note::
  
  If the Netris Controller is not in the same OOB network then it is required to add a route to Netris Controller. No default route or other IP addresses should be configured.

.. note::
  
  For proper operation of SoftGate, it is required to configure a bond interface. Please have a look at the example configuration below.

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
      up ip route add <Controller address> via <Management network gateway> # Pleasedelete this line if Netris Controller is located in the same network with the SoftGate node.
      gateway <Gateway IP address>

  # First Softgate Interface
  auto ensX # Please replace the ensX with the actual interface name present in the OS.
  iface ensX inet static # Please replace the ensX with the actual interface name present in the OS.
      address 0.0.0.0/0
   
  # Second Softgate Interface # This interface is optional
  auto ensY # Please replace the ensY with the actual interface name present in the OS.
  iface ensY inet static # Please replace the ensY with the actual interface name present in the OS.
      address 0.0.0.0/0

  # Bond interface 
  auto bond0
  iface bond0 inet static
      address 0.0.0.0/0
      bond-slaves ensX ensY # Please replace the ensX/Y with actual interface names present in the OS.
      bond-mode active-backup # Optional, please adjust the bonding mode according to the desired functionality.

  source /etc/network/interfaces.d/*

5. If everything seems ok, please remove/comment the **Gateway** line and save the file.

.. note::

  Please do not configure any additional IP addresses other than those described in the example above. The further configuration will be performed by the Netris agent.

6. Reboot the SoftGate

.. code-block:: shell-session

  user@host:~$ sudo reboot

Once the server boots up, you should see its heartbeat going from Critical to OK in **Net→Inventory**, **Telescope→Dashboard**, and the SoftGate color will reflect its health in **Net→Topology**.
