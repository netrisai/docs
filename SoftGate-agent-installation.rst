.. meta::
  :description: Netris SoftGate Agent Installation

***********************************
Netris SoftGate agent installation
***********************************
Minimal hardware requirements
=============================
* 2 x Intel Silver CPU
* 96 GB RAM
* 300 GB HDD
* Nvidia Mellanox Connect-X 5 SmartNIC card

BIOS configuration
==================
The following are some recommendations on BIOS settings. Different vendors will have different BIOS naming so the following is mainly for reference:

* Before starting consider resetting all BIOS settings to their defaults.
* Disable all power saving options such as: Power performance tuning, CPU P-State, CPU C3 Report and CPU C6 Report.
* Select Performance as the CPU Power and Performance policy.
* Disable Turbo Boost to ensure the performance scaling increases with the number of cores.
* Set memory frequency to the highest available number, NOT auto.
* Disable all virtualization options when you test the physical function of the NIC, and turn off VT-d.
* Disable Hyper-Threading.

Software installation
=====================
Requires freshly installed Ubuntu Linux 18.04 and network connectivity with your Netris Controller over the out-of-band management network.

1. Set environment variables to use Netris Controller as a proxy.

.. code-block:: shell-session

  export http_proxy=http://<Your Netris Controller address>:3128 && export https_proxy=http://<Your Netris Controller address>:3128

  echo -e 'Acquire::http::Proxy "http://<Your Netris Controller address>:3128";\nAcquire::https::Proxy "http://<Your Netris Controller address>:3128";' | sudo tee -a /etc/apt/apt.conf.d/netris-proxy

2. Config the apt for Mellanox repository.

.. code-block:: shell-session

  wget -qO - https://www.mellanox.com/downloads/ofed/RPM-GPG-KEY-Mellanox | sudo apt-key add -

  wget http://linux.mellanox.com/public/repo/mlnx_ofed/5.0-2.1.8.0/ubuntu18.04/mellanox_mlnx_ofed.list -O /tmp/mellanox_mlnx_ofed.list && sudo mv /tmp/mellanox_mlnx_ofed.list /etc/apt/sources.list.d/

3. Config the apt for Netris repository. 

.. code-block:: shell-session

  wget -qO - http://repo.netris.ai/repo/public.key | sudo apt-key add -
  
  echo "deb http://repo.netris.ai/repo/ bionic main" | sudo tee /etc/apt/sources.list.d/netris.list

4. Install Mellanox drivers

.. code-block:: shell-session

  sudo apt-get update && sudo apt-get install mlnx-ofed-dpdk

5. Install Netris agent package and dependencies, including specific Linux Kernel version.

.. code-block:: shell-session

  sudo apt-get install netris-dpdk-mlnx

6. Configure Management IP address

Configure out of band management IP address. In case Netris Controller is not in the same OOB network then add a route to Netris Controller. No default route or other IP addresses should be configured. 

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
         up ip ro add <Controller address> via <Management network gateway> #delete this line if Netris Controller is located in the same network with the SoftGate node.

  source /etc/network/interfaces.d/*

.. code-block:: shell-session

  sudo ifreload -a

7. Initialize the SoftGate

|  netris-setup parameters, described below.

| **--auth** - Authentication key, “6878C6DD88224981967F67EE2A73F092” is the default value, we strongly recommend to change this string in your controller as described in Controller initial configuration section.
| **--controller** - IP address or domain name of Netris Controller. 
| **--hostname** - Specify the hostname for the current switch, this hostname should match the name defined for particular switch in the Controller..
| **--lo** - IP address for the loopback interface, as it is defined in the controller.
| **--node-prio - brief explanation of node priority goes here**
|
| Run netris-setup.

.. code-block:: shell-session

  sudo /opt/netris/bin/netris-setup --lo=<SoftGate loopback IP address as defined in controller>  --controller=<Netris Controller IP or FQDN> --hostname=<node name as defined in controller> --auth=<authentication key> --node-prio=<node priority 1/2>  

Example: Running netris-setup

.. code-block:: shell-session

  netris@ubuntu:~$ sudo /opt/netris/bin/netris-setup --lo=10.254.97.33  --controller=10.254.97.10 --hostname=softgate1 --auth=6a284d55148f81728f932b28e9d020736c8f78e1950b3d576f6e679d90516df1 --node-prio=1
  * Setup Hostname
  * Setup Hosts
  * Setup Keepalived
  * Setup Collectd
  * Setup Loopback
  * Get CPU List
  * Setup FRR BGP Daemon
  * Setup Netris Agent Config
  * Setup DPDK Router Config
  * Setup DPDK Router Systemd Unit
  └── └── * Setup Grub Config
  * Update Grub
  └── 

| *** ATTENTION: You must reboot SoftGate to complete the installation 
| netris@ubuntu:~$ 
|

8. Reboot the server

.. code-block:: shell-session

  sudo reboot

When server boots up, you should see it’s heartbeat status in Net→Inventory


