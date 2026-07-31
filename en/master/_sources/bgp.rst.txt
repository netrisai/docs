.. meta::
    :description: Netris BGP

.. _bgp_def:

======================
BGP
======================

.. contents:: Table of Contents
   :local:
   :depth: 4

Basic BGP
---------

BGP neighbors can be declared in the Network → E-BGP section. Netris software will automatically generate and program the network configuration to meet the requirements.

A BGP session with an external to the Netris-managed fabric neighbor is defined by two independent choices:

- **BGP Router** — the switch (or SoftGate) that hosts the local BGP speaker and where the Netris-managed side of the session terminates.
- **Local endpoint interface** — either a routed **switch port** or a **V-Net gateway (SVI)**, selected by setting either *Switch port* or *Connect via V-Net* (under Advanced).

The peer-facing port can be any port on the Netris-managed fabric; it does not have to sit on the switch selected as the BGP Router. When the port and the BGP Router are on different switches, Netris connects the two automatically — it creates a dedicated SVI on the BGP Router switch and provisions a hidden (meaning not visible in the GUI under the V-Net menu) "virtual wire" V-Net to the switch where the peer is physically connected.

The resulting combinations:

.. list-table::
   :header-rows: 1
   :widths: 25 35 40

   * - Local endpoint
     - Peer port on the BGP Router switch
     - Peer port on a different switch
   * - **Routed switch port**
     - The session and the port are on the same switch.
     - Netris builds a virtual wire from the peer's port to the SVI created on the BGP Router switch.
   * - **V-Net gateway (SVI)**
     - The V-Net's SVI on that switch is the local endpoint.
     - The V-Net is extended to the BGP Router switch, and the SVI created there terminates the session.

**Adding BGP Peers**

#. Navigate to Network → E-BGP in the web UI.
#. Click the Add button.
#. Fill in the fields as described in the table below.
#. Click the Add button.

.. csv-table:: BGP Peer Fields
    :file: tables/bgp-basic.csv
    :widths: 25, 75
    :header-rows: 0

Example: Declare a basic BGP neighbor.

.. image:: images/create_bgp.png
    :align: center

If everything is correct, State, port and BGP will get green status.

.. image:: images/bgp_status.png
    :align: center

Advanced BGP
------------

BGP neighbor declaration can optionally include advanced BGP attributes and BGP route-maps for fine-tuning of BGP policies.

Click Advanced to expand the BGP neighbor add/edit window.

.. csv-table:: BGP Peer Fields - Advanced
    :file: tables/bgp-advanced.csv
    :widths: 25, 75
    :header-rows: 0

**Effect of Remove Private AS on prefixes advertised by SoftGate nodes to their upstream BGP neighbors:**

- Typically, all SoftGate nodes in a deployment share the same AS number.
- All SoftGate nodes advertise all prefixes (locally originated as well as originated on other SoftGate nodes and subsequently learned through the fabric) to their upstreams.
- When the **Remove Private AS** is switched on (check box is set), all inter-SoftGate path information is stripped from the AS PATH before the prefix is advertised upstream, thus each prefix will appear to the upstream BGP neighbor as equidistant (ECMP). As a result some traffic might be forwarded to SoftGates that would then have to forward it again to the "correct" SoftGate, thus resulting in suboptimal routing behavior and increased load.
- With the **Remove Private AS** toggle set to off (check box is cleared), the AS PATH of each prefix will include the full list of ASN, including the list of ASNs of switches connecting SoftGates to each other. Because of this, on any given SoftGate locally originated prefixes will always have the AS PATH shorter than prefixes learned through the switch fabric from other SoftGates.

BGP Objects
-----------
| Under Network → E-BGP objects, you can define various BGP objects referenced from a route-map to declare a dynamic BGP policy.
| Supported objects include:

* IPv4 Prefix
* IPv6 Prefix
* AS-PATH
* Community
* Extended Community
* Large Community

IPv4 Prefix
^^^^^^^^^^^
| The rules are defined one per line.
| Each line in IPv4 prefix list field consists of three parts:

* Action - Possible values are: permit or deny (mandatory).
* IP Prefix - Any valid IPv4 prefix (mandatory).
* Length - Possible values are: le <len>, ge <len> or ge <len> le <len>.

Example: Creating an IPv4 Prefix list.

.. image:: images/ipv4_prefix.png
    :align: center

IPv6 Prefix
^^^^^^^^^^^
| Rules defined one per line.
| Each line in IPv6 prefix list field consists of three parts:

* Action - Possible values are: permit or deny (mandatory).
* IP Prefix - Any valid IPv6 prefix (mandatory).
* Keyword - Possible values are: le <len>, ge <len> or ge <len> le <len>.

Example: Creating an IPv6 Prefix list.

.. image:: images/ipv6_prefix.png
    :align: center

Community
^^^^^^^^^
| Community field has two parts:

* **Action** - Possible values: permit or deny (mandatory).
* **Community string** - Allowed format: ``<permit/deny> LINE``. LINE is AA:NN Community number in AA:NN format (where AA and NN are (0-65535)) or ``local-AS``, ``no-advertise``, ``no-export``, ``internet`` or ``additive``.

Example: Creating community.

.. image:: images/community.png
    :align: center

BGP route-maps
--------------
| Under the Network → E-BGP Route-maps section, you can define route-map policies, which can be associated with the BGP neighbors inbound or outbound.

| Description of route-map fields:

* **Sequence Number** - Automatically assigned a sequence number. Drag and move sequences to organize the order.
* **Description** - Free description.
* **Policy** - Permit or deny the routes which match below all match clauses within the current sequence.
* **Match** - Rules for route matching.

  * **Type** - Type of the object to match: AS-Path, Community, Extended Community, Large Community, IPv4 prefix-list, IPv4 next-hop, Route Source, IPv6 prefix-list, IPv6 next-hop, local-preference, MED, Origin, Route Tag.
  * **Object** - Select an object from the list.

* **Action** - Action when all match clauses are met.

  * **Action type** - Define whether to manipulate a particular BGP attribute or go to another sequence.
  * **Attribute** - The attribute to be manipulated.
  * **Value** - New attribute value.

Example: route-map

.. image:: images/route-map.png
    :align: center
    :class: with-shadow

eBGP Importing Non-Default Routes into a VPC
-----------------------------------------------

In multi-uplink deployments, SoftGate Hyperscale (SG-HS) nodes can be eBGP peered with different upstream networks.

By default, Netris SoftGates only redistribute the default route into tenant VPCs, regardless of what other prefixes they receive from upstream peers. This ensures a consistent routing table across all SoftGates, but can lead to suboptimal routing, where traffic from the VPC is always routed to the SoftGate receiving the default, even if another SoftGate has a better path via specific prefixes.

Starting with version 4.5.4, Netris introduces a mechanism to selectively import non-default routes into VPCs by tagging them with a special **BGP community: 0:7**. Routes marked with this community will be redistributed into tenant VPCs alongside the default.

.. warning::
  Importing additional prefixes into VPCs increases the size of the routing table on SoftGates and switches. Ensure that your hardware can handle the increased load, especially if you plan to import many prefixes.

How to Import Non-Default Prefixes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You have two options for tagging the desired prefixes with the required 0:7 community.

**Option 1**: Tag Inbound in Netris (on SoftGate HS)

If you manage the eBGP peer configuration using the Netris Controller, you can mark specific routes for redistribution into tenant VPCs by tagging them with the special BGP community 0:7.

1.	Create a Prefix List under Network → E-BGP Objects

.. tip::
  Do not include 0.0.0.0/0 — it is automatically imported

.. image:: images/prefix-list-imported-prefixes.png
    :align: center
    :alt: prefix list
    :class: with-shadow

.. raw:: html

    <br/>

2.	Create a Route Map under Network → E-BGP Route-Maps

Add a new route-map that

  -	Matches the prefix list created in Step 1
  -	Sets the BGP community to ``0:7``

.. image:: images/ebgp-route-map-set-07.png
    :align: center
    :alt: route-map
    :class: with-shadow

.. raw:: html

    <br/>

3.	Attach the Route Map to the eBGP Peer under Network → E-BGP

Edit the relevant eBGP neighbor and under Advanced Settings, set the inbound route-map to the one created in Step 2

.. image:: images/ebgp-advanced-inbound-route-map.png
    :align: center
    :alt: inbound route-map
    :class: with-shadow

.. raw:: html

    <br/>

Once applied, any matching prefixes received from this eBGP peer will be tagged with community 0:7, making them eligible for redistribution into tenant VPCs by the SoftGate.

.. tip::
  You can verify imported routes in the :doc:`Looking Glass <monitoring-observability/looking-glass>` (Network → Looking Glass) section of the Controller UI.

.. warning::
  When configuring an inbound route-map on an eBGP peer, an outbound route-map must also be set. If no outbound route-map is needed, create a dummy one that permits all routes without modification and attach it to the outbound direction.

**Option 2**: Tag Outbound from External BGP Peer

Alternatively, the external BGP speaker can set the 0:7 community on outbound updates before advertising routes to the SoftGate. This option does not require any configuration in Netris, as long as the incoming route already carries the community.

This is useful when the upstream router is under the customer's control and managing policy from that side is preferred.
