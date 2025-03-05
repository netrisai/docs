=================================================
Netris Supported Functionality & Platforms Matrix
================================================= 

Switch Fabric Management Functions
==================================
.. list-table:: 
   :header-rows: 0

   *  - Function	
      - Description	
      - NVIDIA Cumulus
      - Dell SONiC
      - Arista EOS
      - EdgeCore SONiC
   *  - Fabric Manager	
      - Day0, Day1, and Day2 switch fabric operations.	
      - ✔
      -  ✔
      - May/2025
      -  ✔
   *  - Parallel Fabrics
      - Manage multiple isolated switch fabrics. (example: East-West and North-South)
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - Topology Manager
      - Design and operate the switch fabric.
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - Maintenance Mode
      - Offload a network node for a maintenance.
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - IPAM
      - Manage IP subnets. Assign RBAC, multi-tenancy, and service-based rules and roles to IP address resources.
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - Looking Glass
      - Lookup underlay and overlay routing info of any managed network node without SSH-ing.
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - BGP Unnumbered
      - Any network topology with BGP unnumbered underlay
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - BGP Numbered
      - Any network topology with BGP numbered underlay
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - VXLAN/EVPN
      - VXLAN over BGP/EVPN switch fabric
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - AI switch fabric
      - Optimizations for AI workloads. See AI functions section below.
      -  ✔
      - TBD
      - TBD
      -  ✔
   *  - Compute VXLAN/EVPN extension
      - Extend VXLAN/EVPN fabric into compute layer. See Compute integrations section below.
      - Coming Soon
      -  ✔
      - TBD
      - TBD
   *  - ZTP
      - Zero-touch provisioning of the NOS & Netris agent
      - Coming Soon
      - TBD
      - TBD
      - Coming Soon
   *  - Upgrade/Downgrade
      - Upgrade & Downgrade of Netris agent through the controller
      - Coming Soon
      - TBD
      - TBD
      - Coming Soon


Monitoring & Telemetry
==================================
.. list-table:: 
   :header-rows: 0

   *  - Function	
      - Description	
      - NVIDIA Cumulus
      - Dell SONiC
      - Arista EOS
      - EdgeCore SONiC
   *  - Monitoring: Switch Ports
      - Automatic monitoring of Link statuses, link utilization, laser signal levels, errors, packets. 	
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - Monitoring: Resources
      - Automatic monitoring of CPU, RAM, Disk, and ASIC resources.
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - Monitoring: Sensors
      - Automatic monitoring of temperature, fans, power supply statuses.
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - Monitoring: System Processes
      - Automatic monitoring of critical system processes.
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - Topology Validation
      - Detect wiring errors switch-to-switch & switch-to-SoftGate.
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - Server Wiring Validation
      - Detect wiring errors switch-to-server.
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - NVIDIA NetQ integration
      - Activate NVIDIA NetQ Blueprint through Netris topology
      -  ✔
      - N/A
      - N/A
      - N/A

External Routing Functions
==========================

.. list-table:: 
   :header-rows: 0

   *  - Function
      - Description
      - NVIDIA Cumulus
      - Dell-SONiC
      - Arista EOS
      - EdgeCore-SONiC
   *  - External BGP (SoftGate)
      - Terminate full routing table on SoftGate  Gateway-server.
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - External BGP (Switch)
      - Peer with external routers.
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - BGP Route-Maps
      - Create chain of BGP rules.
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - Static Routes
      - Define static routing rules.
      -  ✔
      -  ✔
      - May/2025
      -  ✔



Cloud Networking Functions & Constructs
=======================================

.. list-table:: 
   :header-rows: 0

   *  - Function
      - Description
      - NVIDIA Cumulus
      - Dell-SONiC
      - Arista EOS
      - EdgeCore-SONiC
   *  - VPC (Virtual Private Cloud)
      - Isolated VPCs, VRFs. Overlapping IPs supported.
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - V-Net (Subnet)
      - L3VPN VXLAN or L2VPN VXLAN with an anycast default Gateway, and built-in DHCP.	
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - Server Cluster (Profiling)
      - Create network constructs template, then apply it on groups of servers. 
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - Internet Gateway
      - Provide shared Internet access to V-Nets and VPC
      -  ✔ 
      -  ✔
      - May/2025
      -  ✔
   *  - NAT Gateway
      - Provide shared DNAT, PAT, 1:1 NAT to multiple V-Nets and multiple VPCs
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - L4 Load Balancer
      - Provide on-demand elastic load balancer service to hosts in multiple V-Nets and multiple VPCs
      -  ✔ 
      -  ✔
      - May/2025
      -  ✔
   *  - Subnet Global Routing
      - Enable Internet Routing between a custom VPC and a System VPC on a per-subnet basis. SoftGate HS only
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - VPC Peering
      - Enable peering (route-leaking) between VPCs.
      - Mar/2025
      - May/2025
      - May/2025
      - Mar/2025
   *  - SiteMesh
      - Wireguard-based Site-to-Site VPN between multiple regions/sites. (single VPC)
      -  ✔
      -  ✔
      - May/2025
      -  ✔


Overlay Network Functions
==========================
.. list-table:: 
   :header-rows: 0

   *  - Function
      - Description
      - NVIDIA Cumulus
      - Dell-SONiC
      - Arista EOS
      - EdgeCore-SONiC
   *  - L2VPN VXLAN VLAN Aware
      - L2VPN VXLAN with VLAN tagged or untagged termination on switch port.
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - L2VPN VXLAN VLAN Unaware	
      - L2VPN VXLAN with VLAN tagged or untagged termination on switch port supporting different VLAN IDs on different end points.	
      - N/A
      - N/A
      - May/2025
      - N/A
   *  - L3VPN VXLAN
      - L3VPN VXLAN, Commonly used in high performance computing, such as AI clusters.
      -  ✔
      - TBD	
      - TBD
      -  ✔
   *  - EVPN-MH / VXLAN-ESI
      - EVPN MultiHoming based on VXLAN and ESI for automatic Active-Active server network multihoming
      -  ✔
      -  ✔
      - May/2025
      - TBD	
   *  - LACP
      - Link Aggregation or Active-Standby server multihoming.	
      -  ✔
      -  ✔	
      - May/2025
      - TBD
   *  - MC-LAG
      - Traditional MC-LAG-based server multihoming	
      -  ✔
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
      - Arista EOS
      - EdgeCore-SONiC
   *  - Spectrum-X
      - Switch-fabric management and automation optimized for NVIDIA Spectrum-X architecture
      -  ✔	
      - N/A
      - N/A
      - N/A
   *  - Rail-optimized topology
      - Switch-fabric management and automation optimized for rail-optimized fabrics
      -  ✔
      -  ✔
      -  ✔
      -  ✔
   *  - QoS for RoCE
      - Enable QoS for RoCE based on best practices
      -  ✔
      - TBD
      - TBD
      -  ✔
   *  - RoCE Adaptive Routing
      - Enable RoCE adaptive routing based on best practices
      -  ✔
      - TBD
      - TBD
      -  ✔
   *  - RoCE Congestion Control
      - Enable automatic congestion control for RoCE workloads
      -  ✔
      - N/A
      - N/A
      - N/A
   *  - RoCE and QoS fine tuning
      - Allow fine tuning of QoS and other RoCE specific parameters
      - N/A
      - TBD
      - TBD
      - Mar/2025
   *  - DPU/Host zero-touch configuration
      - Automatically configure IP addresses, routing, RoCE and other DPU/SuperNIC specific configuration on GPU servers
      -  ✔
      - TBD
      - TBD
      - TBD


Compute Platform Integrations
========
.. list-table:: 
   :header-rows: 0

   *  - Function
      - Description
      - NVIDIA Cumulus
      - Dell-SONiC
      - Arista EOS
      - EdgeCore-SONiC
   *  - Kubernetes Operator
      - Automatically serve Kubernetes LoadBalancer Type service
      -  ✔
      -  ✔
      -  ✔
      -  ✔
   *  - Apache Cloud Stack
      - Netris VXLAN isolation & VR replacement 
      - Mar/2025
      -  ✔
      - TBD
      - TBD
   *  - VMware VSphere
      - Automatically provision VSphere defined VLANs in VXLAN/EVPN switch fabric	
      -  ✔
      -  ✔
      -  ✔
      -  ✔


Security
========
.. list-table:: 
   :header-rows: 0

   *  - Function
      - Description
      - NVIDIA Cumulus
      - Dell-SONiC
      - Arista EOS
      - EdgeCore-SONiC
   *  - Network ACLs
      - Centralized Network Access Control Lists.
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - Managed Device Profiling
      - Managed switch & SoftGate protection from unwanted access, push administrative and system settings (NTP, DNS, timezone, etc.)
      -  ✔
      -  ✔
      - May/2025
      -  ✔
   *  - Audit Logs
      - Log all controller access and changes.	
      -  ✔
      -  ✔
      - May/2025
      -  ✔


Netris Controller Administration							
==============

.. list-table:: 
   :header-rows: 0
						
   *  - Function
      - Description
      - Globally					
   *  - Role Based Access Control
      - Who can view and edit which aspects of the system.
      -  ✔					
   *  - Tenant RBAC
      - Network resource delegation to tenants.
      -  ✔	
   *  - Active/Standby
      - Daily backup of Netris Controller on a Standby node
      -  ✔	
   *  - HA Controller
      - 3-node, HA Netris Controller cluster
      -  ✔
   *  - Air Gapped setup
      - Run Netris controller in Air Gapped environment and host switch & SoftGate software for local install.
      -  ✔
							
Management Interfaces	
=====================

.. list-table:: 
   :header-rows: 0
						
   *  - Function
      - Description
      - Globally		
   *  - Web Console
      - Manage through intuitive web interface.
      -  ✔					
   *  - RestAPI
      - Integrate your other systems or your customer-facing portal with Netris consuming RestAPIs.
      -  ✔					
   *  - IaC: Terraform
      - Manage your infrastructure as a code using Terraform.
      -  ✔					
							
							
Hypervisor/Worker node specific functionality
=============================================

.. list-table:: 
   :header-rows: 0
						
   *  - Function
      - Description
      - Kubernetes
      - Vmware
      - Apache Cloud Stack
      - OpenStack
      - Harvester
      - Proxmox
   *  - L4 Load Balancer
      - Layer-4 container or vm/server load balancer with health checks.
      -  ✔ (native & automatic)
      -  ✔ (need to specify backend IPs)
      -  ✔
      -  ✔ (need to specify backend IPs)
      -  ✔ (need to specify backend IPs)	
      -  ✔ (need to specify backend IPs)
   *  - VPC to internal routing peering
      - Automatically route internal networks into VPC routing table (allow containers communicate with VMs).
      -  ✔
      - N/A	
      -  ✔
      - TBD
      - TBD
      - TBD
   *  - Automatic VXLAN/VLAN
      - Automatically provision VXLAN/VLAN on switch fabric and include appropriate switch ports when virtual network is created in the hypervisor.	
      - TBD
      -  ✔
      -  ✔
      - TBD
      - TBD
      - TBD
   *  - HBN	Host-based networking. 
      - Terminate VTEPs on the hypervisor host. Scale beyond VLAN limits
      - Dec/2024
      - TBD
      -  ✔
      - TBD
      - TBD
      - TBD
   *  - HBN on DPU
      - Host-based networking. Terminate VTEPs on the hypervisor host DPU. Scale beyond VLAN limits with accelerated performance
      - 2025
      - TBD
      - 2025
      - 2025
      - TBD
      - TBD			

==============================
SoftGate Data Plane Variations
==============================

SoftGate is Netris data plane for Internet Gateway, NAT Gateway, Network Access Control, Elastic Load Balancer, and Site-to-Site VPN functions.											

.. list-table:: 
  :header-rows: 0

  * 	- Flavor
	- Common Use Case
	- Availability
	- Tenancy/VPC
	- Handoff
	- Packet Forwarding
	- HA & Scalability
	- Ethernet Environment
	- NIC	
	- CPU
	- RAM
	- Disk
	- Performance (w/ 100 NAT rules)
  *     - SoftGate
	- Bare metal cloud site, Edge site, Remote office.
	-  ✔
	- Single
	- VLAN
	- Linux w/ Netris optimizations
	- Active/Standby - 2 nodes
	- Dot1q: Equinix Metal, PhoenixNAP, pre-configured VLAN-range on any Ethernet switches.
	- Any
	- Intel or AMD
	- 16-64GB
	- 300GB
	- Dual Gold 6336Y (48c x 2.3GHz) - 11Gbps / 1.8Mpps
  *	- SoftGate PRO
	- Private Cloud, Public Cloud Border Gateway, Enterprise Cloud, Vmware NSX alternative.
	-  ✔
	- Single
	- VLAN
	- Netris DPDK
	- Active/Standby - 2 nodes
	- Netris Switch-Fabric
	- Nvidia Connect-X 5, 6 100Gbe
	- Intel XEON (required for DPDK)
	- 128GB
	- 300GB
	- Intel XEON Platinum 20+ cores - 100Gbps / 25Mpps
  *	- SoftGate HS (HyperScale)
	- Scalable GPU & CPU Cloud Services Provider.
	- ✔
	- Multi
	- VXLAN
	- Linux w/ Netris optimizations
	- Active/Active - Horizontally scalable 
	- Netris Switch-Fabric
	- Any OK. Nvidia Connect-X is recommended
	- Intel or AMD
	- 128-256GB
	- 300GB
	- Dual Platinum 8352Y (64c x 2.2GHz) - 22Gbps / 3.5 Mpps
  *	- SoftGate HS PRO
	- Scalable GPU & CPU Cloud Services Provider.
	- 2025/Q2
	- Multi
	- VXLAN
	- Netris XDP
	- Active/Active - Horizontally scalable
	- Netris Switch-Fabric
	- Nvidia Connect-X 5, 6, 7
	- Intel, AMD (TBD) 
	- 256GB+
	- 300GB
	- TBD

============================================
Netris and NOS versions compatibility matrix
============================================

.. list-table:: 
   :header-rows: 0

   * - **Netris Version**
     - **Switch & OS**
     - **Bare Metal Cloud**
     - **SoftGate OS**
     - **Availability**
   * - 4.4.0
     - Nvidia Cumulus 5.11, Dell SONiC 4.4, EdgeCore SONiC 202211-331
     - Equinix Metal, PhoenixNAP BMC
     - SoftGate HS: Ubuntu 24.04, SoftGate Pro: Ubuntu 20.04, SoftGate: Ubuntu 22.04 
     -  ✔
   * - 4.3.0
     - Nvidia Cumulus 5.9, Dell SONiC 4.1, EdgeCore SONiC 12.3 
     - Equinix Metal, PhoenixNAP BMC
     - SoftGate Pro: Ubuntu 20.04, SoftGate: Ubuntu 22.04 (non-pro)
     -  ✔
   * - 4.2.0
     - Nvidia Cumulus 5.7, Dell SONiC 4.1, EdgeCore SONiC 12.3 
     - Equinix Metal, PhoenixNAP BMC
     - SoftGate Pro: Ubuntu 20.04, SoftGate: Ubuntu 22.04
     -  ✔
   * - 4.1.1
     - Nvidia Cumulus 5.7, EdgeCore SONiC 12.3 
     - Equinix Metal, PhoenixNAP BMC
     - SoftGate Pro: Ubuntu 20.04, SoftGate: Ubuntu 22.04
     -  ✔
   * - 4.0.0
     - Nvidia Cumulus 5.7, EdgeCore SONiC 12.3 
     - Equinix Metal, PhoenixNAP BMC
     - SoftGate Pro: Ubuntu 20.04, SoftGate: Ubuntu 22.04
     -  ✔
   * - 3.5.0
     - Nvidia Cumulus 5.7, EdgeCore SONiC 12.3 
     - Equinix Metal, PhoenixNAP BMC
     - SoftGate Pro: Ubuntu 20.04, SoftGate: Ubuntu 22.04
     -  ✔
   * - 3.4.1
     - Nvidia Cumulus 5.7, EdgeCore SONiC 12.3 
     - Equinix Metal, PhoenixNAP BMC
     - SoftGate Pro: Ubuntu 20.04, SoftGate: Ubuntu 22.04
     -  ✔
