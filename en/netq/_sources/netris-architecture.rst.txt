.. meta::
    :description: Netris Architecture

.. _netris_architecture:

###################
Netris Architecture
###################

This page describes the components of a Netris deployment and how they fit together. Before reading further, make sure you are comfortable with the four AI data center fabric roles (North-South, East-West, NVL72, OOB) introduced on the :doc:`Introduction <introduction>` page — every section below assumes that vocabulary.

Core components (always present)
=================================

Every Netris deployment — whether you are running a traditional Ethernet data center, an enterprise AI factory, or a multi-tenant GPU cloud — includes three core components:

* **Netris Controller** — the platform brain. Stores user-defined services, policies, inventory, telemetry, and integration state. Runs in the customer's environment on dedicated bare metal hosts (minimum 3 nodes).

* **Netris Switch Agent** — software running on every Netris-managed switch. Translates controller intent into vendor-specific switch configuration and reports telemetry back to the controller over an outbound, encrypted gRPC channel.

* **Netris SoftGate** (VPC Gateway) — optional but adopted by 95% of Netris customers. A multi-tenant, horizontally scalable, XDP accelerated software edge that provides ingress and egress services for VPCs — elastic IPs, NAT, tenant-specific connectivity, and L4 load balancing — and runs on operator-provided bare-metal x86 servers at the edge of the North-South fabric.

These three components are present in every Netris deployment. If you are running a traditional data center without a GPU cluster, this is the whole picture.

AI components (additive, when a GPU cluster is present)
========================================================

If your deployment includes a GPU cluster — an East-West Ethernet backend fabric (e.g., NVIDIA Spectrum-X), an East-West Quantum InfiniBand backend fabric, an NVL72 rack-scale fabric, or BlueField DPUs in your servers — Netris adds the following components on top of the core platform:

* **NVIDIA BlueField DPUs** — managed by Netris as first-class network devices participating in the EVPN/VXLAN fabric for hard isolation (enforced on networking hardware) on the server itself. See :doc:`BlueField-3 DPUs <bluefield-3-dpus>`.

* **NVIDIA UFM integration** — for automated InfiniBand partition (PKey) management on Quantum backend fabrics. See :doc:`UFM Integration <netris-ufm-integration>`.

* **NVIDIA NMX integration** — for automated NVLink partition management on NVL72 rack-scale fabrics (GB200 NVL72 and GB300 NVL72). See :doc:`NMX Integration <netris-nvlink-integration>`.

* **Netris Host Networking (NHN) Plugin** — runs on GPU servers to configure IP addresses, routing, and RoCE parameters without requiring management network access.

* **EVPN-on-Host** — extends the EVPN control plane into standard Linux hosts for VM and container tenant isolation. See :doc:`EVPN-on-Host <evpn-on-host>`.

None of these AI components stand alone. Each plugs into the core Controller / Switch Agent / SoftGate platform and is configured through the same web console, REST API, Kubernetes CRDs, or Terraform provider as the rest of the network.

.. _netris_controller_def:

Netris Controller
=================

The Netris Controller is the central operations point of a Netris deployment. Engineers interact with it through the web console, REST API, or Kubernetes integration; network devices and external systems (Kubernetes, Terraform, etc.) connect through the same API and through gRPC. The Controller stores user-defined network services and policies, inventory, health and telemetry from the network, and integration state. The Netris Controller runs on customer premises on dedicated bare-metal hosts (minimum 3 nodes).

.. image:: images/netris_controller_diagram.png
    :align: center
    :class: with-shadow

.. raw:: html

   <p style="text-align: center;"><em>Figure: High-level Netris architecture</em></p>

  
* **Dedicated Controller Management Network (CMN).** The Netris Controller runs on a dedicated Controller Management Network (CMN). The CMN is a physically separate, non-Netris-managed network and is not one of the four AI data center fabric roles introduced on the :doc:`Introduction <introduction>` page (North-South, East-West, NVL72, OOB). Running the controller on the CMN prevents a circular dependency between the controller and the fabrics that the controller manages. See :ref:`management_network_architecture` below for details.

* **Multi-site from a single controller.** Netris fully supports multi-site deployments managed from a single Netris Controller HA cluster. A separate controller per site is not required.

* **What if the controller is unreachable.** The Netris Controller is an automation control plane — it provisions and updates infrastructure configuration, but once that configuration is applied, network devices enforce policies and forwarding behavior independently. Every Netris agent caches the operator-defined intent received from the controller and locally generates and continues to enforce the appropriate configuration even if the controller becomes unreachable. Switches continue forwarding traffic, tenant isolation remains enforced by the hardware, and previously applied configuration remains active. Only new configuration changes and telemetry collection are suspended until the controller is restored.

.. _netris_sw_agent:

Netris Switch Agent
===================

Netris Switch Agent is software running in the user space of the network operating system (NOS) of the switch and is responsible for automatically generating the appropriate switch configuration according to service requirements and policies defined in the Netris Controller. Netris Switch Agent uses an encrypted gRPC channel for secure communication with the Netris Controller.

Infrastructure devices managed by Netris establish **outbound** connections to the controller. The controller does not initiate connections to switches or other managed devices. Devices connect to the controller to retrieve configuration updates and publish operational status (port state, system events, telemetry). This communication model minimizes the network exposure of infrastructure devices and reduces the attack surface associated with device management.

.. _netris_sg_agent:

Netris SoftGate
===============

Netris SoftGate (also known as VPC Gateway) is a multi-tenant, horizontally scalable edge gateway for cloud providers. SoftGate provides elastic IPs, NAT, tenant-specific connectivity, and L4 load balancing — complementing physical network multi-tenancy with cloud networking functionality that switches alone cannot provide. The SoftGate software runs on a dedicated set of operator-provided bare-metal x86 servers at the edge of the Netris-managed North-South fabric. 95% of Netris customers have opted to add SoftGate to their Netris-managed switch fabrics.

You can learn more about SoftGate architecture and deployment scenarios in the :doc:`Netris SoftGate HS <netris-softgate-HS>` document.

.. _management_network_architecture:

Management Network Architecture
================================

Netris deployments use dedicated management networks that separate automation infrastructure from tenant data-plane traffic.

**Management networks.** A typical deployment includes two management networks:

* **Controller Management Network (CMN):** A physically separate, statically configured, non-Netris-managed management network (typically two switches). CMN provides connectivity between Netris Controller nodes and seed switches, when present (see the definition below). Supports controller cluster communication, bootstrap operations, and infrastructure onboarding. Because the CMN exists outside of the Netris-managed infrastructure, organizations can secure it using their preferred enterprise security controls (network segmentation, bastion hosts, VPN access, etc.). The CMN is typically not managed by Netris itself to prevent circular dependencies.

* **Seed switches.** A set of 2 to 6 Netris-managed switches provisioned before any other Netris-managed switches. Seed switches connect directly to CMN and form the root of the OOB management hierarchy in larger deployments. Whether seed switches are used depends on the deployment topology described below.

* **Out-of-Band Management Network (OOB):** A management aggregation network composed of OOB switches. The OOB network hosts management connectivity for Netris-managed network fabrics. In many deployments, the OOB network also hosts management connectivity for Server Management Interfaces (SMI), Data Processing Units (DPUs), Infrastructure Control Platforms (ICP), InfiniBand (IB) switches, NVLink switches, and Data Center Infrastructure Management (DCIM) systems. The OOB network may be implemented as part of the North–South fabric or as a standalone network fabric and can be Netris-managed or operator-managed (not Netris-managed) depending on the operator's objectives.

**Deployment topologies.** Building on the management networks above, Netris supports two physical topologies for connecting Netris-managed switches to the controller:

* **Direct-to-CMN (flat).** All Netris-managed switches connect their management interfaces directly to the CMN. No seed switches are required. Suitable for smaller deployments where the CMN has enough front-panel ports for every Netris-managed switch — typically up to about 90 Netris-managed switches.

* **Hybrid OOB (hierarchical).** A small set of seed switches connects directly to the CMN and forms the root of an OOB management hierarchy. The remaining Netris-managed switches connect their management interfaces to the OOB network rather than to the CMN. Used in larger deployments where the number of Netris-managed switches exceeds the CMN's port capacity.

.. image:: images/Hybrid-Management-Network-RA.svg
    :alt: Hybrid management network architecture with separate CMN
    :align: center
    :class: with-shadow

.. raw:: html

   <p style="text-align: center;"><em>Figure: Hybrid OOB (hierarchical) management network architecture with separate CMN</em></p>


The choice of topology affects only the physical management plane. The Netris Controller, the four fabric roles, and the security model are identical in both cases.

This separation ensures that automation infrastructure does not become a dependency for tenant data traffic. Tenant data traffic forwarding continues even if management networks become unavailable.

.. _security_design:

Security Design Principles
===========================

Netris is built on the following security design principles:

* **Control Plane Independence:** Once configuration is applied, network devices enforce policies independently of the controller. Loss of the controller does not disrupt tenant traffic or compromise isolation.

* **Hard isolation (enforced on networking hardware):** Tenant isolation is implemented through the underlying infrastructure hardware -- VRF, VXLAN, and ACLs in Ethernet fabrics; InfiniBand partition keys (PKeys); and NVLink GPU fabric partitions. Netris automates the provisioning of these mechanisms and does not rely on software overlays for tenant separation.

* **Customer-Controlled Security Boundary:** Because the Netris Controller is deployed within the customer's environment, organizations retain full control over the security perimeter. Netris does not offer hosted control planes.

* **Audit Logging:** All requests processed by the Netris API are logged. Because the web GUI operates through the same API, UI activity is also captured in the audit logs. Logs can be retrieved programmatically through the controller API or inspected in the GUI. See :doc:`visibility` for details.

.. _shared_responsibility:

Shared Responsibility
======================

Security of the overall infrastructure environment is a shared responsibility between the Netris platform and the organization operating the deployment.

**Netris provides:**

* Role-based access control (:doc:`accounts`)
* Infrastructure configuration enforcement
* Audit logging (:doc:`visibility`)
* Tenant isolation orchestration across Ethernet, InfiniBand, and NVLink fabrics
* Device management hardening via :doc:`Inventory Profiles <inventory-profile>`

**Organizations deploying Netris are responsible for:**

* Securing access to the controller environment (physical access, network segmentation, VPN, bastion hosts)
* Protecting management networks (CMN and OOB)
* Maintaining infrastructure operating systems and device firmware
* Integrating the platform with enterprise identity providers (LDAP, Active Directory)
* Changing default credentials after initial deployment
* Backup and disaster recovery procedures

.. _architecture_what_next:

What to read next
==================

With the architecture in mind, the natural next step is to see Netris in action. Open the :doc:`Try & Learn: GPU-as-a-Service network with NVIDIA Spectrum-X architecture <try-learn/nvidia-spectrum-x-scenario>` lab. The scenario runs in a Netris simulation environment — no real switches or GPU servers required — and walks through a complete deployment that exercises the four fabric roles, the vocabulary, and the components introduced above.

If you have already acquired Netris and are ready to deploy on real hardware, go to :doc:`Controller Installation <installation/installation>`. If you want to confirm hardware support first, see the :doc:`Supported Platforms Matrix <supported-platform-matrix>` and :doc:`Supported Switch Hardware <supported-switch-hardware>`.
