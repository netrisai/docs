.. meta::
    :description: Custom Configuration Snippets

=============================
Custom Configuration Snippets
=============================

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
========

Netris lets administrators deploy custom switch configurations using configuration snippets.

Snippets are plain-text configuration fragments that merge into the configuration the Netris agent generates before applying it to the switch.

Configuration snippets are supported on switches running Arista EOS and NVIDIA Cumulus Linux (NVUE).

.. tip::
   **Snippets become part of the enforced configuration.** The Netris agent treats the combined configuration — the agent-generated configuration plus your snippets — as the switch's desired state. Each agent run reconciles the switch against this combined configuration, so snippet-provided settings are maintained on an ongoing basis, the same way agent-managed settings are.

.. warning::
   **Test snippets before applying them broadly.** Snippet content is appended after the agent-generated configuration and, in most cases, takes precedence for the specific settings it defines. The exact outcome depends on how the switch resolves concurrent configuration for those commands — some settings merge, others override — so behavior can vary by platform and by the specific configuration involved.

   Include every dependency your snippet needs, and validate the combined configuration in a low-impact environment before rolling it out more broadly.

.. tip::
   Because snippets live only on the switch and aren't tracked by the controller, plan to reapply your snippet files whenever you reprovision a switch.

Arista EOS
==========

The Netris agent creates a dedicated directory on the switch for snippets:

.. code-block:: text

   /mnt/flash/netris-snippets

**Selection rules:**

1. Only files whose name contains ``.conf`` are included. Anything else in the directory — other files, subdirectories, sockets, devices, or editor leftovers like ``foo.conf~`` — is ignored. Selection is by filename only.
2. Files are read in filename sort order, so use a naming convention — such as a numeric prefix — to control merge order of multiple snippet files: ``00-snippet.conf``, ``01-snippet.conf``, etc.
3. Snippet contents are appended to the end of the generated ``new_config.conf``, before the trailing ``END``, in that sort order — after the agent-generated configuration.

**Example:**

1. Determine the desired EOS configuration. For example,

.. code-block:: text

   management api http-commands
      vrf default
         no shutdown

2. Save it as a file under ``/mnt/flash/netris-snippets/`` using the numeric-prefix convention — for example, ``/mnt/flash/netris-snippets/00-api-http-commands.conf``.

3. On the next agent run, this fragment is appended to the end of ``new_config.conf`` (before ``END``) and applied to the switch along with the agent-generated configuration.

NVIDIA Cumulus Linux (NVUE)
===========================

The Netris agent creates and manages a directory on the switch that holds the switch's full configuration, generated locally based on the intent defined on the controller:

.. code-block:: text

   /opt/netris/etc/nvue/

.. tip::
   This directory holds the agent's own configuration files alongside your snippet files — add your snippets into this same directory.

**Selection rules:**

1. Only files with a ``.yaml`` extension are considered. Anything else in the directory is ignored.
2. Files are read in filename sort order, so use a naming convention — such as a numeric prefix — to control merge order among multiple snippet files: ``00-snippet.yaml``, ``01-snippet.yaml``, etc.
3. Snippet contents are merged into the agent-generated configuration in that sort order.

**Example:**

1. Stage the desired configuration using NVUE commands:

.. code-block:: shell-session

   nv set system snmp-server state enabled
   nv set system snmp-server listening-address all vrf mgmt
   nv set system snmp-server listening-address all-v6 vrf mgmt
   nv set system snmp-server readonly-community clear_text access any

2. Retrieve the YAML version of the configuration diff:

.. code-block:: shell-session

   nv config diff

.. code-block:: yaml

   - set:
      system:
        snmp-server:
          listening-address:
            all:
              vrf: mgmt
            all-v6:
              vrf: mgmt
          readonly-community:
            $nvsec$bc2dea2ea717f9e9aef0265a8f09f949:
              access:
                any: {}
          state: enabled

3. Create a file under ``/opt/netris/etc/nvue/`` with the YAML content retrieved in step 2, using the numeric-prefix convention. For example, create the file ``/opt/netris/etc/nvue/50-snmp.yaml`` with the content above.

4. Check that the configuration in the file is correct:

.. code-block:: shell-session

   nv config patch /opt/netris/etc/nvue/<file>
   nv config diff

5. Check for any configuration errors by applying it manually:

.. code-block:: shell-session

   nv config apply
