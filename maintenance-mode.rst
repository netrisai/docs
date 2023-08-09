.. meta::
    :description: Netris System Visibility, Monitoring & Telemetry

**********************
Maintenance Mode
**********************

Overview
=================
Maintenance mode is intended to assist in smoothly redirecting traffic away from a particular device in your inventory. This redirection allows for maintenance to be carried out on the device without causing significant disruptions to your network. It's advisable to activate Maintenance Mode prior to initiating maintenance procedures on the device. Once the maintenance is completed, you can deactivate Maintenance Mode. To toggle Maintenance Mode on or off, navigate to the Inventory section. Select the desired device, click on the three-dot menu, choose the "Edit" option, and then enable Maintenance Mode by selecting the checkbox and saving the changes as illustrated in the screenshot below:

.. image:: images/maintenance-mode.png
    :align: center

.. note:: 
  Maintenance mode strives to redirect traffic away from the current device; however, please note that it does not guarantee the complete offloading of traffic.
    
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
