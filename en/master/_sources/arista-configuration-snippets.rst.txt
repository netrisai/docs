.. meta::
    :description: Custom Arista Configuration Snippets

====================================
Custom Arista Configuration Snippets
====================================

Netris allows administrators to deploy custom configuration to switches running Arista EOS using configuration snippets. These snippets are plain EOS CLI configuration fragments that are merged into the configuration the agent generates before it's applied to the switch, letting clients apply local customizations the controller doesn't yet support without patching the agent.

The agent reads snippets from a fixed directory on the switch:

.. code-block:: text

  /mnt/flash/netris-snippets

.. tip::
  This path is a constant and entirely operator-managed, meaning the agent does not create this directory, write to it, or modify its contents.

**Selection rules:**

1. Only files whose name contains ``.conf`` are included. Anything else in the directory — other files, subdirectories, sockets, devices, or editor leftovers like ``foo.conf~`` — is ignored. Selection is by filename only.
2. Files are read in filename sort order, so a numeric prefix convention is required to control merge order: ``00-snippet.conf``, ``01-snippet.conf``, etc.
3. Snippet contents are appended to the end of the generated ``new_config.conf``, before the trailing ``END``, in that sort order — after the controller-managed configuration.

**Example:**

1. Determine the desired EOS configuration. For example,

.. code-block:: text

  management api http-commands
     vrf default
        no shutdown

2. Save it as a file under ``/mnt/flash/netris-snippets/`` using the numeric-prefix convention — for example, ``/mnt/flash/netris-snippets/00-api-http-commands.conf``.

3. On the next agent run, this fragment is appended to the end of ``new_config.conf`` (before ``END``) and applied to the switch along with the controller-generated configuration.
