.. meta::
    :description: IP Address Management

.. _ipam_def:

============================
IP Address Management (IPAM)
============================

Netris IPAM is the address-space source of truth every address-consuming object in Netris depends on: V-Net gateways and DHCP pools, NAT and L4 Load Balancer address pools, switch and SoftGate loopback and management IPs, and BGP route advertisement all draw from subnets created here first. Allocations and subnets are tracked per VPC in a nested, tree-like structure, and each subnet's purpose and tenant determine which services are allowed to consume it.


Allocations and Subnets
-----------------------

There are 2 main types of IP prefixes - allocation and subnet. Allocations are IP ranges allocated to an organization via RIR/LIR or private IP ranges that are going to be used by the network. Subnets are prefixes which are going to be used in services.

An allocation never has a parent — creating an allocation inside another allocation is rejected. A subnet may sit under another subnet, to any depth: creating a ``10.0.10.0/25`` where a ``10.0.10.0/24`` subnet already exists files the ``/25`` under the ``/24``. The parent is never chosen — there is no parent selector. You enter a prefix, and the Controller places it under the containing allocation or subnet in that VPC.

Only top-level subnets are advertised upstream by SoftGate, so whether a subnet is nested under another subnet changes what leaves the fabric — see :doc:`SoftGate HS <netris-softgate-HS>`.

.. image:: images/subnet-tree.png
   :align: center
   :alt: IPAM Tree View
   :class: with-shadow

.. raw:: html

   <p style="text-align: center;"><em>Figure: IPAM Tree View</em></p>

Subnet purpose and service dependencies
----------------------------------------

Netris models address space first and consumes it second: you create an IPAM subnet with the right **purpose** before the service that will use it. A service only offers addresses from subnets whose purpose matches, so the IPAM entry is a prerequisite, not an afterthought.

Subnets — not allocations — are what render the ``network`` statements Netris uses for BGP route advertisement. To have a particular prefix or subprefix advertised, create a subnet for it — see :doc:`BGP <bgp>`.

.. list-table::
   :header-rows: 1
   :widths: 20 55 25

   * - Purpose
     - Required for
     - Typical VPC
   * - ``common``
     - A :doc:`V-Net <vnet>`'s Layer-3 gateway (SVI), and the address pool :doc:`DHCP <dhcp-and-dhcp-relay>` hands out. For a multi-site V-Net, create the subnet and assign it to every site the V-Net spans before adding the gateway.
     - Tenant VPC
   * - ``loopback``
     - Loopback IPs for Netris hardware (switches, SoftGates).
     - System VPC
   * - ``management``
     - Out-of-band management IPs for switches and SoftGates; a management-purpose subnet also drives ZTP. (Since 4.9, management subnets can also be used in V-Nets and VPCs.)
     - System VPC
   * - ``load-balancer``
     - :doc:`L4 Load Balancer <l4-load-balancer>` frontend VIP pool.
     - System VPC
   * - ``nat``
     - :doc:`NAT <nat>` public addresses (SNAT pools and DNAT targets).
     - System VPC
   * - ``inactive``
     - Nothing — reserve or document a prefix for future use.
     - —

See the :doc:`V-Net <vnet>`, :doc:`L4 Load Balancer <l4-load-balancer>`, :doc:`NAT <nat>`, and :doc:`DHCP and DHCP Relay <dhcp-and-dhcp-relay>` pages for how each service consumes its subnet, and :doc:`Netris VPC <vpc>` for why loopback, management, load-balancer, and nat subnets live in the System VPC.

.. note::

   **Purpose is necessary but not sufficient.** A service also only offers subnets owned by its own Owner (:doc:`Tenant <accounts>`). For a V-Net, the gateway subnet must have purpose ``common``, be assigned to the V-Net's Owner, and be available in a site the V-Net spans — see :doc:`V-Net <vnet>`. An empty address picker with no error therefore has four possible causes: purpose, VPC, site, or tenant.

Add an Allocation
-----------------

#. Navigate to Net→IPAM 
#. Click the **Add** button
#. Select **Allocation** from the bottom select box
#. Fill in the rest of the fields based on the requirements listed below
#. Click the **Add** button


.. list-table:: Allocation Fields
   :widths: 25 50
   :header-rows: 0

   * - Name
     - Unique name for current allocation.
   * - VPC
     - The VPC the allocation belongs to.
   * - Prefix
     - Unique prefix for the allocation, must not overlap with other allocations in the same VPC. Allocations may hold the same prefix in different VPCs — see :doc:`Definitions <definitions>`.
   * - Tenant
     - Owner of the allocation. Must be a tenant with access to the VPC — the VPC's Admin Tenant or one of its Guest Tenants; any other tenant is rejected.

.. image:: images/add-allocation.png
   :align: center
   :class: with-shadow
   :alt: Add a New IP Allocation

Add Allocation Window

--------------------------

Add a Subnet
------------

#. Navigate to Net→IPAM 
#. Click the **Add** button
#. Select **Subnet** from the bottom select box
#. Fill in the rest of the fields based on the requirements listed below
#. Click the **Add** button


.. list-table:: Subnet fields
   :widths: 25 50
   :header-rows: 0

   * - **Name**
     - Unique name for current subnet.
   * - **VPC**
     - The VPC the subnet belongs to. Any VPC can be selected here, but only the VPC already carried by the parent allocation will be accepted — selecting any other VPC prevents the subnet from being created.
   * - **Prefix**
     - Unique prefix for the subnet, must be included in one of the allocations.
   * - **Sites**
     - One or more sites the subnet is assigned to. A subnet can be assigned to multiple sites — this is the mechanism for extending a V-Net across multiple locations; see :doc:`V-Net <vnet>`.
   * - **Tenant**
     - Owner of the subnet. Must be a tenant with access to the VPC — the VPC's Admin Tenant or one of its Guest Tenants; any other tenant is rejected. It does not otherwise restrict who may carve subnets: any tenant with access to the VPC can create subnets under an allocation owned by a different tenant, and a child subnet need not share a tenant with its parent subnet or with the allocation — VPC is the only field that must match all the way down the tree. See *Subnet purpose and service dependencies*, above, for how a subnet's Tenant gates which services can consume it.
   * - **Purpose**
     - This field describes for what kind of services the current subnet can be used. It can have the following values:

        - *common* - ordinary subnet, can be used in v-nets.
        - *loopback* - hosts of this subnet can be used only as loopback IP addresses for Netris hardware (switches and/or softgates).
        - *management* - subnet which specifies the Out-of-Band management IP addresses for Netris hardware (switches and softgates).
        - *load-balancer* - hosts of this subnet are used in L4LB services only. Useful for deploying on-prem kubernetes with cloud-like experience.
        - *nat* - hosts of this subnet or subnet itself can be used to define NAT services.
        - *inactive* - can't be used in any services, useful for reserving/documenting prefixes for future use.

.. image:: images/add-subnet.png
  :align: center
  :alt: Add a New Subnet
  :class: with-shadow

.. raw:: html

   <p style="text-align: center;"><em>Figure: Add Subnet Window</em></p>

.. tip::

   **IPAM does not track point-to-point link addressing.** Underlay BGP-numbered links and L3VPN per-port links are configured directly on the Link object in Topology Manager instead — see :doc:`Topology Management <topology-management>`, :doc:`Inventory Profiles <inventory-profile>`, and :doc:`Server Cluster <server-cluster>`. Netris can auto-allocate them, or an operator can enter them manually; L3VPN link addresses are typically pre-populated with Terraform during server onboarding.
