.. meta::
    :description: Netris Host Networking Plugin

Netris Host Networking
======================

Overview
--------

The Netris Host Networking Plugin is an optional component that automates the host-side networking required for GPU servers running on NVIDIA Spectrum-X East-West fabrics. It configures and maintains the BlueField3/ConnectX7/ConnectX8 SuperNICs as required by the NVIDIA Spectrum-X Deployment Guide. Because the BlueField3/ConnectX7/ConnectX8 Spectrum-X settings are normally non-persistent and must be reapplied on every boot event, Netris developed the NHN Plugin to handle the firmware checks, DMS behavior, RoCE and Adaptive Routing parameters, congestion control tuning, and other Spectrum-X requirements to remove the operational burden of managing the BlueField3/ConnectX7/ConnectX8 configuration manually or through custom scripts.

In addition to managing the SuperNIC, the plugin generates and maintains the Linux host's network configuration using either netplan or ifupdown based on automatically detecting which network manager is active. This ensures that the host and the SuperNIC remain consistently configured with the correct Spectrum-X settings across reboots and link events.

How It Works
------------

.. warning::

   Starting with Netris 4.9 release, the Netris Host Networking Plugin supports only Spectrum-X Reference Architecture version 2.1.2. Support for earlier Spectrum-X Reference Architectures has been deprecated. See :doc:`Netris 4.9 Release Notes <release-notes/4.9.0>` for details.
   You may find earlier version of this document in the Netris 4.8 documentation: `Netris Host Networking Plugin <https://www.netris.io/docs/en/4.8/ai-netris-host-networking.html>`_.

The Netris Host Networking Plugin receives the server's networking metadata from the directly connected Netris-managed NVIDIA Spectrum-X switches. These switches, in turn, communicate with the Netris Controller to receive these metadata, repackage it into custom LLDP TLVs, and deliver it to the intended GPU servers over the local link.

On the GPU server, the NHN plugin extracts the metadata from the LLDP messages, generates the appropriate configuration, and applies it to both the BlueField3/ConnectX7/ConnectX8 SuperNIC and the host's network stack. If NHN detects any issues—such as missing parameters, firmware mismatches, or other validation failures—it returns error information to the Netris Controller using the same LLDP mechanism via the directly connected switches.

Because NHN operates entirely through LLDP, it does not require any direct connectivity to the Netris Controller. This improves scalability and the overall security posture of the deployment.

To configure and validate the BlueField3/ConnectX7/ConnectX8 SuperNIC's configuration, the NHN daemon automatically runs:

- **bf3-config** — Configures the BlueField3/ConnectX7/ConnectX8 SuperNICs with the Spectrum-X settings required for East-West fabric operation, as described in the NVIDIA Spectrum-X Deployment Guide.
- **verifier** — Validates the BlueField3/ConnectX7/ConnectX8 configuration and sends discovered issues to the Netris Controller using LLDP.

Together, these functions keep both the host and the SuperNIC aligned with the Spectrum-X fabric's intended state without requiring custom scripts or manual reconfiguration.

Before You Begin
----------------

System Requirements
~~~~~~~~~~~~~~~~~~~

- Ubuntu Linux
- NVIDIA BlueField3/ConnectX7/ConnectX8 SuperNIC.
- Netris-managed NVIDIA Cumulus Linux switches.
- LLDP is enabled on the server.

Dependencies
~~~~~~~~~~~~

- Netris
- lldpd: LLDP daemon (required)
- systemd (for netplan mode) or ifupdown (for interfaces mode)

NVIDIA BlueField3/ConnectX7/ConnectX8
- doca-host - DOCA host software stack
- doca-all  - DOCA ALL profile
- doca-ofed - NVIDIA OFED drivers for DOCA
- mft - Mellanox Firmware Tools
- libnccl2, libnccl-dev - NCCL and Spectrum-X NCCL Plugin
- netplan.io - Network configuration management

.. note::

   The above NVIDIA packages must be obtained from `Nvidia directly <https://developer.nvidia.com/doca-downloads?deployment_platform=Host-Server&deployment_package=DOCA-Host&target_os=Linux&Architecture=x86_64&Profile=doca-all&Distribution=Ubuntu&version=24.04&installer_type=deb_local>`_ and are not distributed by Netris.

Recommended NVIDIA Component Versions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Spectrum-X v2.1.2
^^^^^^^^^^^^^^^^^
+---------------------------------+--------------+------------+--------------+--------------+--------------+--------------+
| Component                       | GPU Platform |            |              |              |              |              |
+---------------------------------+--------------+------------+--------------+--------------+--------------+--------------+
|                                 | H100         | H200       | B200         | GB200        | B300         | GB300        |
+=================================+==============+============+==============+==============+==============+==============+
| Cumulus Linux OS                | 5.16.1       | 5.16.1     | 5.16.1       | 5.16.1       | 5.16.1       | 5.16.1       |
+---------------------------------+--------------+------------+--------------+--------------+--------------+--------------+
| ConnectX7 SuperNic Firmware     | 28.48.1000   | 28.48.1000 | 28.48.1120   | 28.48.1120   | N/A          | N/A          |
+---------------------------------+--------------+------------+--------------+--------------+--------------+--------------+
| ConnectX8 SuperNic Firmware     | N/A          | N/A        | N/A          | N/A          | 40.48.1120   | 40.48.1120   |
+---------------------------------+--------------+------------+--------------+--------------+--------------+--------------+
| BlueField3 SuperNic Firmware    | 32.48.1000   | 32.48.1000 | 32.48.1000   | N/A          | N/A          | N/A          |
+---------------------------------+--------------+------------+--------------+--------------+--------------+--------------+
| BlueField Firmware Bundle (BFB) | 3.3.0        | 3.3.0      | 3.3.0        | N/A          | N/A          | N/A          |
+---------------------------------+--------------+------------+--------------+--------------+--------------+--------------+
| NCCL                            | 2.29.2       | 2.29.2     | 2.29.2       | 2.29.2       | 2.29.2       | 2.29.2       |
+---------------------------------+--------------+------------+--------------+--------------+--------------+--------------+
| DOCA Host                       | 3.3.0        | 3.3.0      | 3.3.0-088814 | 3.3.0-088814 | 3.3.0-088814 | 3.3.0-088814 |
|                                 |              |            |              |              |              |              |
+---------------------------------+--------------+------------+--------------+--------------+--------------+--------------+



Permissions
~~~~~~~~~~~

Must run as root (requires access to netlink and network configuration)

Installation Overview
---------------------

1. Install the netris-hnp Netris Host Networking package.
2. Review the configuration file `/opt/netris/etc/netris.conf`.
3. Download and install the NVIDIA dependencies for the BlueField-3/ConnectX7/ConnectX8 SuperNICs.
4. Run the SuperNIC configurator `/opt/netris/bin/bf3-config`.
5. Verify the SuperNIC configuration with `/opt/netris/bin/verifier`.
6. Start the NHN daemon.

Installation
------------

Download and install the GPG key for the Netris repository:

::

   wget -qO - https://repo.netris.ai/repo/public.key | sudo gpg --dearmor -o /usr/share/keyrings/netris.gpg

Add the Netris repository to your system's sources list:

::

   echo "deb [signed-by=/usr/share/keyrings/netris.gpg] http://repo.netris.ai/repo/ noble main" | sudo tee /etc/apt/sources.list.d/netris.list

Install the Netris NHN Package

::

   sudo apt update && sudo apt install netris-hnp

Configuration
-------------

1. Review the Configuration File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Default location: `/opt/netris/etc/netris.conf`

The configuration file uses INI format with sections for different components.

::

   [general]

   # Regex pattern to match East-West fabric switch names
   # Default matches patterns like: su0-r0, su1-r1, su2-r3, etc.
   ew-switch-name-template = su[0-9]-+r[0-3]+

   # Plane type: number of independent network planes in the Spectrum-X compute fabric
   # Supported values: SINGLE , DUAL , QUAD
   # Default value: SINGLE
   plane-type=single

   # Path to ifupdown configuration file
   ifupdown_cfg_path = /etc/network/interfaces.d/dpu_config

   # Path to netplan configuration file
   netplan_cfg_path = /etc/netplan/dpu_config.yaml

   # Cache directory for device information
   cache_file_path = /opt/netris/cache

   # Path to the verifier binary
   verifier_bin_path = /opt/netris/bin/verifier

   # Path to bf3-config binary
   bf3config_bin_path= /opt/netris/bin/bf3-config

   # How often to run verification (in seconds)
   verifier_run_interval = 300

   # How often to run bf3-config with --skip-install option (in seconds)
   bf3config_run_interval = 150

   # Network plugin update interval (in seconds)
   network_plugin_run_interval = 20

   # If not empty, force to use the selected network manager (supported values: ifupdown, netplan).
   force_network_manager=

.. tip::

   The `ew-switch-name-template` parameter is critical for identifying which network interfaces are connected to the East-West fabric. It's a regex pattern used to identify which network interfaces are connected to the East-West fabric.

Examples:

::

   # Match switches named su0-r0, su1-r1, etc.
   ew-switch-name-template = su[0-9]-+r[0-3]+

   # Match switches with 'ew-' prefix
   ew-switch-name-template = ew-.+

   # Match any switch with 'fabric' in the name
   ew-switch-name-template = .*fabric.*

2. Configure BlueField3/ConnectX7/ConnectX8 NICs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Download and install the required BlueField3/ConnectX7/ConnectX8 packages. See the NVIDIA Spectrum-X Deployment Guide version appropriate for your product.

Once NVIDIA packages are installed, execute the command to configure the BlueField3/ConnectX7/ConnectX8 NICs

::

   /opt/netris/bin/bf3-config

The bf3-config will inform you if a reboot is required. A reboot is required when:

- Firmware was updated
- Capabilities were changed

After rebooting, run the `bf3-config` again to complete the configuration.

3. Verify BlueField3/ConnectX7/ConnectX8 NICs Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To ensure that the NIC's parameters are correctly configured and there are no errors, run the following command

::

   /opt/netris/bin/verifier

4. Start the NHN daemon
~~~~~~~~~~~~~~~~~~~~~~~

After preparing the server and (if applicable) the SuperNIC, start NHN:

::

   sudo systemctl start netris-hnp

NHN will begin discovering interfaces, reading LLDP information from the switches, and applying the correct host network configuration automatically.

Operating the NHN plugin
------------------------

Starting NHN
~~~~~~~~~~~~

As a Systemd Service (Recommended)

::

   # Start the service
   sudo systemctl start netris-hnp

   # Check status
   sudo systemctl status netris-hnp

   # View logs
   sudo journalctl -u netris-hnp -f

Manual Execution

::

   # Run in foreground
   sudo /opt/netris/bin/netris-hnp -config /opt/netris/etc/netris.conf

   # Run in foreground with debug logging
   sudo /opt/netris/bin/netris-hnp -debug -config /opt/netris/etc/netris.conf

Monitoring NHN
~~~~~~~~~~~~~~

::

   # Follow systemd logs
   sudo journalctl -u netris-hnp -f

   # View last 100 lines
   sudo journalctl -u netris-hnp -n 100

Stopping NHN
~~~~~~~~~~~~

::

   # Stop the service
   sudo systemctl stop netris-hnp

Using the bf3-config
--------------------

Command-Line Options
~~~~~~~~~~~~~~~~~~~~

`/opt/netris/bin/bf3-config [OPTIONS]`

Options:

::

     -config <path>      Path to configuration file (default: /opt/netris/etc/netris.conf)
     -debug              Enable debug logging for detailed output
     -version            Display version information
     -skip-install       Skip package and firmware installation checks
     -attempts <n>       Number of LLDP discovery retry attempts (default: 5)

Examples
~~~~~~~~

Standard Installation

::

   /opt/netris/bin/bf3-config

Installation with Debug Logging

::

   /opt/netris/bin/bf3-config -debug

Skip Package Checks (if already installed)

::

   /opt/netris/bin/bf3-config -skip-install

Increase LLDP Discovery Retries, if LLDP discovery is taking time to populate:

::

   /opt/netris/bin/bf3-config -attempts 10

Using the Verifier
------------------

Command-Line Options
~~~~~~~~~~~~~~~~~~~~

`/opt/netris/bin/verifier [OPTIONS]`

Options:

::

     -config <path>      Path to configuration file (default: /opt/netris/etc/netris.conf)
     -debug              Enable debug logging for detailed output
     -version            Display version information
     -attempts <n>       Number of LLDP discovery retry attempts (default: 5)

Examples
~~~~~~~~

Standard Verification

::

   /opt/netris/bin/verifier

Verification with Debug Logging

::

   /opt/netris/bin/verifier -debug

Network Configuration Formats
-----------------------------

NHN supports two network configuration formats, automatically detected based on the system's network manager.

Network Manager Auto-Detection
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

NHN automatically detects which network manager to use.

If systemd-networkd is active, NHN will use netplan; otherwise, NHN falls back to the networking service.

Netplan (systemd-networkd)
~~~~~~~~~~~~~~~~~~~~~~~~~~

When used: System is running systemd-networkd

Generated file: `/etc/netplan/dpu_config.yaml`

Key features:

- YAML format
- Routes configured per interface/bond
- MTU configuration

Ifupdown (Ubuntu interfaces)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When used: System is running networking service (not systemd-networkd)

Generated file: `/etc/network/interfaces.d/netris-nhn`

Key features:

- Text-based interface format
- Routes via post-up/pre-down hooks