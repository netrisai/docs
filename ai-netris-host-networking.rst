.. meta::
    :description: Netris Host Networking Plugin

Netris Host Networking - Complete User Guide
============================================

Overview
--------

The Netris Host Networking plugin provides automated network configuration management tools for bare-metal servers deployed on NVIDIA Spectrum-X east-west fabrics. The plugin consists of two main components: **Netris Host Networking (NHN)** and **NHN-DOCA** (NVIDIA DOCA configuration and verification).

Netris Host Networking (NHN)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**NHN** is an automated network configuration management service designed for the east-west fabric of bare-metal servers with BlueField3 SuperNICs and based on the Spectrum-X architecture. It automatically discovers and configures network interfaces based on LLDP (Link Layer Discovery Protocol) information received from network switches, enabling zero-touch server-side network configuration.

**Key Features**

- **Automatic Interface Discovery** - Detects and configures network interfaces without manual intervention.
- **LLDP-Based Configuration** - Receives network configuration from ToR (Top-of-Rack) switches via LLDP.
- **Dual Network Manager Support** - Works with both netplan (systemd-networkd) and ifupdown network managers.
- **Configuration Caching** - Maintains configuration resilience when LLDP is temporarily unavailable.

**How NHN Works**

NHN runs continuously on Linux hosts, performing these tasks:

#. Discovers network interfaces on the system
#. Queries the LLDP daemon for configuration information
#. Parses custom LLDP TLVs containing network settings
#. Generates appropriate network configuration files
#. Applies the configuration to activate network settings
#. Caches configuration for resilience

NHN works on a "push" model where network switches provide configuration to hosts using Netris proprietary LLDP TLVs, rather than hosts pulling configuration from a central server.

NHN also periodically runs NHN-DOCA commands for configuration and verification of the BlueField3 SuperNICs.

- ``bf3-config`` (BlueField-3 NIC configuration)
- ``verifier`` (BlueField-3 NIC configuration verification)

NHN-DOCA
~~~~~~~~

**NHN-DOCA** is a configuration and verification tool for NVIDIA DOCA BlueField-3 NICs running in Spectrum-X networking fabric environments.

**Key Features**

- **Automatic device discovery** via LLDP.
- **Version-aware configuration** (Spectrum-X v1.2.0 vs v1.3.0).
- **Comprehensive validation** with detailed error reporting.
- **LLDP-based error propagation** for switch-side monitoring.

**Includes Two Utilities**

- ``bf3-config`` - Automatically configures BlueField-3 devices for east-west fabric networks.
- ``verifier`` - Validates configurations and reports issues via LLDP.

**How NHN-DOCA works:**

#. The ``bf3-config`` queries LLDP information from each network interface
#. It extracts the connected switch name from LLDP data
#. The switch name is matched against this regex pattern
#. Only interfaces connected to matching switches are configured

Before You Begin
-----------------

System Requirements
~~~~~~~~~~~~~~~~~~~

Operating System
^^^^^^^^^^^^^^^^

- Linux (tested on Ubuntu)

Hardware Requirements (for NHN-DOCA)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- NVIDIA BlueField-3 NICs
- Connected to NVIDIA Cumulus Linux switches
- LLDP enabled on connected switches

Dependencies
^^^^^^^^^^^^

For NHN
"""""""

- ``lldpd`` - LLDP daemon (required)
- ``systemd`` (for netplan mode) or ``ifupdown`` (for interfaces mode)
- ``netplan.io`` (if using netplan/systemd-networkd)

For NHN-DOCA
"""""""""""""

- ``doca-host`` - DOCA host software stack
- ``doca-ofed`` - NVIDIA OFED drivers for DOCA
- ``mft`` - Mellanox Firmware Tools
- ``netplan.io`` - Network configuration management
- ``doca-nvn-cc`` - NVN Congestion Control daemon

Recommended Component Versions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Spectrum-X v1.2.0
"""""""""""""""""

.. list-table::
   :header-rows: 1

   * - Components
     - Version
   * - Cumulus Linux OS
     - 5.11.0.0026
   * - BlueField FW Bundle (BFB)
     - 2.9.0-90
   * - BlueField-3 Firmware
     - 32.43.1014
   * - DOCA Host
     - 2.9.0-0.4.7
   * - Spectrum-X Congestion Control Algorithm (SPC-X CC)
     - 2.9.0072-1

Spectrum-X v1.3.0
"""""""""""""""""

.. list-table::
   :header-rows: 1

   * - Components
     - Version
   * - Cumulus Linux OS
     - 5.12.1.100
   * - BlueField FW Bundle (BFB)
     - 2.10.0-147_25.01
   * - BlueField-3 Firmware
     - 32.44.1036
   * - DOCA Host
     - 2.10.0-0.5.3
   * - Spectrum-X Congestion Control Algorithm (SPC-X CC)
     - 2.10

Permissions
^^^^^^^^^^^

- Must run as root (requires access to netlink and network configuration)

Installation Overview
~~~~~~~~~~~~~~~~~~~~~~

1. Install the netris-hnp Netris Host Networking package.
2. Review the configuration file ``/opt/netris/etc/netris.conf``.
3. Download the NVIDIA dependencies for the BlueField-3 SmartNICs.
4. Run the SmartNIC configurator ``/opt/netris/bin/bf3-config``.
5. Verify the SmartNIC configuration with ``/opt/netris/bin/verifier``.
6. Start the NHN daemon.

Installation
------------

1. Add the Netris Package Repository
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Download and install the GPG key for the Netris repository

.. code-block:: bash

   wget -qO - https://repo.netris.ai/repo/public.key | sudo gpg --dearmor -o /usr/share/keyrings/netris.gpg

Add the Netris repository to your system's sources list

.. code-block:: bash

   echo "deb [signed-by=/usr/share/keyrings/netris.gpg] http://repo.netris.ai/repo/ noble main" | sudo tee /etc/apt/sources.list.d/netris.list

2. Install the Netris NHN Package
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   sudo apt update && sudo apt install netris-hnp

Configuration
-------------


1. Review the Configuration File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Default location: ``/opt/netris/etc/netris.conf``

The configuration file uses INI format with sections for different components.

.. code-block:: ini

   [paths]
   netplan_path = /etc/netplan
   interfaces_path = /etc/network/interfaces.d

   [intervals]
   networking_routine = 20
   run_commands = 300

   [netris-controller]
   # Path to netplan configuration file
   netplan_cfg_path = /etc/netplan/99-netris-controller.yaml

   # Cache directory for device information
   cache_file_path = /opt/netris/cache

   # Path to the verifier binary
   verifier_bin_path = /opt/netris/bin/nhn-doca-verifier

   # Regex pattern to match east-west fabric switch names
   # Default matches patterns like: su0-r0, su1-r1, su2-r3, etc.
   ew-switch-name-template = su[0-9]-+r[0-3]+

   # How often to run verification (in seconds)
   verifier_run_interval = 300

   # Network plugin update interval (in seconds)
   network_plugin_run_interval = 20


**Configuration Options:**

[paths] Section

.. list-table::
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - ``netplan_path``
     - Directory for netplan YAML files
     - ``/etc/netplan``
   * - ``interfaces_path``
     - Directory for ifupdown interface files
     - ``/etc/network/interfaces.d``

[intervals] Section

.. list-table::
   :header-rows: 1

   * - Parameter
     - Description
     - Default
     - Unit
   * - ``networking_routine``
     - How often to check and update network config
     - 20
     - seconds
   * - ``run_commands``
     - How often to run auxiliary commands
     - 300
     - seconds

[netris-controller] Section

.. list-table::
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - ``netplan_cfg_path``
     - Path to netplan configuration file
     - ``/etc/netplan/99-netris-controller.yaml``
   * - ``cache_file_path``
     - Cache directory for device information
     - ``/opt/netris/cache``
   * - ``verifier_bin_path``
     - Path to the verifier binary
     - ``/opt/netris/bin/nhn-doca-verifier``
   * - ``ew-switch-name-template``
     - Regex pattern to match east-west fabric switch names
     - ``su[0-9]-+r[0-3]+``
   * - ``verifier_run_interval``
     - How often to run verification
     - 300 seconds
   * - ``network_plugin_run_interval``
     - Network plugin update interval
     - 20 seconds

.. important::

   The ``ew-switch-name-template`` parameter is critical for identifying which network interfaces are connected to the east-west fabric. It's a regex pattern used to identify which network interfaces are connected to the east-west fabric.

**Examples:**

.. code-block:: ini

   # Match switches named su0-r0, su1-r1, etc.
   ew-switch-name-template = su[0-9]-+r[0-3]+

   # Match switches with 'ew-' prefix
   ew-switch-name-template = ew-.+

   # Match any switch with 'fabric' in the name
   ew-switch-name-template = .*fabric.*


**How it works**

1. The bf3-config queries LLDP information from each network interface.
2. It extracts the connected switch name from LLDP data.
3. The switch name is matched against this regex pattern.
4. Only interfaces connected to matching switches are configured.

2. Configure BlueField3 NICs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Place the downloaded dependency packages in one of the following directories, depending on your Spectrum-X version:

- /opt/nvidia/v1.2.0 for Spectrum-X v1.2
- /opt/nvidia/v1.3.0 for Spectrum-X v1.3

Execute the command to configure the BlueField3 NICs

``/opt/netris/bin/bf3-config``

Note: The configurator may prompt a server reboot. If the server reboots, run the configurator again to ensure proper configuration.

3. Verify BlueField3 NICs Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To ensure that the BlueField3 parameters are correctly configured and there are no errors, run the following command

``/opt/netris/bin/verifier``

4. Start the NHN daemon
~~~~~~~~~~~~~~~~~~~~~~~

After preparing the server and (if applicable) the SmartNIC, start NHN:

``sudo systemctl start netris-nhp``

NHN will begin discovering interfaces, reading LLDP information from the switches, and applying the correct host network configuration automatically.

NHN: Network Configuration Management
-------------------------------------

Workflow Cycle
~~~~~~~~~~~~~~

Every 20 seconds (set by the ``network_plugin_run_interval`` parameter), NHN performs these steps:

1. **Interface Discovery**

   - Uses netlink to enumerate network interfaces.
   - Excludes: bonds, bridges, VLANs, loopback, docker interfaces.

2. **LLDP Query**

   - Runs ``lldpctl -f json <interface>`` for each interface.
   - Retrieves LLDP neighbor information.

3. **Custom TLV Parsing**

   - Extracts custom TLVs.
   - Decodes hex-encoded configuration data.
   - Parses IP addresses, gateways, routes, MTU, bond names.

4. **Network Manager Detection**

   - Checks if systemd-networkd is active → use netplan.
   - Otherwise checks networking service → use ifupdown.

5. **Configuration Transformation**

   - Transforms parsed LLDP data to appropriate format.
   - Handles bonding by grouping interfaces.
   - Deduplicates addresses and routes.

6. **Configuration Application**

   - Compares new config with existing config.
   - If changed, writes new configuration file.
   - Applies configuration:

       - Netplan: runs ``netplan apply``.
       - Ifupdown: runs ``systemctl reload-or-restart networking``.

7. **Caching**

   - Saves LLDP packets to ``/var/cache/nhn/lldp_cache.json``.
   - Used when LLDP is temporarily unavailable.

Starting NHN
~~~~~~~~~~~~

As a Systemd Service (Recommended)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   # Start the service
   sudo systemctl start netris-nhp

   # Check status
   sudo systemctl status netris-nhp

   # View logs
   sudo journalctl -u netris-nhp -f

Manual Execution
^^^^^^^^^^^^^^^^

.. code-block:: bash

   # Run in foreground
   sudo /opt/netris/bin/netris-nhp -config /opt/netris/etc/netris.conf

   # Run in foreground with debug logging
   sudo /opt/netris/bin/netris-nhp -debug -config /opt/netris/etc/netris.conf

Monitoring NHN
~~~~~~~~~~~~~~

View Real-Time Logs
^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   # Follow systemd logs
   sudo journalctl -u netris-nhp -f

   # View last 100 lines
   sudo journalctl -u netris-nhp -n 100

Stopping NHN
~~~~~~~~~~~~

.. code-block:: bash

   # Stop the service
   sudo systemctl stop netris-nhp

Network Configuration Formats
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

NHN supports two network configuration formats, automatically detected based on the system's network manager.

Network Manager Auto-Detection
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

NHN automatically detects which network manager to use:

1. **Checks for systemd-networkd**

   .. code-block:: bash

      systemctl status systemd-networkd

   If active → uses netplan.

2. **Falls back to networking service**

   .. code-block:: bash

      systemctl status networking

   If present → uses ifupdown.

Netplan (systemd-networkd)
^^^^^^^^^^^^^^^^^^^^^^^^^^

**When used:** System is running systemd-networkd

**Generated file:** ``/etc/netplan/dpu_config.yaml``

**Key Features**

- YAML format.
- Supports ethernets and bonds.
- Routes configured per interface/bond.
- MTU configuration.
- LACP bonding with 802.3ad.

**Example output**

.. code-block:: yaml

   network:
     version: 2
     renderer: networkd
     ethernets:
       ens3:
         dhcp4: false
         dhcp6: false
         mtu: 9000
         addresses:
           - 192.168.1.10/24
         routes:
           - to: 0.0.0.0/0
             via: 192.168.1.1
     bonds:
       bond0:
         interfaces:
           - ens4
           - ens5
         addresses:
           - 10.0.0.10/24
         routes:
           - to: 10.1.0.0/16
             via: 10.0.0.1
         parameters:
           mode: 802.3ad
           mii-monitor-interval: 100
           lacp-rate: fast

Ifupdown (Ubuntu interfaces)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**When used:** System is running networking service (not systemd-networkd).

**Generated file:** ``/etc/network/interfaces.d/netris-nhn``

**Key Features**

- Text-based interface format.
- Supports interfaces and bonds.
- Routes via post-up/pre-down hooks.
- LACP bonding.

**Example output**

.. code-block::

   # Interface: ens3
   auto ens3
   iface ens3 inet static
       address 192.168.1.10/24
       gateway 192.168.1.1
       mtu 9000

   # Bond: bond0
   auto bond0
   iface bond0 inet static
       address 10.0.0.10/24
       bond-mode 802.3ad
       bond-miimon 100
       bond-lacp-rate 1
       bond-slaves ens4 ens5
       post-up ip route add 10.1.0.0/16 via 10.0.0.1 dev bond0 || true
       pre-down ip route del 10.1.0.0/16 via 10.0.0.1 dev bond0 || true

NHN-DOCA: BlueField3 Configuration
----------------------------------

What the bf3-config Does
~~~~~~~~~~~~~~~~~~~~~~~~

The ``bf3-config`` performs these steps in order:

1. **Pre-flight Checks**

   - Verifies root privileges.
   - Creates lock file to prevent concurrent runs.
   - Loads configuration.

2. **Package Verification** (unless ``-skip-install`` specified)

   - Checks for required packages.
   - Reports missing packages and exits if any are absent.

3. **Service Management**

   - Starts and enables ``rshim`` service.
   - Starts and enables ``mst`` service.

4. **Device Discovery**

   - Enumerates MST devices using ``mst status``.
   - Brings up network interfaces.
   - Queries LLDP information from each interface.
   - Filters devices based on ``ew-switch-name-template`` regex.
   - Auto-detects Spectrum-X version from switch description.

5. **Firmware Verification**

   - Checks firmware version on each device.
   - Validates against minimum version for detected Spectrum-X release.
   - Flags devices needing updates.

6. **Capability Configuration**

   - *Note:* Changes require a reboot to take effect.

7. **RoCE QoS and Adaptive Routing**

8. **NVN Congestion Control**

   - Enables ECN on RoCE RP and NP.
   - Spawns ``doca_nvn_cc`` daemon process.
   - Applies version-specific configurations:

     - **Spectrum-X v1.2:** Disables DCQCN, configures RTT without counters.
     - **Spectrum-X v1.3:** Enables Base RTT, Global Min RTT, and counter-based mode.

9. **Inter-Packet Gap (IPG)**

**When Reboot Is Required**

The ``bf3-config`` will inform you if a reboot is necessary. A reboot is required when:

- Firmware was updated.
- Capabilities were changed.

After rebooting, run ``bf3-config`` again to complete configuration.

Using the bf3-config
~~~~~~~~~~~~~~~~~~~~

**Command-Line Options**

.. code-block:: bash

   /opt/netris/bin/bf3-config [OPTIONS]

   Options:
     -config <path>      Path to configuration file (default: /opt/netris/etc/netris.conf)
     -debug              Enable debug logging for detailed output
     -version            Display version information
     -skip-install       Skip package and firmware installation checks
     -attempts <n>       Number of LLDP discovery retry attempts (default: 5)

**Examples:**

Standard Installation

.. code-block:: bash

   /opt/netris/bin/bf3-config

Installation with Debug Logging

.. code-block:: bash

   /opt/netris/bin/bf3-config -debug

Skip Package Checks (if already installed)

.. code-block:: bash

   /opt/netris/bin/bf3-config -skip-install

Increase LLDP discovery retries, if LLDP discovery is taking time to populate:

.. code-block:: bash

   /opt/netris/bin/bf3-config -attempts 10

What the Verifier Does
~~~~~~~~~~~~~~~~~~~~~~

The verifier performs read-only checks without making changes:

1. **Pre-flight Checks**

   - Verifies root privileges.
   - Loads configuration.

2. **Package Verification**

   - Checks for ``doca-ofed`` and ``doca-host``.

3. **Service Status**

   - Verifies ``rshim`` service is active.

4. **Device Discovery**

   - Enumerates MST devices.
   - Uses LLDP to identify east-west fabric NICs.
   - Auto-detects Spectrum-X version.

5. **Firmware Verification**

   - Checks firmware version meets minimum requirements.

6. **Capability Verification**

   - Validates all Spectrum-X capabilities are enabled.

7. **RoCE QoS Verification**

8. **NVN Congestion Control Verification**

9. **IPG Verification**

   - Checks IPG register value for L3EVPN.

10. **Error Reporting**

    - Generates LLDP custom TLV messages with error details.
    - Writes configuration to ``/etc/lldpd.d/lldp-netris.conf``.
    - Restarts ``lldpd`` service if configuration changed.

Using the Verifier
~~~~~~~~~~~~~~~~~~

**Command-Line Options**

.. code-block:: bash

   /opt/netris/bin/verifier [OPTIONS]

   Options:
     -config <path>      Path to configuration file (default: /opt/netris/etc/netris.conf)
     -debug              Enable debug logging for detailed output
     -version            Display version information
     -attempts <n>       Number of LLDP discovery retry attempts (default: 5)

**Examples:**

Standard Verification

.. code-block:: bash

   /opt/netris/bin/verifier

Verification with Debug Logging

.. code-block:: bash

   /opt/netris/bin/verifier -debug
