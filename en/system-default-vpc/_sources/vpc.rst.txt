.. meta::
    :description: Netris VPC

.. _vpc_top:

==========
VPC
==========

.. contents:: Table of Contents
   :local:
   :depth: 3

Overview
========

A **Virtual Private Cloud (VPC)** is the essence of Multi-Tenancy, one of the three pillars of the Netris NAAM (Network Automation, Abstraction, and Multi-Tenancy) platform (see :doc:`introduction`). It lets multiple tenants share the same physical infrastructure while remaining completely separated from one another.

A Netris VPC lets you operate a group of resources inside a logically segregated virtual network, with each tenant's resources isolated from every other VPC. On Ethernet-based fabrics, each VPC maps to a dedicated VRF instance on the switch fabric, which means different VPCs can use overlapping IP ranges without any conflict. On InfiniBand and NVL72 fabrics, the VPC construct is purely administrative — it does not translate into any specific configuration construct on the hardware itself.

VPC is the highest object in the Netris hierarchy and spans every :doc:`Site <site>` in the deployment. All other constructs, including V-Nets, IPAM allocations and subnets, BGP sessions, NAT rules, load balancers, and static routes, are **child objects** that belong to exactly one VPC. VPC Peering is the one construct that explicitly relates two VPCs to each other, enabling controlled connectivity between otherwise isolated environments.

.. TODO: Diagram needs update with latest Netris collaterals (per Noam's review).

.. image:: images/vpc_diagram.png
   :align: center
   :alt: VPC diagram
   :class: with-shadow

.. raw:: html

   <p style="text-align: center;"><em>Netris VPC concept diagram</em></p>

Adding a new VPC
==================

VPCs are managed under ``Network -> VPC``, where you can create, edit, and remove them. New VPCs are created using the **Add** button. The Add VPC dialog defines the VPC's identity and access model:

.. image:: images/vpc_add.png
    :align: center
    :class: with-shadow

.. raw:: html

   <p style="text-align: center;"><em>Add new VPC dialog</em></p>

.. list-table:: VPC Fields
   :header-rows: 1
   :widths: 20 45 35

   * - Field
     - What it does
     - Notes / defaults
   * - **Name**
     - Name of the VPC.
     - Required.
   * - **Admin Tenant**
     - The tenant that owns the VPC. Users granted access as this tenant can manage all of the VPC's own parameters (name, tags, tenants, and so on).
     - Required.
   * - **Guest Tenants**
     - Additional tenants (other than the Admin Tenant) allowed to add and remove services *inside* the VPC — V-Nets, L4 Load Balancers, Server Clusters, IPAM subnets, and the like — without being able to change the VPC's own parameters.
     - Optional, multiple allowed. See :doc:`accounts` for more on Admin vs. Guest Tenants.
   * - **Tags**
     - Free-form labels you assign to the VPC for search/filter in the VPC listing. Same generic tagging mechanism used on V-Nets and other objects — it has no configuration effect on the VPC itself.
     - Optional, multiple allowed. Letters, numbers, ``_``, ``=``, ``-``, and ``.`` only.

.. _vpc_child_objects:

VPC child objects
==================

The table below lists the objects that belong to a VPC, what selecting a VPC for that object actually controls, and any placement restrictions. As a rule of thumb: if an object's VPC field is described below as "local/tenant," selecting a tenant VPC there does not put that object's public-facing side in the same VPC — the System VPC (see :ref:`System VPC and Default VPC <vpc_system_default>` below) is always the other end for NAT and load-balancer exit traffic.

.. list-table::
   :header-rows: 1
   :widths: 20 45 35

   * - Object
     - What the VPC field controls
     - Notes
   * - :doc:`V-Net <vnet>` (``Services -> V-Net``)
     - The VPC the network segment (and its endpoints) belongs to.
     - A V-Net belongs to exactly one VPC and one or more Sites.
   * - IPAM Allocation / Subnet (``Network -> IPAM``)
     - The VPC the allocation or subnet is filed under.
     - See :doc:`ipam`. A subnet's *Purpose* (common, loopback, management, load-balancer, nat, inactive) determines how it can be used; loopback, load-balancer, and nat subnets are conventionally created in the System VPC — see :ref:`System VPC and Default VPC <vpc_system_default>`.
   * - E-BGP peer (``Network -> E-BGP``)
     - The VPC the BGP session's routes are injected into.
     - The **BGP Router** field determines where the session terminates: a SoftGate-terminated session must use the System VPC; a switch- or V-Net-terminated session (Direct Connect, no SoftGate) can use any VPC, but doesn't get SoftGate NAT/load-balancer services.
   * - Static Route (``Network -> Routes``)
     - The VPC the route applies to.
     - Useful for pointing a VPC's default route somewhere other than a SoftGate, or for temporary migration routes.
   * - NAT rule (``Network -> NAT``)
     - The **local/tenant** VPC whose workloads are translated.
     - The public/exit side of the translation is always the System VPC — it is not a selectable field.
   * - :doc:`L4 Load Balancer <l4-load-balancer>` (``Services -> Load Balancer``)
     - The **local/tenant** VPC containing the backend endpoints.
     - Same exit behavior as NAT: the frontend virtual IP is served from the System VPC via SoftGate.
   * - VPC Peering (``Network -> VPC Peering``)
     - Two VPCs whose routes are selectively exchanged.
     - Commonly used to reach shared services (DNS, storage, and the like) from multiple tenant VPCs without giving those tenant VPCs a route to each other. See the VPC Peering section of :doc:`network-policies`.
   * - :doc:`Server Cluster <server-cluster>` (``Services -> Server Cluster``)
     - Can create a brand-new VPC for you.
     - Setting VPC to **Create New** provisions a VPC along with its V-Nets and IPAM subnets in one step. See :doc:`server-cluster` for additional details.

.. _vpc_system_default:

System VPC and Default VPC
=============================

**In short:** every fresh deployment ships with one VPC — VPC-1 — that is both the System VPC (the infrastructure trust anchor) and the Default VPC (the fallback for unspecified VPC fields). These are separate roles that happen to point at the same VPC by default; either can, in principle, point elsewhere.

VPC-1 is provisioned automatically as part of the initial setup and cannot be deleted. As the **System VPC**, it's home to the platform's own infrastructure objects — switch loopback subnets, SoftGate eBGP sessions, and the public side of NAT and load balancer services. As the **Default VPC**, it's the fallback the Controller substitutes whenever an API call or dialog leaves the VPC field unspecified.

The System VPC role is about trust: it anchors objects the operator implicitly relies on. The Default VPC role is about convenience: it's a catch-all for calls that didn't specify a VPC. The distinction matters once you start creating additional VPCs for tenants — the following sections cover each role in detail.

.. image:: images/vpc_system_vs_default.png
   :align: center
   :alt: VPC listing showing the System and Default flags set independently across three VPCs
   :class: with-shadow

.. raw:: html

   <p style="text-align: center;"><em>System and Default are independent flags: VPC-1 is System but not Default, VPC-3 is Default but not System</em></p>

What the Default VPC is for
----------------------------

The Default VPC is a **convenience/fallback mechanism**, not a trust or security boundary. VPC is a required field on every VPC-scoped object — it's just that the value doesn't always have to come from the caller. Exactly one VPC in a deployment is flagged as default, and that VPC is what the Controller substitutes whenever a value is required but none was explicitly given.

In the web UI, the Default VPC is pre-selected in "Add new" dialogs for VPC-scoped objects. You're free to change the selection before saving, but if you don't, the object is created in whichever VPC is flagged default. Over the API or in Terraform, the same substitution happens if a call omits the VPC field: the Controller doesn't reject the request for missing a required value, it fills that value in with the Default VPC.

.. image:: images/vpc_default_select.png
   :align: center
   :alt: Add new V-Net dialog with the VPC field pre-selected to the Default VPC
   :class: with-shadow

.. raw:: html

   <p style="text-align: center;"><em>The VPC field in an Add new dialog comes pre-selected to whichever VPC is flagged Default</em></p>

Modern Netris integrations set the VPC field explicitly on every object, so in a current deployment, anything that lands in the Default VPC via this substitution is more often a sign of a missing or mistaken VPC field in a call than an intentional placement. See :ref:`Why they're the same VPC today <vpc_history>` for how this fallback mechanism came about.

.. tip::
   Because the Default VPC is a catch-all for calls that didn't specify a VPC, don't treat objects that land there as trusted or related to each other. Two V-Nets that both end up in the Default VPC through omission may belong to two completely different tenants that just happen to share the same "nobody specified a VPC" fate. Periodically auditing the Default VPC's contents is a good way to catch missing ``VPC`` fields in Terraform/API calls.

What the System VPC is for
----------------------------

The System VPC is the **trust boundary and anchor point for platform/infrastructure objects** — the things every deployment needs regardless of how many tenants it serves. Concretely, the System VPC is where the following live:

.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - Object
     - Why it lives here
   * - **Switch loopback and VTEP IPAM subnets**
     - Switch main loopback IPs operate in the underlay and, by definition, don't belong to any VPC/VRF — but Netris IPAM still needs a VPC to file that subnet under, since every IPAM subnet has a VPC parent. (This is purely an IPAM bookkeeping detail — the loopback IPs themselves are never actually configured inside the System VPC's VRF on the switch.)
   * - **eBGP sessions terminated on SoftGate**
     - These are your upstream/external BGP sessions — peering with providers, border routers, or an IX — and they define the reachability Netris uses for SNAT egress and DNAT/load-balancer ingress.
   * - **Public/exit side of NAT and Load Balancer services**
     - The VPC field on a NAT rule or load balancer selects the *local tenant VPC* being served. The public-facing side (the SNAT pool, or the DNAT/load-balancer virtual IP) is always the System VPC; you don't select it, and it can't be changed to another VPC.

.. important::
   Any eBGP peer whose BGP Router is set to a SoftGate node must be created in the System VPC — this is the only supported configuration, though the Controller does not technically block creating one elsewhere. eBGP peers terminated directly on a switch or V-Net (no SoftGate — Direct Connect) aren't restricted to the System VPC; see the E-BGP peer row in :ref:`VPC child objects <vpc_child_objects>`.

.. warning::
   Avoid creating V-Nets or servers in the System VPC and then relying on SNAT/DNAT or VPC Peering to reach them from tenant VPCs — this is not a supported pattern, even though the Controller does not block it outright. Keep tenant services in tenant VPCs, and use the System VPC only for the objects above.

.. tip::
   If you need a VPC for the operator's own shared infrastructure services (DNS, NTP, monitoring, and the like) that tenants should not have access to, create a dedicated VPC for it — do not reuse the System VPC for this purpose. The System VPC is for the platform's own BGP/NAT/loopback plumbing, not for "services I, the operator, own."

.. _vpc_history:

Historical note
================

.. collapse:: Why System VPC and Default VPC are the same VPC today

   VPC-1 doubles as both System VPC and Default VPC because of how multi-VPC support was introduced. Earlier Netris versions supported only a single VPC per deployment, so every object belonged to it by definition. When multi-VPC support shipped, that single, pre-existing VPC had to keep working as both the anchor for infrastructure objects (System VPC) and the landing zone for objects with no VPC specified (Default VPC), so upgraded deployments would keep functioning without any changes. New deployments inherited the same shipping default.

   The practical result: anything you forget to assign a VPC to lands in the same VPC used for switch loopbacks, upstream BGP, and NAT/load-balancer exit traffic. If that combination doesn't fit your operational model, you can point the Default VPC flag at a different, non-system VPC — the System VPC's specific roles (loopbacks, SoftGate-terminated BGP, NAT/LB exit) stay with VPC-1 regardless of which VPC is flagged as default.
