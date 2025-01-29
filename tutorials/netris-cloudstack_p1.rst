.. meta::
  :description: Netris-CloudStack Integration

High-Level Concept of Integration
=================================


The integration of Netris with Apache CloudStack provides a robust and scalable networking solution, addressing the limitations of traditional switch fabrics and enhancing the network capabilities of CloudStack.

How It Works
------------

* Hypervisors as VTEPs: Hypervisors terminate VXLAN tunnels, acting as Virtual Tunnel Endpoints (VTEPs).
* BGP EVPN Signaling: Netris uses BGP EVPN to exchange MAC and IP address information, creating a dynamic and scalable control plane for VXLAN.
* Integration Points:

  * The CloudStack Controller communicates with the Netris Controller API to exchange network configuration and metadata.
  * VXLAN fabrics are extended between CloudStack and physical switch networks using BGP/EVPN.


Challenges Addressed
--------------------

* Overcomes the VLAN limitation of 4096 IDs by leveraging VXLAN, supporting millions of isolated VPCs.
* Eliminates the “island” effect of CloudStack’s multicast-based VXLAN by integrating with the physical switch fabric.
* Replaces CloudStack’s virtual router with Netris SoftGate, offering scalable NAT, load balancing, and traffic control.


Benefits
--------

* Scalability: Support for millions of VPCs with overlapping IPs.
* AWS-Like Services: Enables Direct Connect functionality and scalable load balancing.
* Automation: Simplifies network operations with centralized control via the Netris Controller.
* Cost-Efficiency: Uses multi-vendor hardware and commodity servers, reducing infrastructure costs.

Use Cases
---------

* Large-scale Apache CloudStack Providers needing a scalable alternative to VLANs.
* Enterprises transforming their traditional data centers into private cloud environments.
* Hosting providers seeking AWS-like network functionality for their customers.

	[todo][Insert Diagram 1: High-level overview of Netris-CloudStack integration]
	[todo][Insert Diagram 2: BGP EVPN signaling between CloudStack hypervisors and physical switches]


Compute and Network Architecture
================================

The current infrastructure for Netris-CloudStack integration is designed to support scalable and dynamic networking for cloud workloads. Below is a breakdown of the key components and their roles:

Diagram Overview
----------------

The diagram illustrates the interconnected infrastructure, consisting of:

1. Leaf and Spine Switches:

  * These form the core networking layer, enabling high-speed and fault-tolerant connections.
  * Spine switches (Spine 1 and Spine 2) aggregate traffic and connect to the leaf switches.
  * Leaf switches (Leaf 1 and Leaf 2) connect directly to the compute nodes and softgates, ensuring efficient traffic distribution and handling VXLAN traffic.

2. Softgates:

  * Softgates play a critical role in integrating physical and virtual network environments. They are responsible for:
  
    * NAT Function: Enabling secure communication between private and external networks.
    * Elastic Load Balancer: Distributing traffic across multiple resources for high availability and scalability.
    * Network Access Control: Enforcing access policies for secure communication.
  
  * Additionally, they bridge VXLAN and traditional networks and support BGP/EVPN-based signaling for dynamic routing.

3. Servers:

  * Server 1: Designated as the CloudStack Management Node, responsible for orchestrating the environment.
  * Server 2, Server 3, and Server 4: These are KVM hypervisors managed by CloudStack, functioning as VTEPs for VXLAN tunnels.

4. OOB (Out-of-Band) Switch:

  * An Out-of-Band (OOB) switch connects all servers for administrative purposes.
  * This switch allows administrators to:
  * Access servers during emergencies.
  * Install software packages and perform updates.
  * Troubleshoot and manage servers independently of the main network.

5. Internet eBGP:

  * Leaf switches are connected to external networks via eBGP, ensuring reachability for public and private traffic.


Network Flow
------------
#. Traffic flows between hypervisors (VTEPs) over VXLAN tunnels. These tunnels are dynamically configured using BGP/EVPN signaling.
#. Softgates handle routing between overlay and underlay networks, ensuring seamless communication for workloads.
#. The CloudStack Controller communicates with the Netris Controller API to coordinate network configurations.
#. Leaf and spine switches provide a robust and scalable fabric to support high availability and performance.
#. The OOB switch provides an independent path for server management, ensuring operational reliability.
