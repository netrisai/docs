=====================
Hardware Requirements
=====================

Netris Controller
=================

We recommend two Ubuntu 24.04 servers with the below specs. Netris controller can also run on other Linux OSes or on a shared Kubernetes cluster. 

.. list-table:: 
   :header-rows: 0

   * - **Use Case**
     - **CPU Cores**
     - **RAM**
     - **SSD/NVME**
     - **Network**
   * - Leaf/Spine 1-30 switches
     - 4
     - 32 GB
     - 300 GB
     - 2x 1GbE+ NIC
   * - Leaf/Spine 30-100 switches
     - 8
     - 32 GB
     - 600 GB
     - 2x 1GbE+ NIC
   * - Leaf/Spine 100-300 switches
     - 16
     - 64 GB
     - 1 TB
     - 2x 10GbE+ NIC
   * - Leaf/Spine 300+ switches
     - 32
     - 128 GB
     - 2 TB
     - 2x 10GbE+ NIC
   * - Spectrum-X 1-8 SUs
     - 16
     - 64 GB
     - 1 TB
     - 2x 10GbE+ NIC
   * - Spectrum-X 16-32 SUs
     - 32
     - 128 GB
     - 2 TB
     - 2x 10GbE+ NIC
   * - Spectrum-X 32+ SUs
     - 64
     - 256 GB
     - 10 TB
     - 2x 10GbE+ NIC

Netris SoftGate HS (The Horizontally Scalable version)
==========================================

A minimum of 4 dedicated servers are required for an HA (highly available) active-active SoftGate HS cluster. Two SoftGates will forward stateful traffic (SNAT), and two others will forward the stateless traffic (DNAT, 1:1 NAT, Layer-4 Load Balancing, etc.) Each group (stateful and stateless) can be scaled horizontally by deploying more servers as CPU & RAM utilization necessitates.

Server specs:

.. list-table:: 
   :header-rows: 0

   * - 
     - **Minimum**
     - **Recommended**
   * - CPU (Modern Intel/AMD X86)
     - 16 Cores
     - 32 Cores
   * - RAM
     - 128 GB
     - 256 GB
   * - NIC prod
     - 2x 10GbE
     - 2x 25GbE
   * - NIC OOB
     - 1x 1GbE
     - 1x 1GbE
   * - Disk
     - 300 GB
     - 300 GB



=========================
Supported Switch Hardware
=========================

Nvidia
======
.. list-table:: 
   :header-rows: 0

   * - **Manufacturer**
     - **Model**
     - **ASIC**
     - **Ports**
     - **NOS**
     - **Caveats**
     - **Netris Support**
   * - Nvidia
     - SN2010
     - Spectrum
     - 18 x SFP28 25GbE + 4 x QSFP28 100GbE
     - Cumulus Linux
     - 
     - GA
   * - Nvidia
     - SN2100
     - Spectrum
     - 16 x QSFP28 100GbE
     - Cumulus Linux
     - 
     - GA
   * - Nvidia
     - SN2201
     - Spectrum
     - 48 x RJ45 + 4 x QSFP28 100GbE
     - Cumulus Linux
     - 
     - GA
   * - Nvidia
     - SN2410
     - Spectrum
     - 48 x SFP28 25GbE + 8 x QSFP28 100GbE
     - Cumulus Linux
     - 
     - GA
   * - Nvidia
     - SN2700
     - Spectrum
     - 32 x QSFP28 100GbE
     - Cumulus Linux
     - 
     - GA
   * - Nvidia
     - SN3420
     - Spectrum 2
     - 48 x SFP28 25GbE + 12 x QSFP28 100GbE
     - Cumulus Linux
     - 
     - GA
   * - Nvidia
     - SN3700C
     - Spectrum 2
     - 32 x QSFP28 100GbE
     - Cumulus Linux
     - 
     - GA
   * - Nvidia
     - SN3700
     - Spectrum 2
     - 32 x QSFP56 200GbE
     - Cumulus Linux
     - 
     - GA
   * - Nvidia
     - SN4410
     - Spectrum 3
     - 24 x QSFP28-DD 100G + 8 x QSFP-DD 400GbE
     - Cumulus Linux
     - 
     - GA
   * - Nvidia
     - SN4600C
     - Spectrum 3
     - 64 x QSFP28 100GbE
     - Cumulus Linux
     - 
     - GA
   * - Nvidia
     - SN4600
     - Spectrum 3
     - 64 QSFP56 200GbE
     - Cumulus Linux
     - 
     - GA
   * - Nvidia
     - SN4700
     - Spectrum 3
     - 32 x QSFP-DD 400GbE
     - Cumulus Linux
     - 
     - GA
   * - Nvidia
     - SN5400
     - Spectrum 4
     - 64 x QSFP-DD 400GbE + 2 x SFP28 25GbE
     - Cumulus Linux
     - 
     - GA
   * - Nvidia
     - SN5600
     - Spectrum 4
     - 64 x OSFP 800GbE + 1 x SFP28 25GbE
     - Cumulus Linux
     - 
     - GA


Dell
======
.. list-table:: 
   :header-rows: 0

   * - **Manufacturer**
     - **Model**
     - **ASIC**
     - **Ports**
     - **NOS**
     - **Caveats**
     - **Netris Support**
   * - Dell
     - PowerSwitch S Series S5212F-ON
     - Broadcom Trident III
     - 12 x 25G SFP28 + 3 x 100GbE QSFP28
     - Dell-SONiC
     - 
     - GA
   * - Dell
     - PowerSwitch S Series S5224F-ON
     - Broadcom Trident III
     - 24 x 25G SFP28 + 4 x 100GbE QSFP28
     - Dell-SONiC
     - 
     - GA
   * - Dell
     - PowerSwitch S Series S5232F-ON
     - Broadcom Trident III
     - 32 x 100GbE QSFP28
     - Dell-SONiC
     - 
     - GA
   * - Dell
     - PowerSwitch S Series S5248F-ON
     - Broadcom Trident III
     - 48 x 25G SFP28 + 4 x 100GbE QSFP28 + 2 x 200GbE QSFP28
     - Dell-SONiC
     - 
     - GA
   * - Dell
     - PowerSwitch S Series S5296F-ON
     - Broadcom Trident III
     - 96 x 25G SFP28 + 8 x 100GbE QSFP28
     - Dell-SONiC
     - 
     - GA
   * - Dell
     - PowerSwitch S Series S5448F-ON
     - Broadcom Trident IV
     - 48 x QSFP-DD 100GbE + 8 x QSFP-DD 400GbE
     - Dell-SONiC
     - 
     - GA
   * - Dell
     - PowerSwitch Z Series Z9664F-ON
     - Broadcom Tomahawk IV
     - 64 x QSFP-DD 400GbE
     - Dell-SONiC
     - 
     - GA
   * - Dell
     - PowerSwitch Z Series Z9432F-ON
     - Broadcom Trident IV
     - 32 x QSFP-DD 400GbE
     - Dell-SONiC
     - 
     - GA


EdgeCore
========
.. list-table:: 
   :header-rows: 0

   * - **Manufacturer**
     - **Model**
     - **ASIC**
     - **Ports**
     - **NOS**
     - **Caveats**
     - **Netris Support**
   * - EdgeCore
     - DCS201 (AS5835-54X)
     - Broadcom Trident III
     - 48 x 10G SFP+ + 6 x 100G QSFP28
     - EC-SONiC
     - 
     - GA
   * - EdgeCore
     - DCS202 (AS5835-54T)
     - Broadcom Trident III
     - 48 x 10G RJ-45 + 6 x 100G QSFP28
     - EC-SONiC
     - 
     - GA
   * - EdgeCore
     - DCS203 (AS7326-56X)
     - Broadcom Trident III
     - 48 x 25G SFP28 + 8 x 100G QSFP28+ 2 x 10G
     - EC-SONiC
     - 
     - GA
   * - EdgeCore
     - AS7726-32X
     - Broadcom Trident III
     - 32 x 100G QSFP28 + 2 x 10G SFP+
     - EC-SONiC
     - 
     - GA
   * - EdgeCore
     - DCS510 (AS9716-32D)
     - Broadcom Tomahawk 3
     - 32 x 400G QSFP-DD 
     - EC-SONiC
     - 
     - GA
   * - EdgeCore
     - DCS511 (AS9737-32DB)
     - Broadcom Tomahawk 4
     - 32 x 400G QSFP56-DD
     - EC-SONiC
     - 
     - GA
   * - EdgeCore
     - AIS800-64O
     - Broadcom Tomahawk 5
     - 64 x OSFP800
     - EC-SONiC
     - 
     - GA

Arista
========
.. list-table:: 
   :header-rows: 0

   * - **Manufacturer**
     - **Model**
     - **ASIC**
     - **Ports**
     - **NOS**
     - **Caveats**
     - **Netris Support**
   * - Arista
     - 7020R
     - Qumran
     - 24 x 10G + 2 QSFP100; 32 x 10G + 2 QSFP100; 48 x 100/1000Mb + 6 SFP+; 48 x 100/1000Mb + 6 SFP+
     - EOS
     - 
     - Dec/2024
   * - Arista
     - 7050X3
     - Broadcom Trident III
     - 32 x QSFP100; 48 x SFP25 + 12 x QSFP100; 48 x SFP25 + 8 x QSFP100; 48 x 10G-T + 8 x QSFP100
     - EOS
     - 
     - Dec/2024
   * - Arista
     - 7050X4
     - Trident-4
     - 32 QSFP-DD 400G + 2SFP+; 32 OSFP 400G + 2SFP+; 48 SFP-DD 100G + 8 QSFP-DD 400G; 48 DSFP 100G + 8 QSFPDD 400G; 24 QSFP56 200G + 8 QSFPDD 400G + 2SFP+; 48 QSFP28 + 8 QSFP-DD 400G + 2SFP+
     - EOS
     - 
     - Dec/2024
   * - Arista
     - 7060X4
     - Trident-4
     - 32 x QSFP-DD 800G + 2 x SFP+; 32 x QSFP-DD 800G + 2 x SFP+; 32 x OSFP 800G + 2 x SFP+; 64 x QSFP-DD 400G, 2 x SFP+; 32 x QSFP-DD + 1x SFP+; 56x QSFP100, 8 x QSFP-DD 400G + 1x SFP+
     - EOS
     - 
     - Dec/2024
   * - Arista
     - 7060X5
     - Tomahawk 4
     - 32 x QSFP-DD 800G + 2x SFP+; 32 x QSFP-DD 800G + 2x SFP+; 32 x OSFP 800G + 2x SFP+; 64 x QSFP-DD 400G + 2x SFP+; : 32 x QSFP-DD + 1 x SFP+; 56x QSFP100, 8 x QSFP-DD 400G, 1x SFP+
     - EOS
     - 
     - Dec/2024
   * - Arista
     - 7280R3A
     - Jericho2
     - 144 x 100G or 36 x 400G 
     - EOS
     - 
     - Dec/2024
   * - Arista
     - 7280R3
     - Jericho2
     - 24 x 400G; 96 x 100G; 25G + 8 x 100G
     - EOS
     - 
     - Dec/2024
   * - Arista
     - 7358X4
     - Trident-4
     - 128 x QSFP or 32 x OSFP / QSFP-DD
     - EOS
     - 
     - Dec/2024
   * - Arista
     - 7358X4
     - Trident-4
     - 128 x QSFP or 32 x OSFP / QSFP-DD
     - EOS
     - 
     - Dec/2024
   * - Arista
     - 7368X4
     - Tomahawk 3
     - 128 x 100G or 32 x 400G
     - EOS
     - 
     - Dec/2024
   * - Arista
     - 7300R3
     - Trident-4
     - 256 wire-speed 40GbE ports 
     - EOS
     - 
     - Dec/2024
   * - Arista
     - 7500R3
     - Jericho, Jericho2
     - Up to 288 wire-speed 400G ports
     - EOS
     - 
     - Dec/2024
