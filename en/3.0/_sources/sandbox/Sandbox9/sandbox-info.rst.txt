*************************
Welcome to Netris Sandbox
*************************

Netris Sandbox is a ready-to-use environment for testing Netris automatic NetOps. 
We have pre-created some example services for you, details of which can be found in the :ref:`"Provided Example Configurations"<s9-pre-configured>` document. Feel free to view, edit, delete, and create new services. Reach out to us if you have any questions at https://netris.ai/slack 

The credentials for the sandbox have been provided to you by email in response to your sandbox request.

This environment includes:


* :ref:`Netris Controller<netris_controller_def>`: A cloud-hosted Netris controller, loaded with examples.
* :ref:`Switching fabric<netris_sw_agent>`: Two spine switches and four leaf switches, all Netris-operated.
* :ref:`SoftGates<netris_sg_agent>`: Two SoftGate gateway nodes for border routing, L4 Load Balancing, site-to-site VPN, and NAT. Both Netris-operated.
* **Linux servers**: Five Linux servers, with root access where you can run any applications for your tests.
* **Kubernetes cluster**: A 3 node Kubernetes cluster, user integratable with Netris controller, feel free to deploy any applications for your tests.
* **ISP**: Internet upstream with IRIS ISP, providing the sandbox Internet connectivity with real-world routable public IP addresses.

.. _s9-topology:
Topology diagram
================

.. image:: /images/sandbox_topology.png
    :align: center
    :alt: Sandbox Topology
    :target: ../../_images/sandbox_topology.png



Netris Controller
==========
https://sandbox9.netris.ai

Linux servers
=============

Example pre-configured Netris services:
 * **srv01-nyc**, **srv02-nyc**, **srv03-nyc** & **Netris Controller** - are consuming :ref:`"ROH (Routing on the Host)"<roh_def>` Netris example service, see **Services → ROH.**
 * **srv01-nyc**, **srv02-nyc** - are behind :ref:`"Anycast L3 load balancer"<l3lb_def>`, see **Services → Load Balancer**.
 * **srv04-nyc**, **srv05-nyc** - are consuming :ref:`"V-NET (routed VXLAN)"<v-net_def>` Netris service, see **Services → V-NET**.


Accessing Linux servers:
  
.. code-block:: shell-session  
  
  srv01-nyc: ssh demo@166.88.17.22 -p 30061
  srv02-nyc: ssh demo@166.88.17.22 -p 30062
  srv03-nyc: ssh demo@166.88.17.22 -p 30063
  srv04-nyc: ssh demo@166.88.17.22 -p 30064
  srv05-nyc: ssh demo@166.88.17.22 -p 30065
  

Kubernetes cluster
==================
This sandbox provides an up and running 3 node Kubernetes cluster. You can integrate it with the Netris controller by installing **netris-operator**. Step-by-step instructions are included in the :ref:`"Learn Netris operations with Kubernetes"<s9-k8s>` document.


Upstream ISP
============
This sandbox provides an upstream ISP service with real-world Internet routing configured through :ref:`"BGP"<bgp_def>`. 
There are two pre-configured examples under **NET → E-BGP** , one using IPv4 and the other using IPv6, which are advertising the public IP subnets belonging to the sandbox to the upstream ISP IRIS.

ISP settings:

.. code-block:: shell-session
 
 (pre-configured examples)
 Name:                           iris-isp1-ipv4-example
 BGP Router:                     Softage1
 Switch Port:                    swp16@sw01-nyc
 Neighbor AS:                    65007
 VLAN ID:                        1091
 Local Address:                  50.117.59.114/30
 Remote Address:                 50.117.59.113/30
 Prefix List Inbound:            permit 0.0.0.0/0
 Prefix List Outbound:           permit 50.117.59.192/28 le 32
 
 Name:                           iris-isp1-ipv6-example
 BGP Router:                     Softage1
 Switch Port:                    swp16@sw01-nyc
 Neighbor AS:                    65007
 VLAN ID:                        1091
 Local Address:                  2607:f358:11:ffc0::13/127
 Remote Address:                 2607:f358:11:ffc0::12/127
 Prefix List Inbound:            permit ::/0
 Prefix List Outbound:           permit 2607:f358:11:ffc9::/64
 
 (configurable by you)
 BGP Router:                     Softage2
 Switch Port:                    swp16@sw02-nyc
 Neighbor AS:                    65007
 VLAN ID:                        1092
 Local Address:                  50.117.59.118/30
 Remote Address:                 50.117.59.117/30 
 Prefix List Inbound:            permit 0.0.0.0/0
 Prefix List Outbound:           permit 50.117.59.192/28 le 32


Networks Used 
=============
Allocations and subnets defined under :ref:`"IPAM"<ipam_def>`, see **Net → IPAM**.

.. code-block:: shell-session

  | MANAGEMENT Allocation:       10.254.45.0/24 
  |___ MANAGEMENT Subnet:        10.254.45.0/24

  | LOOPBACK Allocation:         10.254.46.0/24
  |___ LOOPBACK Subnet:          10.254.46.0/24

  | ROH Allocation:              192.168.44.0/24
  |___ ROH Subnet:               192.168.44.0/24

  | EXAMPLE Allocation:          192.168.45.0/24
  |___ EXAMPLE Subnet:           192.168.45.0/24

  | CUSTOMER Allocation:         192.168.46.0/24
  |___ CUSTOMER Subnet:          192.168.46.0/24

  | K8s Allocation:              192.168.110.0/24
  |___ K8s Subnet:               192.168.110.0/24

  | PUBLIC IPv4 Allocation:      50.117.59.192/28
  |___ PUBLIC LOOPBACK Subnet:   50.117.59.192/30
  |___ NAT Subnet:               50.117.59.196/30
  |___ L3 LOAD BALANCER Subnet:  50.117.59.200/30
  |___ L4 LOAD BALANCER Subnet:  50.117.59.204/30

  | EXAMPLE IPv6 Allocation:     2607:f358:11:ffc9::/64
  |___ EXAMPLE IPv6 Subnet:      2607:f358:11:ffc9::/64
  
