=================================================
Netris Supported Functionality & Platforms Matrix
=================================================

Network Management
==================
.. list-table:: 
   :header-rows: 0

   *  - Function	
      - Description	
      - Nvidia Spectrum Switches
      - Dell-SONiC
      - EdgeCore-SONiC
      - Equinix Metal
      - PhoenixNAP
   *  - Fabric Manager	
      - Day0, Day1, and Day2 switch fabric operations.	
      - GA	
      - GA	
      - GA
      - N/A	
      - N/A
   *  - Parallel Fabrics
      - Manage multiple isolated switch fabrics. (example: East-West and North-South)
      - GA
      - GA
      - GA
      - N/A
      - N/A
   *  - Topology Manager
      - Design and operate the switch fabric.
      - GA
      - GA
      - GA
      - N/A
      - N/A
   *  - Maintenance Mode
      - Offload a network node for a maintenance.
      - GA
      - GA
      - GA
      - GA
      - GA
   *  - IPAM
      - Manage IP subnets. Assign RBAC, multi-tenancy, and service-based rules and roles to IP address resources.
      - GA
      - GA
      - GA
      - GA
      - GA
   *  - Looking Glass
      - Lookup underlay and overlay routing info of any managed network node without SSH-ing.
      - GA
      - GA
      - GA
      - GA
      - GA
   *  - Monitoring: Switch Ports
      - Automatic monitoring of Link statuses, link utilization, laser signal levels, errors, packets. 	
      - GA
      - GA
      - GA
      - N/A
      - N/A
   *  - Monitoring: Resources
      - Automatic monitoring of CPU, RAM, Disk, and ASIC resources.
      - GA
      - GA
      - GA
      - GA
      - GA
   *  - Monitoring: Sensors
      - Automatic monitoring of temperature, fans, power supply statuses.
      - GA
      - GA
      - GA
      - N/A
      - N/A
   *  - Monitoring: System Processes
      - Automatic monitoring of critical system processes.
      - GA
      - GA
      - GA
      - GA
      - GA
   *  - Topology Validation
      - Detect wiring errors.
      - July/31/2024
      - -
      - -	
      - N/A
      - N/A

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
