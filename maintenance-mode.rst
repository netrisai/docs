.. meta::
    :description: Netris System Visibility, Monitoring & Telemetry

**********************
Maintenance Mode
**********************

Overview
=================
Maintenance mode is designed to help gracefully offload the traffic from a specific device from your inventory in order to perform maintenance on the current device with minimal impact on your network. You should turn on **Maintenance Mode** before starting the maintenance on the device and once it is finished, turn off again. To enable/disable **Maintenance Mode** go to **Inventory** section, choose the device you want, from 3-dot menu click edit, turn on **Maintenance Mode** by clicking on the checkbox and then save your changes as shown in the screenshot below:

.. image:: images/maintenance-mode.png
    :align: center

.. note:: 
  Maintenance mode does its best to offload the traffic from the current device however it DOES NOT ensure that traffic will be completely offloaded.
    
Maintenance Mode for Softgate
========

When enabling **Maintenance Mode** for the softgate following actions are automatically done behind the scenes to offload the traffic from the softgate:

  - Decrease BGP local preference attribute for all external and internal peers.
  - Prepend all routes 10x times for outbound direction for all external and internal peers.
  - Increase BGP MED attribute for all external and internal peers.
  - Decrease BGP origin attribute for all external and internal peers.
  - Connection oriented services like SNAT and L4LB will be automatically migrated to second softgate causing a reestablishment of TCP connections.

.. note:: 
  - Ensure that second softgate is functioning properly before turning on the maintenance mode.
  
Maintenance Mode for Switch
=========

When enabling **Maintenance Mode** for the switch following actions are automatically done behind the scenes to offload the traffic from the switch:

  - Decrease BGP local preference attribute for all external and internal peers.
  - Prepend all routes 10x times for outbound direction for all external and internal peers.
  - Increase BGP MED attribute for all external and internal peers.
  - Decrease BGP origin attribute for all external and internal peers.
  - LACP system ID will be changed for EVPN Multihomed hosts causing reshuffling of traffic from ports facing to multihomed hosts to other switches where these hosts are also connected.

.. note:: 
  - If a host is multhihomed to 2 switches and first one is in **Maintenance Mode**, and the link connected to the second switch flaps, then the link connected to the first switch will become active and will not automatically reshuffle back to the second switch.
