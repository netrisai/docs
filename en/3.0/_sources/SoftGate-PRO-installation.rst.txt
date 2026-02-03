.. meta::
  :description: Netris SoftGate PRO Installation

***************************
SoftGate PRO Installation
***************************

Minimum Hardware Requirements
=============================
* 2 x Intel® Xeon® Silver Processor with 10 physical cores per socket (20 cores total)
* 128 GB (64 GB RAM per socket) in multichannel configuration
* 300 GB HDD
* Nvidia Mellanox Connect-X 5/6 SmartNIC card

BIOS Configuration
==================
The following are some recommendations for BIOS settings. Different vendors will have different BIOS naming so the following is mainly for reference:

* Before starting consider resetting all BIOS settings to their defaults
* Disable all power saving options such as: Power performance tuning, CPU P-State, CPU C3 Report and CPU C6 Report
* Select Performance as the CPU Power and Performance policy
* Enable Turbo Boost
* Set memory frequency to the highest available number, NOT auto
* Disable all virtualization options when you test the physical function of the NIC, and turn off VT-d
* Disable Hyper-Threading

Install the Netris Agent 
========================
Requires freshly installed Ubuntu Linux 18.04 LTS and internet connectivity configured from netplan via management port.

1. Add the SoftGate in the controller **Inventory** or **Topology** section. Detailed configuration documentation is available here: :ref:`"Adding SoftGates"<topology-management-adding-softgates>`.
2. Once the SoftGate is created, navigate to the **Inventory** section, click the **three vertical dots (⋮)** on the right side of the newly created SoftGate and select the **Install Agent** option.
3. Copy the agent install line to your clipboard and run it on the SoftGate as an ordinary user.
4. When the installation is complete, review the ifupdown configuration file and verify that the presented configuration corresponds to what you configured during OS installation (the file is generated based on your initial netplan configuration).

.. note::
  
  If the Netris Controller is not in the same OOB network then add a route to Netris Controller. No default route or other IP addresses should be configured.

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
      up ip route add <Controller address> via <Management network gateway> # Please delete this line if Netris Controller is located in the same network with the SoftGate node.
      gateway <Gateway IP address>

   source /etc/network/interfaces.d/*

5. If everything seems ok, please remove/comment the **Gateway** line and save the file.

.. note::

  Please do not configure any additional IP addresses other than those described in the example above. The further configuration will be performed by the Netris agent.

6. Reboot the SoftGate

.. code-block:: shell-session

  user@host:~$ sudo reboot

Once the server boots up you should see its heartbeat going from Critical to OK in **Net→Inventory**, **Telescope→Dashboard**, and the SoftGate color will reflect its health in **Net→Topology**.
