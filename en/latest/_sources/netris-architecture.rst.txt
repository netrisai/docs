.. meta::
    :description: Netris Architecture

.. _netris_architecture:

###################
Netris Architecture
###################

A Netris system is composed of the following core elements:

* Netris Controller
* Netris Switch Agent
* Netris SoftGate (VPC Gateway)

In AI networking environments, Netris also integrates with additional components:

* NVIDIA BlueField DPUs — managed as network devices participating in the EVPN/VXLAN fabric for hardware-enforced tenant isolation (see :doc:`BlueField-3 DPUs <bluefield-3-dpus>`)
* NVIDIA UFM — for automated InfiniBand partition (PKey) management (see :doc:`UFM Integration <netris-ufm-integration>`)
* NVIDIA NMX-C — for automated NVLink partition management on NVL72/NVL144 fabrics (see :doc:`NMX-C Integration <netris-nvlink-integration>`)
* Netris Host Networking (NHN) Plugin — runs on GPU servers to configure IP addresses, routing, and RoCE parameters without requiring management network access
* EVPN-on-Host — extends the EVPN control plane into standard Linux hosts for VM and container tenant isolation (see :doc:`EVPN-on-Host <evpn-on-host>`)

.. _netris_controller_def:

Netris Controller
=================

Netris Controller is the main operations control center for engineers using GUI/RestAPI/Kubernetes, systems, and network devices. The Netris Controller stores the data representing the user-defined network services and policies, health, statistics, analytics received from the network devices, and information from integration modules with external systems (Kubernetes, Terraform, etc.). Netris Controller can run on or off premises on bare-metal, as a VM, or as a container.

Diagram: High level Netris architecture

.. image:: images/netris_controller_diagram.png
    :align: center
  
* **Controller HA** We highly recommend running more than one copy of the controller for database replication. Learn more at :doc:`Controller Installation</installation/installation>`.
* **Multiple sites** Netris is designed to operate multiple sites with just a single controller with HA
* **What if the controller is unreachable.** The Netris Controller functions as an automation control plane -- it provisions and updates infrastructure configuration, but once that configuration is applied, network devices enforce policies and forwarding behavior independently. If the controller becomes temporarily unavailable, switches continue forwarding traffic, tenant isolation remains enforced by the hardware, and previously applied configuration remains active. Only new configuration changes and telemetry collection are suspended until the controller is restored.

.. _netris_sw_agent:

Netris Switch Agent
===================

Netris Switch Agent is software running in the user space of the network operating system (NOS) of the switch and is responsible for automatically generating the particular switch configuration according to service requirements and policies defined in the Netris Controller. Netris Switch Agent uses an encrypted gRPC channel for secure communication with the Netris Controller, accessible through a management network or over the Internet.

Infrastructure devices managed by Netris establish **outbound** connections to the controller. The controller does not initiate connections to switches or other managed devices. Devices connect to the controller to retrieve configuration updates and publish operational status (port state, system events, telemetry). This communication model minimizes the network exposure of infrastructure devices and reduces the attack surface associated with device management.

.. _netris_sg_agent:

Netris SoftGate
===============

SoftGate (also known as VPC Gateway) is an optional, multi-tenant (VPC-aware) software component designed for cloud providers. It provides ingress and egress connectivity services (NAT and L4LB) and scales horizontally. The SoftGate software runs on a dedicated set of operator-provided bare-metal x86 servers and is tightly integrated with the Netris-managed North-South fabric.

You can learn more about SoftGate architecture and deployment scenarios in the :doc:`Netris SoftGate HS <netris-softgate-HS>` document.

.. _management_network_architecture:

Management Network Architecture
================================

Netris deployments typically use dedicated management networks that separate automation infrastructure from tenant data-plane traffic. A typical deployment includes two management networks:

* **Controller Management Network (CMN):** Supports controller cluster communication, bootstrap operations, and infrastructure onboarding. Because the CMN exists outside of the Netris-managed infrastructure, organizations can secure it using their preferred enterprise security controls (network segmentation, bastion hosts, VPN access, etc.). The CMN is typically not managed by Netris itself to prevent circular dependencies.

* **Out-of-Band Management Network (OOB):** Provides operational management connectivity for infrastructure devices (switches, SoftGate nodes, DPUs) independent of tenant traffic flows.

This separation ensures that automation infrastructure does not become a dependency for production data traffic. Production traffic forwarding continues even if management networks become unavailable.

.. _security_design:

Security Design Principles
===========================

Netris is built on the following security design principles:

* **Control Plane Independence:** Once configuration is applied, network devices enforce policies independently of the controller. Loss of the controller does not disrupt tenant traffic or compromise isolation.

* **Hardware-Enforced Isolation:** Tenant isolation is implemented through the underlying infrastructure hardware -- VRF, VXLAN, and ACLs in Ethernet fabrics; InfiniBand partition keys (PKeys); and NVLink GPU fabric partitions. Netris automates the provisioning of these mechanisms but does not rely on software overlays for tenant separation.

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

* Securing access to the controller environment (network segmentation, VPN, bastion hosts)
* Protecting management networks (CMN and OOB)
* Maintaining infrastructure operating systems and firmware
* Integrating the platform with enterprise identity providers (LDAP, Active Directory)
* Changing default credentials after initial deployment
* Backup and disaster recovery procedures
