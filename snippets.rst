.. meta::
    :description: Custom NVUE Configuration Snippets

==================================
Custom NVUE Configuration Snippets
==================================

Netris allows administrators to deploy custom configuration to switches running Cumulus Linux using NVUE configuration snippets. These snippets are YAML files that define specific configurations to be applied to the network devices.

Example:

1. Stage desired configuration using NVUE commands

.. code-block:: bash

  nv set system snmp-server state enabled
  nv set system snmp-server listening-address all vrf mgmt
  nv set system snmp-server listening-address all-v6 vrf mgmt
  nv set system snmp-server readonly-community clear_text access any

2. Retreive the YAML version of the configuration diff

.. code-block:: bash
  
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


3. create a file under /opt/netris/etc/nvue/ with the YAML content you retrieved in step 2. For example, create the file /opt/netris/etc/nvue/50-snmp-yaml with the content above.

4. Check if the configuration on the file is correct:

.. code-block:: bash

  nv config patch /opt/netris/etc/<file> then nv config diff

5. Check for any configuration errors by applying manually

.. code-block:: bash
  
  nv config apply
