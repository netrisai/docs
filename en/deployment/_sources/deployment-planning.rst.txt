.. meta::
    :description: Planning a Netris Deployment

.. _deployment_planning:

==========================
Planning Your Deployment
==========================

A Netris deployment requires a set of design decisions that must be resolved before installation begins. This page lists those decisions as questions, organized by topic. Your answers determine which Netris components apply to your environment, how the management network is structured, what infrastructure you need in place, and which features are available from Day 1.

For the best outcome, involve the Netris customer success team before ordering hardware. Brownfield migrations — deploying Netris into an existing, live network — are fully supported, but greenfield deployments benefit most from early design review. In NVIDIA-based deployments, NVIDIA Implementation Services (NVIS) typically provides the network design. Netris works closely with NVIS to ingest those designs and model the complete topology in simulation (NVIDIA DSX Air or Netris CloudSim) before any physical work begins. This is known as the Day 0 phase of the deployment.

You do not need to resolve every question below independently — the Netris customer success team works through this with you. What you need before that conversation is a clear picture of your environment and your operational requirements.

**Assumptions that apply to every Netris deployment:**

* The North-South (frontend) Ethernet fabric is always present.
* Netris assumes multi-tenant deployments. Every Netris deployment includes at minimum a management tenant, a service tenant, and a shared services tenant alongside any user tenants. Netris equally supports single-tenant deployments — the tenancy model does not change the platform or its configuration.
* Each GPU server has one dedicated East-West NIC per GPU, regardless of whether the East-West fabric is Ethernet or InfiniBand.

Deployment type
===============

The answers to these two questions branch the rest of the planning process.

* Is this an AI (GPU) deployment, or a traditional CPU-only data center?

  * **AI (GPU):** An East-West backend fabric is present. Continue through all sections below.
  * **CPU-only:** Only the North-South fabric applies. Skip East-West, NVL, GPU server, and Server Cluster sections.

* If AI: is this an NVIDIA-based deployment, or a non-NVIDIA deployment?

  * **NVIDIA-based:** Specify which NVIDIA Reference Architecture version is being deployed (for example: RA 2.1, RA 2.2). The RA version determines the East-West technology (Spectrum-X Ethernet or Quantum InfiniBand), whether an NVL72 rack-scale fabric is present, the number of fabric tiers, Scalable Unit sizing, switch model requirements, and cabling standard. If InfiniBand is present, NVIDIA UFM is assumed (see :doc:`UFM Integration <netris-ufm-integration>`). If NVL72 is present, NVIDIA NMX is assumed (see :doc:`NVLink Integration <netris-nvlink-integration>`).
  * **Non-NVIDIA AI:** The East-West fabric is Ethernet-based. How many fabric tiers — leaf only, leaf/spine, or leaf/spine/super-spine?

Switch hardware
===============

* Which switch vendor(s) are you using? The vendor determines the network operating system. See the :doc:`Supported Platforms Matrix <supported-platform-matrix>` and :doc:`Supported Switch Hardware <supported-switch-hardware>` before ordering or committing to hardware. NOS image filenames per switch model are collected separately as part of ZTP preparation.
* Per fabric (East-West, North-South, OOB): specify the switch model and count for each role — leaf, spine, super-spine where applicable.
* **OOB management fabric:** Is the OOB fabric a logically isolated segment of the North-South fabric, or a physically separate fabric?

  * If separate: will the OOB fabric be managed by Netris, or operated outside Netris by the operator?

Servers and compute
===================

Server records are required to fully model the network in Netris. :doc:`Topology validation <monitoring-observability/topology-validation>`, wiring verification, and :doc:`Server Cluster <server-cluster>` automation are not available until servers are modeled in the :doc:`inventory <topology-management>`. Deployment can proceed without servers initially, but plan to supply a complete server list — hostname, NIC inventory, management IP — before those features can be used.

* **NVIDIA RA deployments:** How many Scalable Units (SUs)? The RA version determines the SU size (number of GPU servers per SU). Netris uses the SU count to calculate the rail-optimized East-West topology automatically.
* **Non-NVIDIA or custom deployments:** How many GPU servers? How many GPUs per server?
* How many NICs per server are connected to the North-South fabric? Typically two NICs bonded into an LACP bond (see :doc:`Link Aggregation <lag>`). In DPU-based deployments, the DPU uplink port replaces the host NICs on the North-South fabric.
* Is server management traffic carried over a dedicated management NIC (separate from the IPMI/BMC interface), or inband as part of the North-South LACP bond?
* Are NVIDIA BlueField DPUs present in servers connected to the North-South fabric? DPUs enable concurrent multi-tenancy (multiple tenants sharing a single server) by extending the EVPN/VXLAN fabric into the server in hardware. See :doc:`BlueField-3 DPUs <bluefield-3-dpus>`.

Scale and management network topology
======================================

* How many Netris-managed Ethernet switches in total across all fabrics?

  * Up to approximately 90 switches: the Direct-to-CMN (flat) topology is viable — switch management interfaces connect directly to the CMN.
  * More than 90 switches: the Hybrid OOB (hierarchical) topology is required — seed switches connect to the CMN and form the root of the OOB hierarchy.

  See :ref:`management_network_architecture` for the full design and topology diagrams.

* How many Sites — separate data centers or geographic regions to be managed from the same Netris Controller?
* Does the CMN already exist, or does it need to be built as part of this project?
* How will the CMN be accessed remotely? The CMN must remain reachable independently of the Netris-managed fabric — typically through a VPN gateway or bastion host connected directly to the CMN switches.

Multi-tenancy model
===================

The questions below determine the isolation model and scale. See :doc:`accounts` for how tenants and permission groups are modeled in Netris.

* What is the unit of tenancy?

  * **Exclusive tenancy** — the whole server is allocated to just one tenant at a time.
  * **Concurrent tenancy** — any given server can host more than one tenant simultaneously. Isolation must extend from the network fabric into the server itself.

* If concurrent tenancy: what is the host segmentation mechanism?

  * **DPU-based (HBN, Zero-Trust mode)** — isolation is enforced in hardware by BlueField DPUs outside the host OS. See :doc:`BlueField-3 DPUs <bluefield-3-dpus>`.
  * **EVPN-on-Host** — isolation is enforced in software by the Linux host networking stack. Suitable for control-plane nodes (Kubernetes control nodes, orchestration services, shared platform components). EVPN-on-Host is not recommended for high-traffic-volume workloads because traffic is software-switched. See :doc:`EVPN-on-Host <evpn-on-host>`.

* Are any control-plane hosts (for example, dedicated Kubernetes control nodes, one per tenant) expected to host concurrent multi-tenancy? If so, plan for EVPN-on-Host on those nodes.
* How many tenants initially? Anticipated maximum?
* What is the anticipated maximum VPC count? See :ref:`vpc_def` for how VPCs map to tenant isolation boundaries.
* What is the tenant IP addressing model?

  * **Uniform schema** — every tenant uses the same IP address schema (for example, every tenant's workload network is 10.0.0.0/24). VPCs provide the isolation that makes overlapping ranges safe. This is the most common model for GPU cloud operators who provision standard environments per tenant.
  * **Unique non-overlapping ranges** — each tenant receives a distinct IP allocation with no overlap. Required when tenants need direct Layer-3 reachability to each other or to shared services without NAT.
  * **Combination** — some tenants share a standard schema; others have unique allocations. Netris supports all three cases within the same deployment.

Network services
================

V-Nets
------

:doc:`V-Nets <vnet>` are the core segmentation construct. Identify which types you need.

* **L2VPN V-Nets** — Layer-2 switched segments, similar to a traditional VLAN with anycast gateway. Typically used for North-South and management networks.
* **L3VPN V-Nets** — Layer-3 routed, one /31 subnet per switch port. Used for East-West GPU cluster connectivity on Ethernet-based AI fabrics (Spectrum-X).
* **VLAN-aware V-Nets** — Q-in-Q mode carrying multiple VLAN tags within a single VXLAN. Used when endpoints require VLAN trunking.
* **Multi-site V-Nets** — a single V-Net spanning multiple Sites with shared or distinct subnets per site.
* **DHCP:** Do tenants need DHCP address assignment for workloads connected to L2VPN V-Nets? Netris can host DHCP on SoftGate or relay to an external DHCP server.

Server Clusters
---------------

:doc:`Server Clusters <server-cluster>` define tenant network boundaries by referencing a list of compute nodes rather than individual switch ports. Netris automatically provisions the required VPCs, V-Nets, IPAM subnets, InfiniBand PKeys (if InfiniBand is present), and NVLink partitions (if an NVL72 fabric is present) for all servers in the cluster.

* Will tenant network provisioning be driven by Server Clusters?
* What Server Cluster Template will be used? Templates are JSON objects that define V-Net types, IP addressing schemes, and AI fabric integration parameters.

Shared services access
----------------------

Tenants typically need access to shared infrastructure — storage systems, platform services, BCM — without direct connectivity between tenant VPCs.

* **VPC Peering** — controlled Layer-3 connectivity between two VPCs with prefix-list filtering. Recommended for shared storage access patterns. See :doc:`network-policies`.
* **VLAN subinterface access** — storage platform exposes logical interfaces directly into each tenant VPC. Simpler routing but constrained by the storage platform's interface limit.

Which model applies, or both?

External connectivity
---------------------

* How will the Netris-managed fabric connect to upstream ISPs, WAN routers, or external firewalls? eBGP peering (see :ref:`bgp_def` in :doc:`network-policies`) or static routes, or both?
* **On/off ramp model:** Is all inbound and outbound tenant traffic routed through SoftGate edge services (NAT and L4 load balancing), or is direct high-speed Layer-3 access also required — for example, a routed BGP connection from a switch port directly to an upstream router or firewall? Direct high-speed access uses the :doc:`VPC Connect <vpc-connect>` feature. If VPC Connect is needed, identify which switch ports and which upstream devices.

Link aggregation
----------------

* What link aggregation model applies to servers connected to the North-South fabric? See :doc:`Link Aggregation <lag>`.

  * **Automatic LAG with EVPN Multi-Homing** — Netris detects LACP on the server side and automatically forms an all-active LAG across a two-switch EVPN-MH domain. Ensure your switching hardware supports your desired LAG method.
  * **MC-LAG** — vendor-specific multi-chassis LAG with peer-link configuration.
  * **Custom LAG** — manual LAG configuration for hardware or topology combinations not covered by the automatic modes.

Edge services
=============

:doc:`Netris SoftGate <netris-softgate-HS>` is optional, but required for any of the following:

* SNAT — tenant workloads initiating outbound connections to the Internet or external networks.
* DNAT — inbound access to tenant workloads from external networks.
* L4 load balancing — a stable public endpoint distributing TCP or UDP traffic across backend workloads. See :doc:`L4 Load Balancer <l4-load-balancer>`.
* Elastic IPs — dynamically assignable public IP addresses per tenant.
* DHCP server hosted on SoftGate.

If SoftGate is needed:

* A minimum of four SoftGate nodes is required for high availability: two dedicated to SNAT (stateful, horizontally scalable), two dedicated to DNAT and L4 load balancing (stateless). Additional nodes can be added to either role independently.
* What physical servers will run SoftGate? SoftGate runs on dedicated bare-metal x86 servers at the edge of the North-South fabric.
* What is the upstream BGP ASN for SoftGate peering?
* What /30 peering subnet is allocated per SoftGate node for the uplink BGP session?
* What VLAN ID is assigned per SoftGate node for the uplink peering interface?
* Are health checks required on L4LB backends? If so: TCP connect, HTTP GET, or none?

Access control
==============

* What is the default ACL policy per Site? See :doc:`site` and :doc:`acls`.

  * **Permit** — all traffic between subnets is allowed unless explicitly denied. Suitable for open, trusted environments.
  * **Deny** — all traffic between subnets is blocked unless explicitly permitted (zero-trust model). Required for regulated or high-security deployments.

* Will cross-tenant ACL approval workflows be needed — for example, where a tenant requests access to another tenant's resources and the owner must approve? See :doc:`acls`.

Control infrastructure
======================

Control-plane systems need management-plane reachability to the servers and devices they manage. Their placement relative to the Netris-managed fabric determines which VPCs and V-Nets must be provisioned.

* Which control infrastructure systems will be present?

  * NVIDIA Base Command Manager (BCM) for node lifecycle management
  * Other node provisioning, imaging, or PXE boot systems
  * Kubernetes orchestrators or platform control planes
  * Remote access or bastion hosts
  * Firmware repositories

* For each: will it reside within the Netris-managed fabric (requiring a management VPC and V-Net), or outside the fabric (reaching managed nodes through external connectivity)?

* Which monitoring, telemetry, and observability systems will be present (for example: Prometheus, Grafana, DCIM systems, NVIDIA NetQ)?

* For each: inside the Netris-managed fabric, or outside? If NetQ is used for network validation, see :doc:`NVIDIA NetQ Integration <monitoring-observability/netq>`.

Integrations
============

* **Kubernetes** — is a Kubernetes operator integration required? The :doc:`Netris Kubernetes operator <kubernetes-integration>` provisions VPCs, V-Nets, and load balancers from Kubernetes manifests (CRDs) and supports Calico CNI integration.
* **Terraform** — will infrastructure-as-code workflows drive Netris configuration via the :doc:`Netris Terraform provider <terraform-integration>`?
* **CloudStack** — is CloudStack integration required? See :doc:`Netris-CloudStack Integration <cloudstack/netris-cloudstack>`.
* **SNMP** — does your monitoring stack require SNMPv2 polling of managed switches? Netris Inventory Profiles can configure SNMPv2 community strings and access controls per device.

IP addressing
=============

* What ASN will be used for the BGP underlay? A public ASN if you have one, or a private ASN in the range 64512–65534. See :doc:`site`.
* What VLAN ID range is available for dynamic assignment by Netris? The default range is 2–4094. If any IDs in that range are reserved by existing infrastructure, specify the contiguous range Netris can use.
* What IP address ranges are allocated for each of the following?

  * **East-West switch fabric loopbacks** — underlay BGP loopback subnet
  * **East-West switch fabric management interfaces** — subnet and default gateway (E-W management is typically served by the Netris-managed N-S fabric)
  * **North-South switch fabric loopbacks** — underlay BGP loopback subnet
  * **North-South switch fabric management interfaces** — subnet and gateway (N-S management is typically served by the non-Netris-managed OOB network)
  * **GPU server East-West point-to-point links** (Spectrum-X deployments) — a /16 or similarly sized pool from which Netris automatically assigns /31 subnets between GPU servers and leaf switches
  * **GPU server North-South frontend access** — subnet and default gateway for tenant VPC access
  * **Server BMC/IPMI management interfaces** — subnet and gateway
  * **Tenant VPC address space** — per-tenant allocation or a shared pool from which VPCs are carved. See :ref:`ipam_def_vpc` in :doc:`network-policies`.
  * **Public IP pool** — for elastic IPs, SNAT frontends, DNAT targets, and load balancer VIPs

* Are there overlapping address ranges between tenants that require separate VPCs?
* Does an existing IP address management system — for example, Infoblox — need to coexist or integrate with Netris IPAM?

Identity and access
===================

See :doc:`accounts` for the full RBAC model.

* Will Netris use local user accounts, or integrate with an enterprise identity provider (LDAPv3, LDAPS, or Microsoft Active Directory)?
* What RBAC roles are required?

  * Platform administrators — full access to all resources
  * Operations teams — scoped write access by tenant or section
  * Read-only observers or auditors
  * Tenant self-service — tenants provisioning their own VPCs and services through the Netris GUI, REST API, Kubernetes CRDs, or Terraform

* Who holds administrative access to the Netris Controller?
* Are there audit or compliance requirements that affect log retention or access policy? All API and GUI activity is captured in audit logs accessible via the controller API or GUI. See :doc:`visibility`.

Controller infrastructure
=========================

The Netris Controller runs on a minimum of three dedicated bare-metal nodes in a high-availability cluster. See :doc:`Supported Switch Hardware <supported-switch-hardware>` for controller hardware requirements at different scale levels.

* Are three dedicated bare-metal servers available for the controller cluster?
* What are the NIC specifications on those servers? The controller nodes require specific NIC configuration for HA communication and OOB connectivity. See :doc:`Controller Installation <installation/installation>` for hardware requirements.
* Reserve five IP addresses from the OOB management subnet before installation begins: one per controller node (three), one for the Kubernetes API VIP, and one for the Netris Controller VIP.
* What FQDN will resolve to the Netris Controller VIP? DNS must be configured before the controller is deployed.
* Is an air-gapped (offline) installation required? Netris supports fully air-gapped deployments — offline install packages can be provided.
* k3s (the default, bundled deployment) or an existing Kubernetes cluster?

Zero-touch provisioning preparation
=====================================

If you plan to use Zero-Touch Provisioning (ZTP) to onboard switches, prepare the following before deployment begins. See :doc:`ZTP <installation/ztp>`.

* Switch hostname schema and the complete hostname list
* MAC addresses of all switch management interfaces
* Management IP assignment per switch
* Loopback IP assignment per switch
* NOS image filename(s) for each switch model in the deployment — collected per switch via the :doc:`Inventory Profile <inventory-profile>` ZTP settings

Operational considerations
===========================

Plan for the following before Day 1.

* **Inventory Profiles** — define configuration baselines for managed switches, SoftGate nodes, and DPUs: management access allow-lists, BGP underlay mode (numbered or unnumbered), LAG mode, GPU cluster QoS and RoCE parameters, and ZTP settings. One profile can cover an entire fabric role (East-West, North-South, OOB). See :doc:`inventory-profile`.
* **Topology validation** — Netris continuously validates physical wiring against the topology declared in the controller using LLDP. Server wiring validation requires servers to be modeled and NIC-to-port mappings to be defined. See :doc:`monitoring-observability/topology-validation`.
* **Maintenance Mode** — plan for how switches and SoftGate nodes will be taken offline for maintenance without disrupting tenant traffic. See :doc:`maintenance-mode`.
* **Custom switch configuration** — if your switches run NVIDIA Cumulus Linux and require configuration beyond what Netris manages, :doc:`custom NVUE snippets <snippets>` can be deployed per device.
* **Backup and disaster recovery** — the Netris Controller supports full configuration export. Confirm backup policies and recovery workflows with your operations team.
* **Default credentials** — administrator credentials must be changed immediately after the controller is deployed.

What to read next
=================

With these questions answered, proceed to :doc:`Controller Installation <installation/installation>`.

If you want to walk through a complete working deployment before installing on real hardware, the :doc:`Try & Learn: GPU-as-a-Service network with NVIDIA Spectrum-X architecture <try-learn/nvidia-spectrum-x-scenario>` lab runs in a Netris simulation environment and exercises the fabric roles, vocabulary, and components covered in these docs.
