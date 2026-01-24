.. meta::
     :description: SoftGate HS (HyperScale) Architecture and Deployment

==============
SoftGate HS
==============

.. contents:: Table of Contents
     :depth: 3
     :local:

Overview
============

In multi-tenant environments, tenants typically require controlled ingress and egress connectivity to their VPCs. For example, the workload access to and from the Internet.

SoftGate is an optional, multi-tenant (VPC-aware) software component designed for cloud providers and scales horizontally to provide this ingress and egress connectivity. The SoftGate software runs on a dedicated set of operator-provided bare-metal servers and is tightly integrated with the Netris-managed North-South fabric.

Services Provided by SoftGate
--------------------------------------------

SoftGate provides the following network services on a per-tenant basis:
* Source Network Address Translation (SNAT)

  Enables tenant workloads to initiate outbound connections to external networks while preserving tenant isolation.

* Destination Network Address Translation (DNAT)

  Enables inbound connections from external networks to reach tenant workloads. DNAT includes inbound port forwarding and 1:1 NAT, where traffic on all ports is forwarded unconditionally. The latter is functionally equivalent to an ElasticIP in AWS.

* Layer-4 Load Balancing (L4LB)

  Distributes inbound traffic across multiple backend endpoints within a tenant's VPC. L4LB service includes support for backend health checks.

* DHCP Server

  Provides IP address assignment for workloads connected to tenant networks. You can learn more about configuring the Netris DHCP service in the :ref:`DHCP section<vnet_dhcp>` of the Netris documentation.

What SoftGate does not do
-----------------------------

SoftGate is intentionally scoped to provide Layer-4 ingress and egress services and does not provide the following capabilities:

* Next-generation firewall (NGFW) functionality

  SoftGate does not perform deep packet inspection, application-aware firewalling, or advanced security policy enforcement.

* Application-layer load balancing

  SoftGate provides Layer-4 load balancing only and does not offer TLS, Layer-7, or application-aware load balancing capabilities.

Hardware Requirements
------------------------------

A minimum of 4 dedicated servers are required for an HA (highly available) active-active SoftGate HS cluster. Two SoftGates will forward stateful traffic (SNAT), and two others will forward the stateless traffic (DNAT, 1:1 NAT, Layer-4 Load Balancing, etc.) Each group (stateful and stateless) can be scaled horizontally by deploying more servers as CPU & RAM utilization necessitates.

.. csv-table:: SoftGate HS Hardware Requirements
     :file: tables/softgate-hs-hardware.csv
     :widths: 30, 30, 30
     :header-rows: 0
     :align: center

Performance
==================

We'll publish the performance table in this section.

We'll publish two versions: one for the minimum requirements and one for the recommended

Architecture Overview
========================

This section describes how SoftGate fits into a Netris-managed network and how it participates in providing ingress and egress connectivity for tenant VPCs.
SoftGate is logically positioned at the edge of the Netris-managed North-South network. Its primary purpose is to provide IP address translation (NAT) and Layer-4 Load Balancing (L4LB) services for controlled ingress and egress of tenant traffic. 
For use cases that require direct, high-performance connectivity into a tenant VPC without address translation—such as private network interconnects or dedicated external routing—Netris provides a separate VPC Connect feature. VPC Connect enables routed connectivity to tenant VPCs and does not require a SoftGate.

.. image:: /images/softgate-hs-topology.svg
      :alt: SoftGate HS Topology
      :align: center
      :width: 600px
      :class: with-shadow

.. raw:: html

  <br />

To deliver ingress and egress services, SoftGate establishes BGP relationships with upstream routers, which are typically non-Netris-managed border routers or ISP routers.

On the southbound side, SoftGate integrates directly with the Netris-managed North-South EVPN fabric by acting as a VTEP. This allows SoftGate to exchange traffic with tenant VPCs through the North-South fabric using standard VXLAN mechanisms, while remaining fully integrated into the Netris control plane.

Physically, SoftGate must be connected to Netris-managed switches. SoftGate is not supported when directly connected to upstream routers.

Netris recommends at least two physical connections per SoftGate node, typically one to each switch in a redundant switch pair, to provide link and device redundancy. The upstream routers that form BGP sessions with SoftGate nodes must also be physically connected to the Netris-managed fabric. 

.. tip:: This design pattern is commonly referred to as a router-on-a-stick model, where routing adjacencies are established logically while all physical connectivity is provided through an intermediate switching fabric.

SoftGate Roles and Flavors
----------------------------------------

A single deployment typically includes multiple SoftGate HS instances, depending on traffic capacity and redundancy requirements. Each SoftGate is assigned one of two roles, which determine the type of traffic processing it performs:

* **Role: General**

  SoftGates with this role handle DNAT (which includes both 1:1 NAT and inbound port forwarding), Layer-4 load balancing (L4LB), and DHCP. 
  
  General SoftGates advertise specific /32 routes to upstream routers, allowing return traffic to be directed to the correct SoftGate instance. For optimal operation, the upstream routers should be configured to accept /32 route advertisements from SoftGates.

* **Role: SNAT**

  SoftGates with this role perform SNAT function for VPC originated outbound traffic. 
  
  SNAT, a purely outbound service, can be configured to translate the source IP of packets originated from one more more sources inside a tenant's VPC. This configuration, in which multiple internal sources are translated behind a single global IP or a small pool of global IPs, is commonly referred to as SNAT overload or Port Address Translation (PAT).
  
  SNAT SoftGates advertise specific /32 routes to upstream routers, allowing return traffic to be directed to the correct SoftGate instance. For optimal operation, the upstream routers should be configured to accept /32 route advertisements from SoftGates.

.. warning:: Starting with Netris 4.6.0, the only “flavor” of SoftGate supported is SoftGate HS (HyperScale).

Softgate Architecture
--------------------------------

Data Plane
~~~~~~~~~~~~

SoftGate dataplane is implemented using XDP (eXpress Data Path) and `netfilter <https://www.netfilter.org/projects/nftables/index.html>`_.
XDP is a Linux kernel feature that allows programs to process network packets at the earliest possible point in the network stack - right after the network driver receives them, before they enter the traditional kernel networking stack. This approach provides extremely low latency and high throughput packet processing.

.. tip:: You can check which interfaces are being attached in XDP with ``bpftool net``

.. warning:: XDP requires MTU to not exceed 3498 bytes. Netris automatically implements this requirement, but the user should consider this value in their designs.

.. warning:: Hyperthreading must be disabled for optimal performance.

.. warning:: Softgate dataplane with role SNAT is implemented on a stock Linux kernel with XDP acceleration coming soon.

Control Plane
~~~~~~~~~~~~~~~

SoftGate control plane is implemented with the `FRRouting <https://frrouting.org>`_ software stack and `iproute2 <https://wiki.linuxfoundation.org/networking/iproute2>`_.

.. _netris-softgate-HS-installation:

Installation and Initial Deployment
=================================================

Prerequisites
--------------------------------

* A server with Ubuntu Linux 24.04 LTS.
* Internet connectivity or “air-gapped” installation package.
* Subnets IPAM created in “vpc-1:Default”:

  * At least one subnet Purpose: Loopback
  * At least one subnet Purpose: Management

.. image:: /images/softGate-IPAM-auto-assign-IPs.png
      :alt: IPAM subnets
      :align: center
      :class: with-shadow

.. raw:: html

  <br />

Installation Guide
--------------------------------

To provision a Netris SoftGate, you must:

1. Create the SoftGate object in Network->Inventory.
2. Install the SoftGate software stack using the appropriate “one-liner” installer command.

Below are the step-by-step instructions.

1. Navigate to the **Network->Inventory** section and add a new hardware object with *Type: SoftGate**, *Flavor: SoftGate HS*. Select the desired SoftGate *Role*.

.. image:: /images/softGate-Add-Hardware.png
      :alt: SoftGate Add Inventory
      :align: center
      :class: with-shadow

.. raw:: html

  <br />

2. Provide the required information including the *Main IP address* and the *Management IP address*. Netris recommends explicitly specifying the IP addresses of every SoftGate node.

  .. tip:: You may leave the *Main IP address* and the *Management IP Address* set to *Assign Automatically*. If you do, Netris will automatically find the next available IP address in the earliest created subnet in the Netris IPAM with the appropriate Purpose (``purpose: loopback`` for loopback IPs and ``purpose: management`` for management IPs) and assign it to the SoftGate.

3. Add Links. This tells Netris how this node is physically connected to the switching fabric.
4. Locate the correct server object that represents the target SoftGate and click the three vertical dots (⋮) on the right side of the SoftGate node. Select Install Agent.

.. image:: /images/softGate-3dots.png
      :alt: SoftGate 3-dots menu
      :align: center
      :class: with-shadow

.. raw:: html

  <br />

5. Copy the one-line installer command to your clipboard.

.. image:: /images/softGate-oneliner.png
      :alt: SoftGate One-liner
      :align: center
      :class: with-shadow

.. raw:: html

  <br />

.. tip:: Starting with version 4.6.0, Netris SoftGate HS installs an accelerated dataplane for fast packet forwarding.

.. warning:: If you are upgrading from an earlier version, please make sure to remove the ``installer.lock`` file before running the one-liner installer.

  ``$ sudo rm /opt/netris/installer.lock``

6. Paste the one-line install command on your SoftGate HS node as an ordinary user. 

.. warning:: Keep in mind that one-line installer commands are unique for each node

.. warning:: Please note that Netris replaces Netplan with the ifupdown and attempts to migrate any prior configuration to ``/etc/network/interfaces``.

.. image:: /images/softgate-provisioning-cli-output.png
      :alt: SoftGate Install CLI Output
      :align: center
      :class: with-shadow

.. raw:: html

  <br />

7. Reboot the SoftGate
  
  ``$ sudo reboot``

8. Once the SoftGate reboots, you should see the Heathbeat healthcheck go from CRIT to OK.

.. image:: /images/softGate-health-ok.png
      :alt: SoftGate HS Health OK
      :align: center
      :class: with-shadow

.. raw:: html

  <br />

See the Observability section for further validation and sanity checks.

Connecting to upstream routers (EBGP)
================================================

SoftGate is designed as a highly available, horizontally scalable, and multi-tenant edge gateway cluster.

In the SoftGate cluster, in the interest of full redundancy and proper routing, each SoftGate node must establish an EBGP relationship with each of your upstream routers, such as your Internet border routers, ISP border routers, or Next Generation Firewalls (NGFW), depending on your overall network design.

A typical topology consists of:

* Two (2) upstream routers
* Two (2) SoftGates with role General
* Two (2) SoftGates with role SNAT

.. image:: /images/softgate-hs-upstream-routers.svg
      :alt: SoftGate HS Upstream Routers
      :align: center
      :class: with-shadow

.. raw:: html

  <br />


In a topology described above, Netris recommends that you establish a total of 8 EBGP sessions between your SoftGate layer and your upstream router layer (4 SoftGates x 2 routers = 8 sessions).

You can define EBGP connections to your upstream routers by navigating to Network -> E-BGP.

(Detailed instructions to be added soon)

BGP route exchange between SoftGates, upstream routers, and downstream switches
---------------------------------------------------------------------------------

Each SoftGate node will originate and advertise a set of prefixes as described below. This behavior can be altered by applying outbound prefix-lists (*Prefix List Outbound* field) to each E-BGP object in the Netris controller (Network->E-BGP).

1. By default, both General and SNAT roles SoftGates advertise all subnets configured in the Netris IPAM that meet all of the following conditions:

  a. Non-RFC1918
  b. Top parent
  c. Type:Subnet
  d. VPC ``vpc1:Default``

.. image:: /images/softGate-IPAM-upstream.png
      :alt: SoftGate HS Public Subnets
      :align: center
      :class: with-shadow

.. raw:: html

  <br />

To further demonstrate this default behavior, consider the above IPAM configuration.

    * SoftGates will advertise to the upstream EBGP peers 203.0.113.0/25, 203.0.113.128/26, and 203.0.113.192/27 because they are (a) non-RFC1918, (b) top-level parent objects of (c) ``type:subnet``, and are in (d) ``vpc-1:Default``.
    * SoftGates will NOT advertise to the upstream EBGP peers 203.0.113.128/27 or 203.0.113.160/27, because they are nested under another object of ``type:subnet``, and therefore are not (b) “top parent.”
    * SoftGates will NOT advertise to the upstream EBGP peers 198.51.100.0/24, even though it is a (b) top parent subnet, because it is assigned to ``vpc-3:VPC-3``, i.e., a (d) non-Default VPC, even though the ``Global Routing`` toggle is set to on for this subnet. 
    * SoftGates will NOT advertise to the upstream EBGP peers 192.0.2.0/24, because it's an object of ``type:Allocation``, not of ``type:Subnet``.

Below is the output of the ``show ip bgp neighbor advertised-routes`` command when the above configuration is in the Netris IPAM, and nothing is configured in the ``Prefix List Outbound`` field for this EBGP connection.

.. code-block:: shell-session

  ns-softgate-0# show ip bgp vrf Vrf_1 neighbors 10.10.0.2 advertised-routes
  BGP table version is 115, local router ID is 192.0.2.254, vrf id 7
  Default local pref 100, local AS 655001
  Status codes:  s suppressed, d damped, h history, u unsorted, * valid, > best, = multipath, i internal, r RIB-failure, S Stale, R Removed
  Nexthop codes: @NNN nexthop's vrf id, < announce-nh-self
  Origin codes:  i - IGP, e - EGP, ? - incomplete
  RPKI validation codes: V valid, I invalid, N Not found

        Network          Next Hop            Metric LocPrf Weight Path
    *>  203.0.113.0/25   0.0.0.0                  0         32768 i
    *   203.0.113.0/25   0.0.0.0<                 0         32768 i
    *   203.0.113.0/25   0.0.0.0<                 0         32768 i
    *>  203.0.113.128/26 0.0.0.0                  0         32768 i
    *   203.0.113.128/26 0.0.0.0<                 0         32768 i
    *   203.0.113.128/26 0.0.0.0<                 0         32768 i
    *>  203.0.113.192/27 0.0.0.0                  0         32768 i
    *   203.0.113.192/27 0.0.0.0<                 0         32768 i
    *   203.0.113.192/27 0.0.0.0<                 0         32768 i

  Total number of prefixes 3
  ns-softgate-0#

2. Additionally, SNAT SoftGates originate (and advertise to the upstream neighbors, if permitted with an outbound prefix-list) /32 prefixes that correspond to global IPs of the SNAT rules configured in the Netris controller. For each SNAT rule configured in the Netris controller, the Netris algorithm will automatically select one of the available SoftGate nodes with role SNAT, and, based on the `Maglev algorithm <https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/44824.pdf>`_, will install the SNAT rule on that SoftGate.

3. General SoftGates originate (and advertise to the upstream neighbors, if permitted with an outbound prefix-list) /32 prefixes that correspond to the global IPs of the L4LB or DNAT rules configured in the Netris controller. Unlike with the SNAT rules, where only one of the SNAT SoftGates is configured for any given SNAT rule in the Netris controller, each General SoftGate is configured with every L4LB and DNAT rule that is configured in the Netris controller.

.. tip:: Configure your upstream routers to receive these specific /32s for optimal routing and to prevent traffic from being forwarded internally if it arrives at the “wrong” SoftGate.

.. warning:: The same Global IP address cannot be configured simultaneously for SNAT and any other translation service.

High Availability and Load Distribution
================================================

SoftGate is designed as a highly available, horizontally scalable, and multi-tenant edge gateway cluster.

In the SoftGate cluster, in the interest of scalability, the nodes operate without state replication between them. Traffic distribution between nodes is achieved through a combination of the `Maglev algorithm <https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/44824.pdf>`_, BGP policies, and overall governance from the Netris controller.

Below is a high-level description of how packets are processed by the SoftGate layer of the Netris-managed fabric.

Netris VPC originated traffic routing
-------------------------------------

Any packet originating from any Netris VPC in the North-South fabric with the destination of the Internet or any other destination outside of the North-South fabric is processed in the following fashion. 

1. The packet is routed to a General SoftGate using ECMP for load distribution. To achieve this, the General SoftGates inject a default route into the Netris VPC for which either a NAT or an L4LB service is configured.
2. The General SoftGate processes DNAT or L4LB packets directly, but redirects SNAT packets to the appropriate SNAT SoftGate. This redirection is load-balanced based on the global IP of the SNAT rule, utilizing the `Maglev algorithm <https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/44824.pdf>`_ to ensure different SoftGates arrive at the same forwarding outcome without sharing state.
3. Once the packet arrives at the correct SNAT SoftGate, the source IP address is replaced, and the packet is sent to the internet

  * SNAT SoftGates locally remember the state for port overloading, but do not synchronize it with any other SoftGate.
  * General SoftGates do not keep track of connections, i.e., are fully stateless to achieve the best performance.  

.. tip:: If you require stateful and deep packet inspection services, which are out of scope for Netris SoftGate. Netris recommends deploying specialized hardware, such as a Next Generation Firewall (NGFW), upstream to Netris.

.. tip:: Inter-VPC traffic is handled by the Netris VPC peering function, which is forwarded through switches and is not routed to any SoftGates.

.. tip:: Only once a NAT or an L4LB service is configured in the Netris controller for a given VPC, the SoftGates with role General will start advertising the default route into that VPC, and the Internet-bound packets will be routed to the General SoftGates. If no NAT or L4LB services are configured for a VPC, no default route will be advertised into that VPC.

Internet originated traffic routing
-------------------------------------

Packets originating on the Internet or outside of the Netris-managed fabric with the destination of any IP address configured in the NAT or L4LB services are processed in the following manner.

1. Your upstream router forwards the inbound packet based on the routing information advertised by the SoftGates. As described in the BGP route exchange section of this document, all SoftGate nodes (General and SNAT) advertise the top-level subnets to all their upstream peers.

  a. If you did not apply any outbound prefix-lists (Prefix List Outbound field), the inbound packet will be forwarded to one of all deployed SoftGates based on ECMP.
  b. If a custom outbound prefix-list is in use, and specifically /32 prefixes are permitted, then the packet will be forwarded to the appropriate SoftGate node based on these /32 route announcements.

2. In the case where a packet was routed by the upstream router to the appropriate SoftGate based on a /32 prefix, the SoftGate performs the appropriate translation operation and forwards the packet into the appropriate V-Net.

3. In the case where /32 prefixes are not being learnt by the upstream routers (due to not being allowed by policy or any other reason), the packet may inadvertently be routed to a SoftGate node that cannot perform the required translation service directly. In this instance, the receiving SoftGate will forward the packet to the appropriate SoftGate nodes automatically based on policy-based routing configured by Netris to address this type of situation.

Failover behavior
------------------

Netris configures all DNAT and L4LB services on all SoftGate nodes with the role General.

Netris configures any given SNAT rule on one and only one SoftGate node with the role SNAT. The specific node is chosen based on [round-robin? Maglev? Some other way?].

The above approach allows the Netris SoftGate layer to remain highly available and robust in various hardware failure scenarios.

In case of a SoftGate node failure

* If the role of the failed SoftGate instance is General, an alarm is raised in the controller, but no further action is taken by the Netris algorithm.
* If the role of the failed SoftGate instance is SNAT, all the SNAT rules that were assigned to the failed SoftGate instance are evenly redistributed to all other SoftGates with the role SNAT.

Note that SNAT service is the only stateful translation service provided by SoftGates. SNAT connections will experience an interruption, as the SNAT rules are reconfigured on the surviving SoftGate nodes, and will have to be reestablished. However, DNAT and L4LB connections are stateless and will remain unimpacted in a SoftGate node failure scenario.

When a SNAT SoftGate recovers, Netris will… [to be completed] 

When an additional SNAT SoftGate is added to the deployment, as opposed having recovered from an earlier failure, Netris will execute a SNAT rule reshuffle to redistribute all configured SNAT rules across all deployed SNAT SoftGates. This action may result in brief interruption to existing SNAT connections, as the rules are being redistributed.
