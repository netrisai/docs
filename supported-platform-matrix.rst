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
      - Dec/2024
      - GA
      - N/A	
      - N/A
   *  - Parallel Fabrics
      - Manage multiple isolated switch fabrics. (example: East-West and North-South)
      - GA
      - GA
      - Dec/2024
      - GA
      - N/A
      - N/A
   *  - Topology Manager
      - Design and operate the switch fabric.
      - GA
      - GA
      - Dec/2024
      - GA
      - N/A
      - N/A
   *  - Maintenance Mode
      - Offload a network node for a maintenance.
      - GA
      - GA
      - Dec/2024
      - GA
      - GA
      - GA
   *  - IPAM
      - Manage IP subnets. Assign RBAC, multi-tenancy, and service-based rules and roles to IP address resources.
      - GA
      - GA
      - Dec/2024
      - GA
      - GA
      - GA
   *  - Looking Glass
      - Lookup underlay and overlay routing info of any managed network node without SSH-ing.
      - GA
      - GA
      - Dec/2024
      - GA
      - GA
      - GA
   *  - Monitoring: Switch Ports
      - Automatic monitoring of Link statuses, link utilization, laser signal levels, errors, packets. 	
      - GA
      - GA
      - Dec/2024
      - GA
      - N/A
      - N/A
   *  - Monitoring: Resources
      - Automatic monitoring of CPU, RAM, Disk, and ASIC resources.
      - GA
      - GA
      - Dec/2024
      - GA
      - GA
      - GA
   *  - Monitoring: Sensors
      - Automatic monitoring of temperature, fans, power supply statuses.
      - GA
      - GA
      - Dec/2024
      - GA
      - N/A
      - N/A
   *  - Monitoring: System Processes
      - Automatic monitoring of critical system processes.
      - GA
      - GA
      - Dec/2024
      - GA
      - GA
      - GA
   *  - Topology Validation
      - Detect wiring errors.
      - July/31/2024
      - TBD
      - Dec/2024
      - TBD	
      - N/A
      - N/A
   *  - BGP Unnumbered
      - Any network topology with BGP unnumbered underlay
      - GA
      - GA
      - Dec/2024
      - GA
      - N/A
      - N/A
   *  - BGP Numbered
      - Any network topology with BGP numbered underlay
      - July/31/2024
      - TBD
      - Dec/2024
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
      - Dec/2024
      - GA
      - GA
      - GA
   *  - External BGP (Switch)
      - Peer with external routers.
      - GA
      - GA
      - Dec/2024
      - GA
      - N/A
      - N/A
   *  - BGP Route-Maps
      - Create chain of BGP rules.
      - GA
      - GA
      - Dec/2024
      - GA
      - GA
      - GA
   *  - Static Routes
      - Define static routing rules.
      - GA
      - GA
      - Dec/2024
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
      - Dec/2024
      - GA
      - GA
      - GA
   *  - V-Net (Subnet)
      - L3VPN VXLAN or L2VPN VXLAN with an anycast default gateway, and built-in DHCP.	
      - GA
      - GA
      - Dec/2024
      - GA
      - GA
      - GA
   *  - Server Cluster (Profiling)
      - Profiling create and apply network constructs to list of servers (not switch ports)
      - July/31/2024
      - TBD
      - Dec/2024
      - TBD
      - TBD
      - TBD
   *  - Internet Gateway
      - Provide shared Internet access to V-Nets and VPC
      - GA (single VPC) - Multi-VPC July/31/2024
      - GA (single VPC)
      - Dec/2024
      - GA (single VPC)
      - GA (single VPC)
      - GA (single VPC)
   *  - NAT Gateway
      - Provide shared DNAT, PAT, 1:1 NAT to V-Nets and VPCs
      - GA (single VPC) - Multi-VPC July/31/2024
      - GA (single VPC)
      - Dec/2024
      - GA (single VPC)
      - GA (single VPC)
      - GA (single VPC)
   *  - L4 Load Balancer
      - Provide on-demand elastic load balancer service to hosts in V-Nets and VPCs
      - GA (single VPC) - Multi-VPC October/31/2024
      - GA (single VPC)
      - Dec/2024
      - GA (single VPC)
      - GA (single VPC)
      - GA (single VPC)
   *  - SiteMesh
      - Wireguard-based Site-to-Site VPN between multiple regions/sites.
      - GA (single VPC)
      - GA (single VPC)
      - Dec/2024
      - GA (single VPC)
      - GA (single VPC)
      - GA (single VPC)


=====================================
Netris Supported Platforms & Versions
=====================================

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
     - July 31 2024
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
