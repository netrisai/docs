.. meta::
  :description: Netris VPC anywhere upstream peering options

***********************************
Connecting VPC to upstream networks
***********************************

There are two connection options available for VPC anywhere. Please choose to use one of them.

Using a VLAN with public IP addresses (DMZ)
===========================================
Netris VPC can use a traditional subnet or vlan with public IP addresses (a DMZ network) for upstream network peering. 

In this scenario, Upstream ISP provides a subnet with default gateway to reach Internet. Typically each SoftGate node will use an IP address from ISP's subnet and will use default gateway provided by ISP. It is possible to assign multiple IP addresses on SoftGate nodes enabling SoftGates to act as :ref:`"L3 Load Balancer"<l3lb_def>`, :ref:`"L4 Load Balancer"<l4lb_def>`, :ref:`"NAT functionality"<nat_def>`  (including 1 to 1 NAT) <<OTHERS?>>.

**logical diagram**

.. image:: images/upstream-dmz-logical.png

**physical diagram**

.. image:: images/upstream-dmz-physical.png

Traditional subnet: configuration
---------------------------------
| The configuration starts from defining the subnet(s) reqired in Net->IPAM section, this process is documented in details in :ref:`"IP Address Management"<ipam_def>` section. Minimum two IP subnets are needed, one for management and second for connecting to ISP.




BGP Upstream
============
BGP Upstream: overview
----------------------
A BGP peering between Netris VPC and upstream routers is the most recommended option, especially for production use.

In this scenario, SoftGate nodes form BGP peering with upstream routers. Typically each BGP session will use an individual VLAN id and /30 subnet. Upstream BGP router should advertise the default route 0.0.0.0/0 or full Internet table if necessary. Netris SoftGate nodes are designed to handle over 1M routes in the routing table and can perform as border routers for the full-view table.
SoftGate nodes will automatically advertise public IP subnets in the current site as defined under the Net->IPAM section. Alternatively, you can optionally alter the default settings for full granular control over sent and received prefixes.

**Logical diagram**

.. image:: images/vpc-anywhere-upstream-bgp-router-logical.png
    :align: center


**Physical diagram**

.. image:: images/vpc-anywhere-upstream-bgp-router-physical.png
    :align: center


BGP Upstream: configuration
---------------------------

Your local public AS number is a site attribute located under the Net->Sites section. You can use the default private AS number or change to a real AS number depending on local network architecture needs.

.. image:: images/local-public-asn.png
    :align: center

BGP peers can be defined under the Net->E-BGP section. 

.. image:: images/add-new-ebgp-form.png


Check BGP neighbor statuses under the Net->E-BGP 

.. image:: images/bgp-listing.png


To check/trobleshoot BGP use Net->Looking Glass

.. image:: images/bgp-looking-glass.png

