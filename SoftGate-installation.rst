.. meta::
  :description: Netris SoftGate Installation

***************************
SoftGate Installation
***************************

Minimum Hardware Requirements
=============================
* 6 CPU cores
* 8 GB RAM
* 100 GB HDD

Install the Netris Agent 
========================
Requires freshly installed Ubuntu Linux 22.04 LTS and internet connectivity configured from netplan via management port

1. Add the SoftGate in the controller **Inventory**. Detailed configuration documentation is available here: :ref:`"Adding SoftGates"<topology-management-adding-softgates>`
2. Once the SoftGate is created in the **Inventory**, click on **three vertical dots (⋮)** on the right side on the SoftGate and select the **Install Agent** option
3. Copy the agent install command to your clipboard and run the command on the SoftGate
4. When the installation completes, review ifupdown configuration file (it was generated based on your netplan configuration)

.. code-block:: shell-session

  sudo vim /etc/network/interfaces 

5. If everything seems ok, remove/comment **Gateway** line and save the file.

.. note::
  
  If the Netris Controller is not in the same OOB network then it is required to add a route to Netris Controller. No default route or other IP addresses should be configured.

.. note::
  
  For proper operation of SoftGate, it is required to configure a bond interface. 

.. code-block:: shell-session

   # The loopback network interface
   auto lo
   iface lo inet loopback

   # The primary network interface
   auto eth0
   iface eth0 inet static
         address <Management IP address/prefix length>
         up ip ro add <Controller address> via <Management network gateway> #delete this line if Netris Controller is located in the same network with the SoftGate node.

  #
   auto bond0
   iface bond0 inet manual
         bond-slaves ensX ensY # Please replace the ensX/Y with actual interface names present in the OS.
         bond-mode active-backup # Optional, please adjust the bonding mode according to the desired functionality.

   source /etc/network/interfaces.d/*


1. Reboot the SoftGate

.. code-block:: shell-session

 sudo reboot

Once the server boots up you should see its heartbeat going from Critical to OK in Net→Inventory, Telescope→Dashboard, and SoftGate color will reflect its health in Net→Topology
