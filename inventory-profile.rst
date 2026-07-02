.. _inventory-profile:
.. meta::
    :description: Inventory Profiles

==================
Inventory Profiles
==================

Inventory profiles allow security hardening of inventory devices and fabric-wide configuration optimizations. 

By default all traffic flow destined to switch/SoftGate is allowed. As soon as the inventory profile is attached to a device it denies all traffic destined to the device except Netris-defined and user-defined custom flows. 

Automatically allowed IPv4 and IPv6 inbound flows include:

*  SSH TCP port 22 from user defined subnets
*  NTP UDP port 123
*  DNS UDP and TCP port 53
*  SNMP UDP port 161 (IPv4 only) from user defined subnets
*  BGP TCP port 179 from defined neighbors and fe80::/64
*  ICMP
*  DHCP
*  Custom user defined rules

.. csv-table:: Inventory Profile Fields
   :file: tables/inventory-profile-fields.csv
   :widths: 25, 75
   :header-rows: 0

.. image:: images/Inventory-Profile-Top.png
   :align: center
   :class: with-shadow

.. raw:: html

  <br />

.. _snmp_settings:

SNMPv2 credentials
==================

Netris administers can define SNMPv2 credentials to monitor switches and SoftGates in the inventory. To add SNMPv2 credentials, expand the SNMPv2 section of the Inventory Profile form, set the checkbox to enabled, and fill in the fields as described below:

.. list-table:: SNMPv2 Fields

   * - Read-Only Community
     - ✅ required
     - Specify the SNMPv2 read-only community string.
   * - Allow SNMPv2 from IPv4
     - ✅ required
     - Specify the IPv4 subnets from which SNMPv2 requests will be accepted.
   * - SNMP Contact
     - 🔹 Optional
     - Specify the SNMP contact information.
   * - SNMP Location
     - 🔹 Optional
     - Specify the SNMP location information.

.. image:: images/SNMPv2-settings.png
   :align: center
   :class: with-shadow

.. raw:: html

  <br />

.. _netq_settings:

NetQ Settings
=============

Netris administers can define NetQ server address and port to automatically configure the NetQ client on Cumulus Linux based switches.

.. list-table:: NetQ Fields

   * - NetQ Server
     - ✅ required
     - Specify the IP address(es) or the FQDN of the NetQ server. You can specify one(1) or three(3) addresses separated by commas or one FQDN.
   * - NetQ Port
     - ✅ required
     - Specify the port of the NetQ server. Default is 31980.

.. image:: images/NetQ-IPs.png
   :align: center
   :class: with-shadow

.. raw:: html

  <br />

.. image:: images/NetQ-FQDN.png
   :align: center
   :class: with-shadow

.. raw:: html

  <br />

.. tip::

   You may also export your network topology as a Graphviz DOT to be imported into your NetQ instance. See :doc:`/monitoring-observability/netq` for more details.

.. _fabric_settings:

Fabric Settings
================

Netris can automatically optimize fabric configurations based on administrator's design and preferences. The following controls are available in the Fabric Settings section of the Inventory Profile form:

- **Fabric Type** (default = General Purpose).  The selected fabric type acts as a filter to determine which switches are subject to the "Optimize BGP Overlay for leaf-spine topology" feature as described below. Supported values include:
  
  * Generic
  * East-West
  * East-West-Plane1
  * East-West-Plane2
  * East-West-Plane3
  * East-West-Plane4
  * North-South
  * OOB

- **Optimize BGP Overlay for leaf-spine topology** (default = checked). When checked, Netris applies the following logic to all switches sharing the Fabric Type value set in this Inventory Profile. Netris configures designated switches as EVPN Route Servers (EVPN-RS), and each switch with the Switch Role property set to Leaf forms overlay BGP sessions (address-family l2vpn evpn) exclusively with those nodes. No other overlay BGP sessions are configured.

  EVPN-RS designation works as follows:

  * If no switch object has the :ref:`EVPN Route Server property <topology-management-adding-switches>` set, Netris automatically selects the two switches with the Switch Role property set to Super-Spine — or, if no Super-Spine switches are present, the two switches with the Switch Role property set to Spine — with the lowest loopback IPs.
  * If one or more switch objects have the :ref:`EVPN Route Server property <topology-management-adding-switches>` set, automatic selection is disabled entirely and Netris uses only the explicitly designated switches as EVPN-RS nodes.
  * Because setting the property on even one switch disables automatic selection, operators should explicitly designate at least two switches for redundancy. Netris does not automatically enforce this recommendation.

  When unchecked, overlay BGP sessions are configured on all point-to-point links.

- **Optimize BGP Overlay for Hypervisor Integrated Fabric** (default = unchecked). Required for BGP/EVPN VXLAN integration with compute hypervisor networking. This optimization makes sure that a large number of hypervisor virtual networking EVPN prefixes do not overflow switch TCAM.
- **BGP Numbered Underlay** (default = unchecked).  When checked, BGP underlay sessions will be configured using p2p IPv4 addresses configured on link objects in the Netris controller. Otherwise, BGP unnumbered method is used and p2p ipv6 link-local addresses are used for BGP sessions.
- **Automatic Link Aggregation** (default = unchecked). When checked, Enable MC-LAG shall become unchecked automatically through the UI.
- **Enable MC-LAG** (default = unchecked). When checked, Automatic Link Aggregation shall become unchecked automatically through the UI.  If unchecked none of MC-LAG related configurations should be generated by switch agents. Help message: “Enabling MC-LAG functionality will disable any EVPN-MH functionality. Two multihoming methods are not supported simultaneously on the same switches.”
- **Generate ESI by Server ID** (default = unchecked). When checked, ESI-IDs are generated using server-ID-based logic instead of the default partner-MAC-based method. The setting is backwards compatible: existing ESI-IDs remain valid, and servers not modeled in Netris automatically fall back to partner-MAC-based generation.

.. _gpu_cluster_settings:

GPU Cluster Specific Settings
=============================

Additional optimizations are available for East-West GPU interconnect fabrics.
 
- **QoS & RoCE** (default = unchecked) Optimize for RDMA over Converged Ethernet
- **RoCE Adaptive Routing (AR)** (default = unchecked) Enable Adaptive Routing for RoCE
- **Congestion Control** (default = unchecked) Enable Zero Touch RoCE Congestion Control
- **ASIC monitoring** (default = unchecked) Enable ASIC monitoring: histograms and telemetry snapshots.
- **HWMP** (default = unchecked) Enable Hardware Multiplane (HWMP) support for GPU cluster fabrics with multiple planes of switches and leaf-spine topology. Must set the appropriate Reference Architecture.
- **Reference Architecture** (default = None)  This setting tells Netris which reference architecture is being deployed on the subject fabric, so Netris can apply the appropriate prefix summarization in the L3VPN overlay. 

  .. collapse:: Reference Architectures

    .. list-table::
        :header-rows: 1

        * - Reference Architecture
          - IPv4 

            Summarization mask
          - IPv6 
            
            Summarization mask
        * - H100/H200/B200 SPX 2-TIER

            H100/H200/B200 SPX 3-TIER
          - /26
          - /56
        * - GB200 SPX 2-TIER
            
            GB200 SPX 3-TIER
          - /25
          - /46
        * - B300 SPX 2-TIER SINGLE-PLANE

            B300 SPX 3-TIER SINGLE-PLANE

            B300 SPX 2-TIER DUAL-PLANE

            B300 SPX 3-TIER DUAL-PLANE

            B300 SPX 2-TIER QUAD-PLANE

            B300 SPX 3-TIER QUAD-PLANE

            GB300 SPX 2-TIER SINGLE-PLANE

            GB300 SPX 3-TIER SINGLE-PLANE

            GB300 SPX 2-TIER DUAL-PLANE

            GB300 SPX 3-TIER DUAL-PLANE

            GB300 SPX 2-TIER QUAD-PLANE
            
            GB300 SPX 3-TIER QUAD-PLANE
          - /24
          - /56

.. _custom_rules:

Custom Rules
================

Custom rules allow the administrator to define specific allow/deny flows to/from inventory devices.

If an inventory profile is attached to a switch or a softgate, then Netris configures an implicit inbounddeny ACL. Several rules are automatically added to this ACL to allow the necessary system services connections like NTP, DNS, SSH from Allowed Hosts, BGP, ICMP, DHCP, SNMP. Everything else is denied by the implicit deny rule. 
If additional inbound services (e.g., Netflow/Sflow) need to be allowed, you can use Custom Rules to permit those connections.

In the example below, a custom rule is defined to allow inbound TCP traffic on port 555 from 1.1.1.1/32 to the inventory device.

.. image:: images/CustomRules.png
   :align: center
   :class: with-shadow

.. raw:: html

  <br />

.. _ztp_settings:

ZTP Settings
================

- **NOS Image file** When Zero Touch Provisioning (ZTP) is in use, this Network Operating System image will be used to bootstrap the switches subject to this Inventory Profile.
- **NOS Admin Password** Once the ZTP process completes, Netris will configure this password for the builtin admin user.
- **NOS Admin Confirm Password** Confirmation of the NOS Admin Password.
