=================================================
Netris Supported Functionality & Platforms Matrix
=================================================

Switch Fabric Management Functions
==================================
.. list-table::
   :header-rows: 1

   *  - Function
      - Description
      - NVIDIA Cumulus
      - Dell SONiC

        BCM-SONiC
      - Arista EOS
      - EdgeCore SONiC
   *  - Fabric Manager
      - Day0, Day1, and Day2 switch fabric operations.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - North-South (frontend) Fabric
      - Manage switches in the North-South fabric.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - East-West (backend/scale out) Fabric*
      - Manage switches in East-West Ethernet-based fabrics including multi-plane deployments.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - Out-of-Band (management) Fabric
      - Manage switches in the Out-of-Band fabric.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - Topology Manager
      - Design and operate the switch fabric.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - Maintenance Mode
      - Offload a network node for a maintenance.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - :doc:`IPAM (IP Address Management) </ipam>`
      - Manage IP subnets. Assign RBAC, multi-tenancy, and service-based rules and roles to IP address resources.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - Looking Glass
      - Lookup underlay and overlay routing info of any managed network node without SSH-ing.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - BGP Unnumbered
      - Any network topology with BGP unnumbered underlay
      - ✔
      - ✔
      - ✔
      - ✔
   *  - BGP Numbered
      - Any network topology with BGP numbered underlay
      - ✔
      - ✔
      - ✔
      - ✔
   *  - VXLAN/EVPN
      - VXLAN over BGP/EVPN switch fabric
      - ✔
      - ✔
      - ✔
      - ✔
   *  - AI switch fabric
      - Optimizations for AI workloads. See AI functions section below.
      - ✔
      - TBD
      - ✔
      - ✔
   *  - :doc:`/installation/ztp`
      - Zero-touch provisioning of the NOS & Netris agent
      - ✔
      - Coming Soon
      - Coming Soon
      - TBD
   *  - Upgrade/Downgrade
      - Upgrade & Downgrade of Netris agent through the controller
      - Coming Soon
      - TBD
      - TBD
      - Coming Soon
   *  - Custom Config Snippets
      - Custom configuration snippets for unique use cases.
      - Coming Soon
      - Coming Soon
      - Coming Soon
      - Coming Soon   
   *  - :ref:`SNMPv2 polling <snmp_settings>`
      - Enable SNMPv2 server.
      - ✔
      - ✔
      - ✔
      - TBD

\* Netris also integrates with NVIDIA UFM and NVIDIA NMX-C to automate partition management across NVIDIA Quantum InfiniBand and NVL72 fabrics.

Host Networking
=============================================

.. list-table::
   :header-rows: 1

   *  - Function
      - Description
      - NVIDIA Cumulus
      - Dell-SONiC

        BCM-SONiC
      - Arista EOS
      - EdgeCore-SONiC
   *  - :doc:`HBN (Host Based Networking) for BlueField DPUs </bluefield-3-dpus>`
      - Extend the EVPN/VXLAN fabric into BlueField DPUs for hardware-enforced tenant isolation at the server level.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - :doc:`Compute VXLAN/EVPN extension (EOH) </evpn-on-host>`
      - Extend VXLAN/EVPN fabric into compute layer. See Compute integrations section below.
      - ✔
      - ✔
      - TBD
      - TBD   

Monitoring & Telemetry
==================================
.. list-table::
   :header-rows: 1

   *  - Function
      - Description
      - NVIDIA Cumulus
      - Dell SONiC

        BCM-SONiC
      - Arista EOS
      - EdgeCore SONiC
   *  - :doc:`Monitoring: Switch Ports</monitoring-observability/healthchecks>`
      - Automatic monitoring of Link statuses, link utilization, laser signal levels, temperature, errors, packets, transceiver presence.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - :doc:`Monitoring: Resources</monitoring-observability/healthchecks>`
      - Automatic monitoring of CPU, RAM, Disk, and ASIC resources.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - :doc:`Monitoring: Sensors</monitoring-observability/healthchecks>`
      - Automatic monitoring of temperature, fans, power supply statuses.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - :doc:`Monitoring: System Processes</monitoring-observability/healthchecks>`
      - Automatic monitoring of critical system processes.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - :doc:`Topology Validation </monitoring-observability/topology-validation>`
      - Detect wiring errors switch-to-switch & switch-to-SoftGate.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - :doc:`Server Wiring Validation</monitoring-observability/topology-validation>`
      - Detect wiring errors switch-to-server.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - :doc:`NVIDIA NetQ integration </monitoring-observability/netq>`
      - Activate NVIDIA NetQ Blueprint through Netris topology
      - ✔
      - N/A
      - N/A
      - N/A

See :doc:`monitoring-observability/healthchecks` for more details on monitoring and telemetry features.

External Routing Functions
==========================

.. list-table::
   :header-rows: 0

   *  - Function
      - Description
      - NVIDIA Cumulus
      - Dell-SONiC

        BCM-SONiC
      - Arista EOS
      - EdgeCore-SONiC
   *  - External BGP (SoftGate)
      - Terminate full routing table on SoftGate  Gateway-server.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - External BGP (Switch)
      - Peer with external routers.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - BGP Route-Maps
      - Create chain of BGP rules.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - Static Routes
      - Define static routing rules.
      - ✔
      - ✔
      - ✔
      - ✔



Cloud Networking Functions & Constructs
=======================================

.. list-table::
   :header-rows: 0

   *  - Function
      - Description
      - NVIDIA Cumulus
      - Dell-SONiC

        BCM-SONiC
      - Arista EOS
      - EdgeCore-SONiC
   *  - VPC (Virtual Private Cloud)
      - Isolated VPCs, VRFs. Overlapping IPs supported.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - :doc:`V-Net (Subnet)<vnet>`
      - L3VPN VXLAN or L2VPN VXLAN with an anycast default Gateway, and built-in DHCP.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - :doc:`Server Cluster (Profiling) </server-cluster>`
      - Create network constructs template, then apply it on groups of servers.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - Internet Gateway
      - Provide shared Internet access to V-Nets and VPC
      - ✔
      - ✔
      - ✔
      - ✔
   *  - NAT Gateway
      - Provide shared DNAT, PAT, 1:1 NAT to multiple V-Nets and multiple VPCs
      - ✔
      - ✔
      - ✔
      - ✔
   *  - :doc:`L4 Load Balancer</l4-load-balancer>`
      - Provide on-demand elastic load balancer service to hosts in multiple V-Nets and multiple VPCs
      - ✔
      - ✔
      - ✔
      - ✔
   *  - Subnet Global Routing
      - Enable Internet Routing between a custom VPC and a System VPC on a per-subnet basis. SoftGate HS only
      - ✔
      - ✔
      - ✔
      - ✔
   *  - VPC Peering
      - Enable peering (route-leaking) between VPCs.
      - ✔
      - ✔
      - ✔
      - ✔

.. _overlay-network-functions:

Overlay Network Functions
==========================
.. list-table::
   :header-rows: 0

   *  - Function
      - Description
      - NVIDIA Cumulus
      - Dell-SONiC

        BCM-SONiC
      - Arista EOS
      - EdgeCore-SONiC
   *  - :doc:`L2VPN VXLAN VLAN Aware<vnet>`
      - L2VPN VXLAN with VLAN tagged or untagged termination on switch port.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - :doc:`L2VPN VXLAN VLAN Unaware<vnet>`
      - L2VPN VXLAN with VLAN tagged or untagged termination on switch port supporting different VLAN IDs on different end points.
      - N/A
      - N/A
      - ✔
      - N/A
   *  - :doc:`L3VPN VXLAN<vnet>`
      - L3VPN VXLAN, Commonly used in high performance computing, such as AI clusters.
      - ✔
      - ✔
      - TBD
      - ✔
   *  - :doc:`EVPN-MH / VXLAN-ESI <lag>`
      - EVPN MultiHoming based on VXLAN and ESI for automatic Active-Active server network multihoming
      - ✔
      - ✔
      - ✔
      - TBD
   *  - :doc:`LACP <lag>`
      - Link Aggregation or Active-Standby server multihoming.
      - ✔
      - ✔
      - ✔
      - TBD
   *  - :doc:`MC-LAG <lag>`
      - Traditional MC-LAG-based server multihoming
      - ✔
      - TBD
      - TBD
      - TBD


AI Specific Functions
=====================
.. list-table::
   :header-rows: 0

   *  - Function
      - Description
      - NVIDIA Cumulus
      - Dell-SONiC

        BCM-SONiC
      - Arista EOS
      - EdgeCore-SONiC
   *  - Spectrum-X
      - Switch-fabric management and automation optimized for NVIDIA Spectrum-X architecture
      - ✔
      - N/A
      - N/A
      - N/A
   *  - Rail-optimized topology
      - Switch-fabric management and automation optimized for rail-optimized fabrics
      - ✔
      - ✔
      - ✔
      - ✔
   *  - QoS for RoCE
      - Enable QoS for RoCE based on best practices
      - ✔
      - TBD
      - ✔
      - ✔
   *  - RoCE Adaptive Routing
      - Enable RoCE adaptive routing based on best practices
      - ✔
      - TBD
      - ✔
      - ✔
   *  - RoCE Congestion Control
      - Enable automatic congestion control for RoCE workloads
      - ✔
      - N/A
      - ✔
      - N/A
   *  - RoCE and QoS fine tuning
      - Allow fine tuning of QoS and other RoCE specific parameters
      - N/A
      - TBD
      - ✔
      - N/A
   *  - SuperNIC auto-configuration for RoCE
      - Automatically configure IP addresses, routing, RoCE and other SuperNIC specific configuration on GPU servers
      - ✔
      - TBD
      - TBD
      - TBD


Compute Platform Integrations
=================================
.. list-table::
   :header-rows: 0

   *  - Function
      - Description
      - NVIDIA Cumulus
      - Dell-SONiC

        BCM-SONiC
      - Arista EOS
      - EdgeCore-SONiC
   *  - Kubernetes Operator
      - Automatically serve Kubernetes LoadBalancer Type service
      - ✔
      - ✔
      - ✔
      - ✔
   *  - :doc:`Apache Cloud Stack<cloudstack/netris-cloudstack>`
      - Netris VXLAN isolation & VR replacement
      - ✔
      - ✔
      - TBD
      - TBD
   *  - VMware VSphere
      - Automatically provision VSphere defined VLANs in VXLAN/EVPN switch fabric
      - ✔
      - ✔
      - ✔
      - ✔


Security
========
.. list-table::
   :header-rows: 0

   *  - Function
      - Description
      - NVIDIA Cumulus
      - Dell-SONiC

        BCM-SONiC
      - Arista EOS
      - EdgeCore-SONiC
   *  - :doc:`Network ACLs</acls>`
      - Centralized Network Access Control Lists.
      - ✔
      - ✔
      - ✔
      - ✔
   *  - :doc:`Managed Device Profiling <inventory-profile>`
      - Managed switch & SoftGate protection from unwanted access, push administrative and system settings (NTP, DNS, timezone, etc.)
      - ✔
      - ✔
      - ✔
      - ✔
   *  - Audit Logs
      - Log all controller access and changes.
      - ✔
      - ✔
      - ✔
      - ✔


Netris Controller Administration
================================

.. list-table::
   :header-rows: 0

   *  - Function
      - Description
      - Globally
   *  - :doc:`Role Based Access Control <accounts>`
      - Who can view and edit which aspects of the system.
      - ✔
   *  - Tenant RBAC
      - Network resource delegation to tenants.
      - ✔
   *  - Active/Standby
      - Daily backup of Netris Controller on a Standby node
      - ✔
   *  - HA Controller
      - 3-node, HA Netris Controller cluster
      - ✔
   *  - :doc:`Air Gapped setup <installation/controller-k3s-air-gap-ha>`
      - Run Netris controller in Air Gapped environment and host switch & SoftGate software for local install.
      - ✔

Management Interfaces
=====================

.. list-table::
   :header-rows: 0

   *  - Function
      - Description
      - Globally
   *  - Web Console
      - Manage through intuitive web interface.
      - ✔
   *  - RestAPI
      - Integrate your other systems or your customer-facing portal with Netris consuming RestAPIs.
      - ✔
   *  - IaC: Terraform
      - Manage your infrastructure as a code using Terraform.
      - ✔

============================================
Netris and NOS versions compatibility matrix
============================================

.. note:: SoftGate PRO has been discontinued and superceded by SoftGate HS. The SoftGate PRO column is retained for reference by existing deployments on older Netris versions.

.. list-table::
   :header-rows: 0

   * - **Netris Version**
     - **Cumulus Linux**
     - **Dell BCM-SONiC**
     - **EdgeCore SONiC**
     - **Arista EOS**
     - **SoftGate PRO OS**
     - **SoftGate HS OS**
     - **Availability**
   * - 4.13.0
     - 5.11 - 5.14, 5.16 - 5.16.5
     - 4.5
     - 202211-331
     - 4.34.1F
     - N/A
     - Ubuntu 24.04
     - ✔
   * - 4.12.0
     - 5.11 - 5.14, 5.16
     - 4.5
     - 202211-331
     - 4.34.1F
     - N/A
     - Ubuntu 24.04
     - ✔
   * - 4.11.0
     - 5.11 - 5.14, 5.16
     - 4.5
     - 202211-331
     - 4.34.1F
     - N/A
     - Ubuntu 24.04
     - ✔
   * - 4.10.0
     - 5.11 - 5.14, 5.16
     - 4.5
     - 202211-331
     - 4.34.1F
     - N/A
     - Ubuntu 24.04
     - ✔
   * - 4.9.0
     - 5.11 - 5.14, 5.16
     - 4.5
     - 202211-331
     - 4.34.1F
     - N/A
     - Ubuntu 24.04
     - ✔
   * - 4.8.0
     - 5.11 - 5.14, 5.16
     - 4.5
     - 202211-331
     - 4.34.1F
     - N/A
     - Ubuntu 24.04
     - ✔
   * - 4.7.0
     - 5.11 - 5.13
     - 4.5
     - 202211-331
     - 4.34.1F
     - N/A
     - Ubuntu 24.04
     - ✔
   * - 4.6.0
     - 5.11 - 5.13
     - 4.5
     - 202211-331
     - 4.34.1F
     - N/A
     - Ubuntu 24.04
     - ✔
   * - 4.5.3
     - 5.11 - 5.13
     - 4.5
     - 202211-331
     - 4.34.1F
     - Ubuntu 20.04
     - Ubuntu 24.04
     - ✔
   * - 4.5.2
     - 5.11 - 5.13
     - 4.5
     - 202211-331
     - 4.34.1F
     - Ubuntu 20.04
     - Ubuntu 24.04
     - ✔
   * - 4.5.1
     - 5.11 - 5.13
     - 4.5
     - 202211-331
     - 4.34.1F
     - Ubuntu 20.04
     - Ubuntu 24.04
     - ✔
   * - 4.5.0
     - 5.11 - 5.13
     - 4.5
     - 202211-331
     - 4.34.1F
     - Ubuntu 20.04
     - Ubuntu 24.04
     - ✔
   * - 4.4.1
     - 5.11 - 5.13
     - 4.5
     - 202211-331
     - 4.34.1F
     - Ubuntu 20.04
     - Ubuntu 24.04
     - ✔
   * - 4.4.0
     - 5.11 - 5.13
     - 4.5
     - 202211-331
     - 4.34.1F
     - Ubuntu 20.04
     - Ubuntu 24.04
     - ✔
   * - 4.3.0
     - 5.9
     - 4.1
     - 12.3
     - N/A
     - Ubuntu 20.04
     - N/A
     - ✔
   * - 4.2.0
     - 5.9
     - 4.1
     - 12.3
     - N/A
     - Ubuntu 20.04
     - N/A
     - ✔
   * - 4.1.1
     - 5.7
     - N/A
     - 12.3
     - N/A
     - Ubuntu 20.04
     - N/A
     - ✔
   * - 4.0.0
     - 5.7
     - N/A
     - 12.3
     - N/A
     - Ubuntu 20.04
     - N/A
     - ✔
   * - 3.5.0
     - 5.7
     - N/A
     - 12.3
     - N/A
     - Ubuntu 20.04
     - N/A
     - ✔
   * - 3.4.1
     - 5.7
     - N/A
     - 12.3
     - N/A
     - Ubuntu 20.04
     - N/A
     - ✔

See :doc:`release-notes/index` for more details on Netris releases.