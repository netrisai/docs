.. meta::
    :description: Link Aggregation

======================
Link Aggregation (LAG)
======================

Link Aggregation (LAG), also known as link bundling, Ethernet/network/NIC bonding, or port teaming, is a method of combining (aggregating) multiple network connections in parallel to increase throughput beyond what a single connection could sustain and to provide redundancy in case one of the links fails.

The Link Aggregation Control Protocol (LACP) is a key component of LAG. It's a protocol for the collective handling of multiple physical ports that can be seen as a single channel for network traffic. 

Netris supports two modes of configuring LAGs.


Automatic LAG and EVPN Multi-homing
-----------------------------------

EVPN Multi-Homing (EVPN-MH) offers robust support for an all-active redundancy model for servers. This means that all connections from a server to multiple switches are concurrently active and operational, ensuring high availability, load balancing, and seamless failover capabilities. As a result, EVPN-MH enhances network resilience and continuity of service.

Limitations:
Switch OS Cumulus 5.3 or higher. 
One port per switch (can be overcome in Custom LAG).
Only two switches in EVPN-MH domain with ASIC Spectrum A1.

When you add switch ports to a V-net service, Netris agents automatically configure LAG and apply LACP with EVPN-MH and LACP fallback. If you hit EVPN Multi-Homing limitations, regular LACP LAG will be configured. This configuration results in an active-standby link setup from the server's perspective. Furthermore, if the server does not have LACP configured, one link will still remain active due to the implementation of LACP fallback.

To create a V-net with EVPN-MH go to Service → V-net → +Add

.. image:: images/lag_add_vnet.png
   :align: center
   :alt: Add LAG to V-net
   :class: with-shadow
   

Custom LAG
----------

There are several use cases when you may need a Custom (manually configured) LAG.

LAG with/without EVPN-MH utilizes more than one port per switch.
LACP must be disabled on the switch side. EVPN-MH will be deactivated in this case.

Please note that a Custom LAG can only be created with one switch. However, if you add two or more Custom LAGs to a V-net, EVPN-MH will be automatically activated.

To create a Custom LAG go to Network → Network Interfaces.

.. image:: images/lag_add_lag.png
   :align: center
   :alt: Add Custom LAG
   :class: with-shadow

Add a new LAG.

.. image:: images/lag_add_lag2.png
   :align: center
   :alt: Add Custom LAG
   :class: with-shadow
 
Set necessary options.
  
.. image:: images/lag_add_lag3.png
   :align: center
   :alt: Add Custom LAG
   :class: with-shadow
