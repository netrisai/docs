.. meta::
    :description: Planning a Netris Deployment

.. _deployment_planning:

==========================
Planning Your Deployment
==========================

A Netris deployment requires a set of design decisions that must be resolved before installation begins. This page lists those decisions as questions, organized by topic. Your answers determine which Netris components apply to your environment, how the management network is structured, what controller infrastructure you need, and what must be in place before Day 1.

The Netris customer success team works through deployment design with you — you do not need to resolve every question independently. What you need before that conversation is a clear picture of your environment and your operational requirements.

Fabric scope
============

The fabrics present in your environment determine which Netris components apply.

* Which fabric types are present?

  * North-South (frontend) Ethernet fabric
  * East-West (backend) Ethernet fabric — e.g., NVIDIA Spectrum-X
  * East-West InfiniBand fabric — NVIDIA Quantum
  * NVL72 or NVL144 rack-scale NVLink fabric — NVIDIA GB200/GB300 NVL72 or GB300 NVL144 systems
  * NVIDIA BlueField DPUs in servers

* Which NOS (network operating system) do your switches run? — NVIDIA Cumulus Linux, SONiC (Dell, EdgeCore, or BCM-SONiC), or Arista EOS. See the :doc:`Supported Platforms Matrix <supported-platform-matrix>` before ordering or committing to hardware.
* If InfiniBand is present: is NVIDIA UFM already deployed, or will it be deployed as part of this project?
* If NVL72 or NVL144 is present: is NVIDIA NMX already deployed, or will it be deployed as part of this project?

Scale
=====

Deployment scale determines the management network topology.

* How many Netris-managed Ethernet switches in total, across all fabrics (spines, leaves, OOB switches, SoftGate nodes)?

  * Up to approximately 90 switches: the Direct-to-CMN (flat) topology is viable — managed switch management interfaces connect directly to the CMN.
  * More than 90 switches: the Hybrid OOB (hierarchical) topology is required — seed switches connect to the CMN, and the remaining switches connect through the OOB hierarchy.

* How many GPU servers?
* How many Sites — separate data centers or geographic regions managed from the same Netris Controller?

Multi-tenancy model
===================

Your tenancy model determines isolation requirements and which host-level Netris components apply.

* Single-tenant or multi-tenant deployment?
* If multi-tenant: what is the unit of tenancy?

  * **Exclusive tenancy** — each tenant is allocated whole bare-metal servers. All GPUs on an assigned server belong to one tenant at a time.
  * **Concurrent tenancy** — multiple tenants share a single physical server simultaneously. Isolation must extend from the network fabric into the host.

* If concurrent tenancy: do your servers have NVIDIA BlueField DPUs configured in Zero-Trust mode? DPU-based host segmentation (HBN) enforces isolation in hardware outside the host OS.
* If concurrent tenancy without DPUs: will VMs or containers be the workload model? Software-based host segmentation (EVPN-on-Host) can be used in this case.
* How many tenants initially, and what is the expected growth rate?

Edge services
=============

Netris SoftGate is optional, but required if any of the following apply:

* Tenant workloads need to initiate outbound connections to the Internet or to external networks (SNAT).
* Tenant workloads need to be reached from external networks (DNAT).
* A stable public endpoint is needed to distribute traffic across tenant backend workloads (L4 load balancing).
* Dynamically assignable public IP addresses per tenant (elastic IPs) are required.

If SoftGate is needed:

* How many SoftGate nodes? SoftGate scales horizontally; two nodes is the minimum for redundancy.
* What physical servers will run SoftGate? SoftGate runs on dedicated bare-metal x86 servers at the edge of the North-South fabric.

Management network
==================

The management network architecture is a foundational design decision. See :ref:`management_network_architecture` for the full design and the two supported topologies.

* Does an OOB management network already exist in this environment? If so:

  * Is it managed by another automation platform, or operator-managed?
  * Will Netris take over management of the OOB, or will it remain outside Netris?

* Will the OOB be implemented as a standalone fabric, or as a logically isolated segment of the North-South fabric?
* How will the CMN be accessed remotely? The CMN must remain reachable independently of the Netris-managed fabric — typically through a VPN gateway or bastion host connected directly to the CMN switches.
* Does the CMN already exist, or does it need to be built as part of this project?
* Who is responsible for the CMN physically? (The CMN switches are not Netris-managed and are configured manually.)

IP addressing
=============

* What ASN will be used for the BGP underlay? A public ASN if you have one, or a private ASN in the range 64512–65534.
* What IP address ranges are allocated for:

  * Switch and SoftGate management interfaces
  * BGP underlay loopback addresses
  * Tenant VPC address space (per-tenant or pooled)
  * Public IP pool — for elastic IPs, NAT frontends, and load balancer VIPs

* Are there overlapping address ranges between tenants that require separate VPCs?
* Does an existing IP address management system — for example, Infoblox or similar — need to coexist or integrate with Netris IPAM?

VPC and tenancy design
======================

* How will VPCs map to tenants or environments? Common patterns: one VPC per tenant, one VPC per environment (production/staging), a shared services VPC alongside per-tenant VPCs.
* Does the management plane need to be segmented by function? For example: separate VPCs for network device management, server management interfaces, and orchestration tooling.
* Do tenants need access to shared services such as storage systems?

  * If so: VPC peering (recommended for most storage access patterns) or VLAN subinterface access on the storage platform?

* How will external connectivity be implemented — eBGP to upstream ISP or WAN routers, static routes, or both?
* What is the default ACL policy? Permit all inter-tenant traffic unless explicitly denied (permissive default), or deny all unless explicitly permitted (zero-trust default)?

Identity and access
===================

* Will Netris use local user accounts, or integrate with an enterprise identity provider (LDAPv3, LDAPS, or Microsoft Active Directory)?
* What RBAC roles are required?

  * Platform administrators with full access
  * Operations teams with scoped write access
  * Read-only observers or auditors
  * Tenant self-service — tenants provisioning their own VPCs and services through the Netris API or Kubernetes CRDs

* Who holds administrative access to the Netris Controller?
* Are there audit or compliance requirements that affect log retention or access policy?

Controller infrastructure
=========================

The Netris Controller runs on a minimum of three dedicated bare-metal nodes in a high-availability cluster.

* Are three dedicated bare-metal servers available for the controller cluster?
* What are the NIC specifications on those servers? The controller nodes require specific NIC configuration for HA communication and OOB connectivity. See :doc:`Controller Installation <installation/installation>` for hardware requirements.
* Is an air-gapped (offline) installation required? Netris supports fully air-gapped deployments — offline install packages can be provided.
* k3s (the default, bundled deployment) or an existing Kubernetes cluster?

Integrations
============

* **Kubernetes** — is a Kubernetes integration required? If so, which distribution? The Netris Kubernetes operator provisions VPCs, V-Nets, and load balancers from Kubernetes manifests.
* **Terraform** — will infrastructure-as-code workflows drive Netris configuration via the Netris Terraform provider?
* **NVIDIA Base Command Manager (BCM)** — does BCM need management-plane reachability to Netris-managed servers? If so, plan for a dedicated management VPC with VPC peering to tenant environments. See :doc:`BlueField-3 DPUs <bluefield-3-dpus>` for DPU-specific integration.
* **Existing DCIM or monitoring systems** — which systems need to coexist on the OOB network, and does any integration with the Netris API need to be planned at this stage?

Organizational requirements
============================

The following are the operator's responsibility in the Netris shared responsibility model. Confirm your organization has addressed these before deployment.

* **Remote access to the CMN** — a dedicated access path (VPN gateway, bastion host) to the CMN that does not depend on the Netris-managed fabric.
* **Backup and disaster recovery** — the Netris Controller supports configuration export. Confirm backup policies and recovery workflows are planned.
* **Default credentials** — administrative credentials must be changed immediately after the controller is deployed.
* **Infrastructure OS and firmware** — a process for maintaining operating systems and firmware on controller nodes and managed devices.

What to read next
=================

With these questions answered, proceed to :doc:`Controller Installation <installation/installation>`.

If you want to walk through a complete working deployment before installing on real hardware, the :doc:`Try & Learn: GPU-as-a-Service network with NVIDIA Spectrum-X architecture <try-learn/nvidia-spectrum-x-scenario>` lab runs in a Netris simulation environment and exercises the fabric roles, vocabulary, and components covered in these docs.
