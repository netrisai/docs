.. meta::
  :description: Netris SoftGate Agent Installation

***************************
SoftGate Agent Installation
***************************

Minimum Hardware Requirements
=============================
* 2 x Intel Silver CPU
* 96 GB RAM
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
Requires freshly installed Ubuntu Linux 18.04 and internet connectivity configured from netplan via management port

1. Add the SoftGate in the controller **Inventory**. Detailed configuration documentation is available here: :ref:`"Adding SoftGates"<topology-management-adding-softgates>`
2. Once the SoftGate is created in the **Inventory**, click on **three vertical dots (⋮)** on the right side on the SoftGate and select the **Install Agent** option
3. Copy the agent install command to your clipboard and run the command on the SoftGate
4. When the installation completes, review ifupdown configuration file (it was generated based on your netplan configuration)

.. code-block:: shell-session

  sudo vim /etc/network/interfaces 

5. If everything seems ok, remove/comment **Gateway** line and save the file.

.. note::
  
  If the Netris Controller is not in the same OOB network then add a route to Netris Controller. No default route or other IP addresses should be configured.

.. code-block:: shell-session

   # The loopback network interface
   auto lo
   iface lo inet loopback

   # The primary network interface
   auto eth0
   iface eth0 inet static
         address <Management IP address/prefix length>
         up ip ro add <Controller address> via <Management network gateway> #delete this line if Netris Controller is located in the same network with the SoftGate node.

   source /etc/network/interfaces.d/*


6. Reboot the SoftGate

.. code-block:: shell-session

 sudo reboot

Once the server boots up you should see its heartbeat going from Critical to OK in Net→Inventory, Telescope→Dashboard, and SoftGate color will reflect its health in Net→Topology
