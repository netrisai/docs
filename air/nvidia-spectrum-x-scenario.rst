======================================================================
Lab Scenario: GPU-as-a-Service network with NVIDIA Spectrum-X architecture
======================================================================

Initialize the Netris controller
================================

Start with a blank Netris Controller. SSH to the Netris controller server and ``cd /home/ubuntu/netris-init/netris-spectrum-x-init``.

Optionally Edit ``terraform.tfvars`` file to set cluster scale parameters.

Below, we describe the role of a few parameters that directly define the scale. The description of the rest of the parameters is available in the ``terraform.tfvars`` file itself. For the purpose of this try & learn scenario, there is no need to change the other parameters.

The **east-west** switch fabric is responsible for high performance data transmission between GPU servers. It rail-optimized design allows to non-blocking max-rate data transmission between any GPUs on the network. You only need to define the number of GPU servers in the ``terraform.tfvars`` file. When you execute the initialization module, it will automatically calculate the proper number of links and will generate the rail-optimized blueprint in the Netris controller according to the NVIDIA Spectrum-X guidelines.

* Define ``gpu-server-count`` using increments of 32 (1 SU = 32 servers, 2 SUs = 64 servers, etc.)

The **north-south** switch fabric is responsible for everything else - for connectivity from the outside, to manage the GPU nodes and run workloads. OOB management switches are responsible for out-of-band management of the network switches and GPU servers. OOB management is also used in production for PXE booting the GPU servers. In this simulation scenario, GPU servers will be booted by means of the Netris infrastructure simulation platform for your conveninece of teasting and learning.

* Define ``leaf-count`` - the rule of thumb is that at least 1/4th of the number of SUs - so 4 leaf switches can handle up to 4 SUs
* Define ``oob-leaf-count`` - Should be equal to the number of SUs.
* Define ``spine-count`` - Typically 2, although other values are welcome.

Save the changes and exit.

Execute ``tofu-apply`` or ``tofu-destroy`` to insert/clean up relevant declarations into the Netris controller.

Navigate to the Netris controller in your web browser to see the results.

Start a simulation
==================

Check ``Inventory``, ``IPAM``, and ``Topology`` sections under ``Network`` menu in the Netris controller web console. (In the topology section, you may need to select the right site to see a diagram)

Go back to the SSH session and cd to ``/home/ubuntu/netris-air``

Execute pulumi up or pulumi destroy to start/stop a simulation of what’s described in the Netris Controller.

Monitoring Dashboard
====================

Once simulation creation is done, go back to the Netris web console and wait up to 5 minutes for the infrastructure to come up. You can monitor the status of the network either from the dashboard (click on the Netris icon in the top left corner) or from the Topology section.

Click on ``Agent Heartbeats`` donut to see its detailed view on the right. Agent Heartbeats section shows whether Netris agent heartbeat is being received from each Netris-managed host.

Once heartbeats are received, automatic configuration will start, as well as automatic monitoring. Netris automatic monitoring provides information about the health of your network, such as Interface up/down status, BGP status, Topology/Wiring errors, RAM/CPU/PSU/Fan status, and else. 

Click on the ``Managed HW Health`` donut to see monitoring check statuses for each Netris-managed node on the right side.

Topology
========

The group of spine and leaf switches at the top part is the east-west network (backend network). The group of spine and leaf switches in the bottom is the north-south network (Tennant Access Network). GPU servers are located in the middle between two switch fabrics. If you zoom in, you can see that eth ports 1-8 of each GPU server are connected to the east-west fabric through rail-optimized design - that's where high-performance computing traffic runs. Interfaces 9-10 are connected to the leaf switches of north-south fabric, later you will see that interfaces 9 & 10 will be bonded from the GPU server side - that's where production traffic, storage traffic, dataset management, and workload management traffic runs. Finally, interface 11 is connected to the OOB (out of band) management switch. OOB interfaces are used for PXE booting the GPU nodes. (in the current simulation there's no PXE booting - the VMs that simulate GPU servers just come alive from an image)

``Network->Topology`` The main purpose of the topology section is to define the topology. In this scenario, the topology has been defined by means of the initialization module. However, manual changes can still be done through the web console. 

When deploying with physical hardware, the procedure would be to wire the switches and servers according to the topology diagram in Netris. During that process, the MAC address of each physical switch should be entered into the Netris controller through Topology, by editing every switch node (only for switches) and entering the actual MAC address. These MAC addresses will be required for binding the physical switches to logical switches in the Netris controller.

When running a simulation, like in this scenario there's no need to enter any MAC addresses. The simulation platform will take care of everything.

The Topology section also reflects some monitoring information. Links change their color based on link status and utilization. You can zoom in/out and then right-click on any link to check its details to see traffic statistics and any relevant healthcheck info. Switch and SoftGate nodes show numbers on a red/yellow/green background reflecting the quantity of critical/warning/ok checks per each node.

Once your newly created simulation is converged, you will see only 1 check in critical state on every switch - that's the time synchronization, which takes up to 10 minutes to go green. 

SSH to Switches
===============

During regular operation, there's no need to SSH to any switches because configuration and management is fully automated by Netris software. 

There are rare cases when the administrator needs to SSH to a switch. To do so, Find the switch management IP from Topology or Inventory sections in the Netris web console. SSH from the Netris Controller to the management IP of the switch using 'cumulus' username. No password is needed when working with the simulation.

Example:


.. code-block:: shell-session

 ubuntu@test-ctl:~/netris-air$ ssh cumulus@10.7.0.4
 Debian GNU/Linux 12
 Linux leaf-pod00-su0-r3 6.1.0-cl-1-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.38-4+cl5.9.1u6 (2024-05-13) x86_64
 Last login: Thu Sep 12 16:21:35 2024 from 10.8.0.2
 cumulus@leaf-pod00-su0-r3:mgmt:~$ 



SSH to GPU servers
==================

GPU servers are connected to the east-west and north-south fabrics. At this point of the lab scenario, we haven't created any VPC/V-Net/VLAN services to instruct the fabric to provide connectivity to any interfaces of any GPU nodes. However, for the purpose of learning and experimenting, the simulation platform has an additional management network that allows you to connect to GPU servers anytime. 

Please SSH from the Netris controller server to a few GPU servers using 'root' username and IP addresses starting 192.168.16.2. ( 192.168.16.2 is host 0 in SU0, 192.168.16.3 is host 1 in SU0, etc.) 

Example:

.. code-block:: shell-session

  ubuntu@test-ctl:~$ ssh root@192.168.16.2
  Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 5.15.0-119-generic x86_64)
  
   * Documentation:  https://help.ubuntu.com
   * Management:     https://landscape.canonical.com
   * Support:        https://ubuntu.com/pro
  
   System information as of Fri Sep 13 01:34:28 UTC 2024
  
    System load:  0.13              Processes:             95
    Usage of /:   29.2% of 5.64GB   Users logged in:       0
    Memory usage: 22%               IPv4 address for ens4: 192.168.16.2
    Swap usage:   0%
  
  
  Expanded Security Maintenance for Applications is not enabled.
  
  39 updates can be applied immediately.
  12 of these updates are standard security updates.
  To see these additional updates run: apt list --upgradable
  
  Enable ESM Apps to receive additional future security updates.
  See https://ubuntu.com/esm or run: sudo pro status
  
  New release '24.04.1 LTS' available.
  Run 'do-release-upgrade' to upgrade to it.
  
  
  Last login: Thu Sep 12 23:20:36 2024 from 10.8.0.2
  root@hgx-pod00-su0-h00:~# 


On the GPU host, you'll find `./cluster-ping.sh`, which is a bash script that helps you execute parallel pings across every east-west and north-south interface towards any GPU node. The script knows the IP addressing scheme used in this scenario, and it only needs the SU number and host number.

In the below example, the host pings itself. So, local interface IPs are responding, while the default gateways are not. If you ping another host, you'll get timeouts on all interfaces. 

.. code-block:: shell-session

  root@hgx-pod00-su0-h00:~# ./cluster-ping.sh 0 0
  Usage: ./cluster-ping.sh <SU> <Host>
  
  Ping from hgx-pod00-su0-h00 to SU:0 host:0
  
  ------ East-West Fabric ------
  ping rail0 (172.0.0.0)    : OK
  ping rail1 (172.32.0.0)   : OK
  ping rail2 (172.64.0.0)   : OK
  ping rail3 (172.96.0.0)   : OK
  ping rail4 (172.128.0.0)  : OK
  ping rail5 (172.160.0.0)  : OK
  ping rail6 (172.192.0.0)  : OK
  ping rail7 (172.224.0.0)  : OK
  
  ------ North-South Fabric ------
  ping bond0  (192.168.0.1)  : OK
  ping default GW (192.168.7.254)  : Timeout
  
  ------ IPMI/BMC ------
  ping eth11 (192.168.8.1)  : OK
  ping default GW (192.168.15.254)  : Timeout
  
  
  root@hgx-pod00-su0-h00:~# 
