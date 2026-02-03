=============================================
Topology & Wiring Validation
=============================================

Topology & wiring validation is designed to identify wiring errors and suggest fixes. (how is it vs how is it supposed to be)

Switch-to-switch and Switch-to-SoftGate
#######################################

Topology wiring validation between backbone links, switch-to-switch, and switch-to-SoftGate happens fully automatically without any user input. Netris agents running on switches and SoftGate nodes perform LLDP neighbor lookups and compare the actual neighbor device & interface with the blueprint (Network->Topology), and in case of a mismatch, report the inconsistency.

The below screenshot demonstrates a case when two cables between the leaf and the spine switches are miswired.

.. image:: switch-to-switch-cables-swapped.png
  :align: center

Switch-to-Server 
################

Enabling wiring validation between switches and servers. 

*Requirements*

 * Server objects should be created and wired to switches in the Netris->Network->Topology
 * Server objects should have mapping of Netris interface names (eth1, eth2, eth3, etc.) and expected interface names on the server (enp47s0, enp3s0, enp4s0, etc.)
 * LLDP service should be running on the server and responding to standard LLDP neighbor queries
                                                                 
**How to define interface mappings?**

The JSON snippet below should be included in every server's custom field. Commonly it's done through Terraform when initializing-creating servers in the Inventory. 
                                                                 
.. code-block:: shell-session

 {
  "topology-validation": {
    "hostname": "hgx-pod00-su0-h00",
    "eth1": "enp10s0",
    "eth2": "enp7s0",
    "eth3": "enp47s0",
    "eth4": "enp1s0",
    "eth5": "enp17s0",
    "eth6": "enp22s0",
    "eth7": "enp2s0",
    "eth8": "enp0s0",
    "eth9": "enp99s0",
    "eth10": "enp8s0",
    "eth11": "enp9s0"
  }
 }

``topology-validation`` tells Netris to enable server-to-switch wiring validation for the given server
``"hostname": "hgx-pod00-su0-h00"`` tells Netris that the expected hostname of the server should be ``"hgx-pod00-su0-h00"`` -- so Netris will LLDP lookup for the hostname and compare to this value.
``"eth1": "enp10s0",`` lines tell Netris what should be the expected (normal) interface name (enp10s0 in this example) for the logical "eth1" in the Netris Topology. Typically, most users standardize groups of servers for interface order and names; that way, the mapping is the same for all servers in a given group (vendor/type). Typically this data is inserted through Terraform for convenience, or through the web console, one-by-one.


The below screenshot demonstrates a case, from two leaf switches perspective, when two cables between two leaf switches and server NICs are miswired.

.. image:: switch-to-server-cables-swapped.png
  :align: center

