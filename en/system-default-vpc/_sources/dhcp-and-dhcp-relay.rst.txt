.. meta::
    :description: DHCP and DHCP Relay for V-Nets

.. _vnet_dhcp:

====================
DHCP and DHCP Relay
====================

L2VPN routed V-Nets (where an IP gateway is added) may also be configured with a DHCP service fully managed by Netris and hosted on SoftGate.

You can configure additional DHCP Option Sets before enabling a DHCP server for any V-Net. Add a DHCP Options Set by navigating to ``Services -> DHCP Options Sets`` and clicking ``+Add`` in the top right.

.. image:: images/dhcp-option-set.png
    :alt: DHCP Option Set
    :align: center
    :class: with-shadow

.. raw:: html

  <br />

Netris supports a wide range of Standard DHCP Options.

.. image:: images/dhcp-standard-options.png
    :alt: Standard DHCP Options
    :align: center
    :class: with-shadow

.. raw:: html

  <br />

Netris also enables you to define Custom DHCP Options.

.. image:: images/dhcp-custom-options.png
    :alt: Custom DHCP Options
    :align: center
    :class: with-shadow

.. raw:: html

  <br />

DHCP Relay
==========
Netris supports using an external DHCP server by enabling the DHCP Relay function. This allows DHCP clients inside a V-Net to obtain addresses from a non-Netris-managed DHCP server running in the same or another VPC. Both DHCPv4 and DHCPv6 are supported.

To configure DHCP Relay in a V-Net:
 - Specify the VPC where the DHCP server is located.
 - Enter the IP addresses of the primary and (optionally) backup DHCP servers.

.. tip::
  In a V-Net a DHCP Relay service and a DHCP service cannot be enabled simultaneously.

.. image:: images/vnet-dhcp-relay.png
    :alt: DHCP Relay
    :align: center
    :class: with-shadow

.. raw:: html

    <br />

.. note::
  When a V-Net and the DHCP server specified in the DHCP Relay configuration are homed in different VPCs, VPC peering is mandatory. Without it, the relay traffic cannot reach the DHCP server. Configure peering under Network → VPC Peering in the Controller.

  Non-overlapping IP ranges are required between the client VPCs (e.g., VPC-Alpha1) and the DHCP server's VPC (VPC-Shared-Infra). The DHCP server must be able to route back to the client's V-Net.

  Switch loopback IP is the source IP of relayed packets.

.. raw:: html

  <br />

Example:
""""""""

Suppose you have tenant workloads in VPC-Bravo1 and VPC-Alpha1. Both need DHCP, but you want to run a single DHCP service in VPC-Shared-Infra.

.. image:: images/vnet-dhcp-relay-diagram.png
    :alt: DHCP Relay
    :align: center
    :class: with-shadow

.. raw:: html

  <br />

1. In each tenant's V-Net (VPC-Bravo1 and VPC-Alpha1), enable DHCP Relay and set the DHCP server address to the IPs of the DHCP servers in VPC-Shared-Infra.

  .. image:: images/dhcp-relay-coke.png
      :alt: DHCP Relay
      :align: center
      :class: with-shadow

  .. raw:: html

    <br />

  .. image:: images/dhcp-relay-pepsi.png
      :alt: DHCP Relay
      :align: center
      :class: with-shadow

  .. raw:: html

    <br />

  .. image:: images/dhcp-relay-shared.png
      :alt: DHCP Relay
      :align: center
      :class: with-shadow

  .. raw:: html

    <br />

2. Establish VPC peering between VPC-Bravo1 ↔ VPC-Shared-Infra and VPC-Alpha1 ↔ VPC-Shared-Infra.

  .. image:: images/dhcp-relay-vpc-peer-coke.png
      :alt: DHCP Relay
      :align: center
      :class: with-shadow

  .. raw:: html

    <br />

  .. image:: images/dhcp-relay-vpc-peer-pepsi.png
      :alt: DHCP Relay
      :align: center
      :class: with-shadow

  .. raw:: html

    <br />


Now:
 - DHCP clients in the tenant VPCs (VPC-Bravo1 and VPC-Alpha1) broadcast their DHCP requests normally in their respective V-Nets
 - Netris configures the fabric to forward these requests across the peering link to the DHCP server in the VPC-Shared-Infra VPC.
