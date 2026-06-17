.. meta::
     :description: VPC Connect

==============
VPC Connect
==============

Overview
============

VPC Connect provides a mechanism for connecting tenant VPCs with external networks, including non-Netris-managed data center networks, WAN routers, and security appliances.

.. image:: images/VPC-Connect.svg
    :align: center
    :class: with-shadow

.. raw:: html

   <p style="text-align: center;"><em>Figure: Netris VPC Connect</em></p>

Netris can expose a switch port on the North-South fabric. When a single-tenant VPC is in scope, the port is configured as a routed port, and the eBGP neighbor relationship terminates directly on that switch port. When multiple tenant VPCs are in scope, the port is configured as IEEE 802.1Q tagged, with each tenant mapped to a dedicated VLAN, and eBGP neighbor relationships terminate on corresponding SVIs (Switch Virtual Interfaces) established on the switch or elsewhere in the fabric, as determined by Netris.

Route exchange between tenant VPCs and the external network is explicitly controlled using route-maps and prefix-lists, allowing operators to define which prefixes are advertised in each direction while preserving clear routing boundaries.

The external endpoint—such as a router, firewall, or other network transport device—is typically owned and operated by the operator's networking team.

More details are coming soon...