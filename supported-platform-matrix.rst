=================================================
Netris Supported Functionality & Platforms Matrix
=================================================

Switch Fabric Management Functions
==================================
.. list-table:: 
   :header-rows: 0

   *  - Function	
      - Description	
      - Nvidia Spectrum
      - Dell SONiC
      - Arista EOS
      - EdgeCore SONiC
      - Equinix Metal
      - PhoenixNAP
   *  - Fabric Manager	
      - Day0, Day1, and Day2 switch fabric operations.	
      - GA	
      - GA
      - Oct/2024
      - GA
      - N/A	
      - N/A
   *  - Parallel Fabrics
      - Manage multiple isolated switch fabrics. (example: East-West and North-South)
      - GA
      - GA
      - Oct/2024
      - GA
      - N/A
      - N/A
   *  - Topology Manager
      - Design and operate the switch fabric.
      - GA
      - GA
      - Oct/2024
      - GA
      - N/A
      - N/A
   *  - Maintenance Mode
      - Offload a network node for a maintenance.
      - GA
      - GA
      - Oct/2024
      - GA
      - GA
      - GA
   *  - IPAM
      - Manage IP subnets. Assign RBAC, multi-tenancy, and service-based rules and roles to IP address resources.
      - GA
      - GA
      - Oct/2024
      - GA
      - GA
      - GA
   *  - Looking Glass
      - Lookup underlay and overlay routing info of any managed network node without SSH-ing.
      - GA
      - GA
      - Oct/2024
      - GA
      - GA
      - GA
   *  - Monitoring: Switch Ports
      - Automatic monitoring of Link statuses, link utilization, laser signal levels, errors, packets. 	
      - GA
      - GA
      - Oct/2024
      - GA
      - N/A
      - N/A
   *  - Monitoring: Resources
      - Automatic monitoring of CPU, RAM, Disk, and ASIC resources.
      - GA
      - GA
      - Oct/2024
      - GA
      - GA
      - GA
   *  - Monitoring: Sensors
      - Automatic monitoring of temperature, fans, power supply statuses.
      - GA
      - GA
      - Oct/2024
      - GA
      - N/A
      - N/A
   *  - Monitoring: System Processes
      - Automatic monitoring of critical system processes.
      - GA
      - GA
      - Oct/2024
      - GA
      - GA
      - GA
   *  - Topology Validation
      - Detect wiring errors.
      - GA
      - TBD
      - Oct/2024
      - TBD	
      - N/A
      - N/A
   *  - BGP Unnumbered
      - Any network topology with BGP unnumbered underlay
      - GA
      - GA
      - Oct/2024
      - GA
      - N/A
      - N/A
   *  - BGP Numbered
      - Any network topology with BGP numbered underlay
      - GA
      - TBD
      - Oct/2024
      - TBD
      - N/A
      - N/A

External Routing Functions
==========================

.. list-table:: 
   :header-rows: 0

   *  - Function
      - Description
      - Nvidia Spectrum
      - Dell-SONiC
      - Arista EOS
      - EdgeCore-SONiC
      - Equinix Metal
      - PhoenixNAP
   *  - External BGP (SoftGate)
      - Terminate full routing table on SoftGate gateway-server.
      - GA
      - GA
      - Oct/2024
      - GA
      - GA
      - GA
   *  - External BGP (Switch)
      - Peer with external routers.
      - GA
      - GA
      - Oct/2024
      - GA
      - N/A
      - N/A
   *  - BGP Route-Maps
      - Create chain of BGP rules.
      - GA
      - GA
      - Oct/2024
      - GA
      - GA
      - GA
   *  - Static Routes
      - Define static routing rules.
      - GA
      - GA
      - Oct/2024
      - GA
      - GA
      - GA



Cloud Networking Constructs
===========================

.. list-table:: 
   :header-rows: 0

   *  - Function
      - Description
      - Nvidia Spectrum
      - Dell-SONiC
      - Arista EOS
      - EdgeCore-SONiC
      - Equinix Metal
      - PhoenixNAP
   *  - VPC (Virtual Private Cloud)
      - Isolated VPCs, VRFs. Overlapping IPs supported.
      - GA
      - GA
      - Oct/2024
      - GA
      - GA
      - GA
   *  - V-Net (Subnet)
      - L3VPN VXLAN or L2VPN VXLAN with an anycast default gateway, and built-in DHCP.	
      - GA
      - GA
      - Oct/2024
      - GA
      - GA
      - GA
   *  - Server Cluster (Profiling)
      - Create network constructs template, then apply it on groups of servers. 
      - GA
      - TBD
      - Oct/2024
      - TBD
      - TBD
      - TBD
   *  - Internet Gateway
      - Provide shared Internet access to V-Nets and VPC
      - GA (Multi VPC)
      - GA (single VPC)
      - Oct/2024
      - GA (single VPC)
      - GA (single VPC)
      - GA (single VPC)
   *  - NAT Gateway
      - Provide shared DNAT, PAT, 1:1 NAT to V-Nets and VPCs
      - GA (Multi VPC)
      - GA (single VPC)
      - Oct/2024
      - GA (single VPC)
      - GA (single VPC)
      - GA (single VPC)
   *  - L4 Load Balancer
      - Provide on-demand elastic load balancer service to hosts in V-Nets and VPCs
      - GA (single VPC) - Multi-VPC October/31/2024
      - GA (single VPC)
      - Oct/2024
      - GA (single VPC)
      - GA (single VPC)
      - GA (single VPC)
   *  - SiteMesh
      - Wireguard-based Site-to-Site VPN between multiple regions/sites.
      - GA (single VPC)
      - GA (single VPC)
      - Oct/2024
      - GA (single VPC)
      - GA (single VPC)
      - GA (single VPC)


Overlay Network Features
==========================
.. list-table:: 
   :header-rows: 0

   *  - Function
      - Description
      - Nvidia Spectrum
      - Dell-SONiC
      - Arista EOS
      - EdgeCore-SONiC
      - Equinix Metal
      - PhoenixNAP
   *  - L2VPN VXLAN VLAN Aware
      - L2VPN VXLAN with VLAN tagged or untagged termination on switch port.
      - GA
      - GA
      - Oct/2024
      - GA
      - N/A	
      - N/A
   *  - L2VPN VXLAN VLAN Unaware	
      - L2VPN VXLAN with VLAN tagged or untagged termination on switch port supporting different VLAN IDs on different end points.	
      - N/A
      - N/A
      - Oct/2024
      - N/A
      - N/A
      - N/A
   *  - L3VPN VXLAN
      - L3VPN VXLAN, Commonly used in high performance computing, such as AI clusters.
      - GA
      - TBD	
      - TBD
      - TBD
      - N/A
      - N/A
   *  - EVPN-MH / VXLAN-ESI
      - EVPN MultiHoming based on VXLAN and ESI for automatic Active-Active server network multihoming
      - GA
      - TBD
      - Oct/2024
      - TBD	
      - N/A
      - N/A
   *  - LACP
      - Link Aggregation or Active-Standby server multihoming.	
      - GA
      - GA	
      - Oct/2024
      - TBD
      - N/A
      - N/A
   *  - MC-LAG
      - Traditional MC-LAG-based server multihoming	
      - GA
      - TBD
      - TBD
      - TBD
      - N/A
      - N/A


AI Specific Functions	
=====================
.. list-table:: 
   :header-rows: 0

   *  - Function
      - Description
      - Nvidia Spectrum
      - Dell-SONiC
      - Arista EOS
      - EdgeCore-SONiC
      - Equinix Metal
      - PhoenixNAP
   *  - Spectrum-X
      - AI GPU cluster switch fabric operation for Nvidia Spectrum-X
      - GA	
      - N/A
      - N/A
      - N/A
      - N/A
      - N/A
   *  - Rail-optimized designs
      - Topology and best practices initialization module for rail-optimized fabrics
      - GA
      - N/A
      - N/A
      - N/A
      - N/A
      - N/A
   *  - QoS for RoCE
      - Enable QoS for RoCE workloads	
      - GA
      - N/A
      - N/A
      - N/A
      - N/A
      - N/A
   *  - RoCE Adaptive Routing
      - Enable RoCE adaptive routing
      - GA
      - N/A
      - N/A
      - N/A
      - N/A
      - N/A
   *  - RoCE Congestion Control
      - Enable automatic congestion control for RoCE workloads
      - GA
      - N/A
      - N/A
      - N/A
      - N/A
      - N/A
   *  - DPU/Host zero-touch configuration
      - Automatically configure IP addresses, routing, RoCE and other DPU/SuperNIC specific configuration on GPU servers
      - GA
      - N/A
      - N/A
      - N/A
      - N/A
      - N/A
							

Security
========
.. list-table:: 
   :header-rows: 0

   *  - Function
      - Description
      - Nvidia Spectrum
      - Dell-SONiC
      - Arista EOS
      - EdgeCore-SONiC
      - Equinix Metal
      - PhoenixNAP
   *  - Network ACLs
      - Centralized Network Access Control Lists.
      - GA
      - GA
      - Oct/2024
      - TBD
      - N/A
      - N/A
   *  - Managed Device Profiling
      - Managed switch & Softgate protection from unwanted access, push administrative and system settings (NTP, DNS, timezone, etc.)
      - GA
      - GA
      - Oct/2024
      - TBD
      - N/A
      - N/A
   *  - Audit Logs
      - Log all controller access and changes.	
      - GA
      - GA
      - Oct/2024
      - GA
      - N/A
      - N/A


Administration							
==============

.. list-table:: 
   :header-rows: 0
						
   *  - Function
      - Description
      - Globally					
   *  - Role Based Access Control
      - Who can view and edit which aspects of the system.
      - GA					
   *  - Multi-Tenancy
      - Network resource delegation to tenants.
      - GA					
							
Management Interfaces	
=====================

.. list-table:: 
   :header-rows: 0
						
   *  - Function
      - Description
      - Globally		
   *  - Web Console
      - Manage through intuitive web interface.
      - GA					
   *  - RestAPI
      - Integrate your other systems or your customer-facing portal with Netris consuming RestAPIs.
      - GA					
   *  - IaC: Terraform
      - Manage your infrastructure as a code using Terraform.
      - GA					
							
							
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
      - GA (native & automatic)
      - GA (need to specify backend IPs)
      - Oct/2024
      - GA (need to specify backend IPs)
      - GA (need to specify backend IPs)	
      - GA (need to specify backend IPs)
   *  - VPC to internal routing peering
      - Automatically route internal networks into VPC routing table (allow containers communicate with VMs).
      - GA
      - N/A	
      - TBD
      - Dec/2024
      - TBD
      - TBD
   *  - Automatic VXLAN/VLAN
      - Automatically provision VXLAN/VLAN on switch fabric and include appropriate switch ports when virtual network is created in the hypervisor.	
      - TBD
      - GA
      - GA
      - Dec/2024
      - TBD
      - TBD
   *  - HBN	Host-based networking. 
      - Terminate VTEPs on the hypervisor host. Scale beyond VLAN limits
      - Dec/2024
      - TBD
      - Oct/2024
      - Dec/2024
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
	- GA
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
	- GA
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
	- Sep/15/2024
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
	- 2025
	- Multi
	- VXLAN
	- Netris
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
   * - 4.3.0
     - Nvidia Cumulus 5.9, Dell SONiC 4.1, EdgeCore SONiC 12.3 
     - Equinix Metal, PhoenixNAP BMC
     - SoftGate Pro: Ubuntu 20.04, SoftGate: Ubuntu 22.04 (non-pro)
     - GA
   * - 4.2.0
     - Nvidia Cumulus 5.7, Dell SONiC 4.1, EdgeCore SONiC 12.3 
     - Equinix Metal, PhoenixNAP BMC
     - SoftGate Pro: Ubuntu 20.04, SoftGate: Ubuntu 22.04
     - GA
   * - 4.1.1
     - Nvidia Cumulus 5.7, EdgeCore SONiC 12.3 
     - Equinix Metal, PhoenixNAP BMC
     - SoftGate Pro: Ubuntu 20.04, SoftGate: Ubuntu 22.04
     - GA
   * - 4.0.0
     - Nvidia Cumulus 5.7, EdgeCore SONiC 12.3 
     - Equinix Metal, PhoenixNAP BMC
     - SoftGate Pro: Ubuntu 20.04, SoftGate: Ubuntu 22.04
     - GA
   * - 3.5.0
     - Nvidia Cumulus 5.7, EdgeCore SONiC 12.3 
     - Equinix Metal, PhoenixNAP BMC
     - SoftGate Pro: Ubuntu 20.04, SoftGate: Ubuntu 22.04
     - GA
   * - 3.4.1
     - Nvidia Cumulus 5.7, EdgeCore SONiC 12.3 
     - Equinix Metal, PhoenixNAP BMC
     - SoftGate Pro: Ubuntu 20.04, SoftGate: Ubuntu 22.04
     - GA
