##########
IPAM setup
##########


Netris IPAM enables users to manage their IP addresses and monitor pool usage effectively. It features a hierarchical view to facilitate various subnetting tasks.
Users must first assign specific roles (purposes) to each subnet or address before they can utilize these subnets in services such as V-Net, NAT, Load Balancing, etc..
Each VPC has its own IPAM table.

**Create allocations**

There are two primary types of IP prefixes: allocations and subnets. Allocations consist of IP ranges assigned to an organization through RIR/LIR or private IP ranges intended for network use. Subnets, on the other hand, are prefixes that will be utilized in various services. Subnets always fall under allocations, while allocations do not have parent subnets.

In addition to the predefined subnets, the Netris Controller also includes predefined allocations, consisting of private IP addresses defined in RFC 1918 - 10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16. If you intend to create subnets that fall outside of these predefined allocations, you should first create allocations that encompass those subnets.

.. image:: images/ipam_allocation.png
  :align: center

**Create subnets for devices**

You will require two subnets for your devices: one for loopback IP addresses and another for the management network. Note that device subnets must reside in the System VPC.

.. image:: images/ipam_mgmt_subnet.png
  :align: center

.. image:: images/ipam_loopback_subnet.png
  :align: center


**Create subnets for V-Nets**

Create at least one subnet with the Common purpose to use it for a new V-Net. IP addresses from this subnet will be assigned to your servers.

.. image:: images/ipam_common_subnet.png
  :align: center


**Create subnets for Load-balancing service**

If you plan to use load-balancing services, you should first define subnet(s) from which IP addresses will be assigned for Virtual IP (frontend).

.. image:: images/ipam_l4lb_subnet.png
  :align: center


**Create subnets for NAT service**

If you plan to perform network address translation (NAT), you must first create subnets for this purpose.

.. image:: images/ipam_nat_subnet.png
  :align: center


