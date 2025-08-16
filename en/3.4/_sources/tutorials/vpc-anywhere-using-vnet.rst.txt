.. meta::
  :description: Using V-Net (isolated virtual network) services

###############################################
Using V-Net (isolated virtual network) services
###############################################

V-Net, under Services --> The V-Net service is a virtual network that operates in an isolated environment. In Netris, each V-Net takes the next available VLAN ID from the :doc:`Site's defined VLAN ID range <vpc-anywhere-check-default-site>` and uses it as a global VLAN ID. The SoftGate nodes serve as the default gateway for the V-Net services.


   
Creating a V-Net
================

To ensure proper connectivity, it is recommended to create a corresponding V-Net for each virtual network used in Vmware, KVM, or any other server virtualization platform. The same applies to an isolated group of physical servers. VLAN ID serves as the unique identifier between Netris and the computing platform used.

.. image:: /tutorials/images/vpc-anywhere-vnet.png
    :align: center

In this example, the new V-NET is assigned VLAN ID 700, subnet 172.24.0.0/20, and gateway 172.24.0.1. As a result, on your Compute side, you can launch VMs or subinterfaces on physical servers with a VLAN ID of 700 and obtain all necessary IP configurations from DHCP. Alternatively, if you prefer not to use DHCP, instances should use IP addresses from the 172.24.0.0/20 subnet and set the default gateway to 172.24.0.1. Netris SoftGate will manage this traffic, and the preconfigured MASQUERADE rule for the 172.24.0.0/16 subnet included in the Netris Controller will enable hosts in VLAN 700 to have internet access through NAT.

Note that you can use Services --> ACLs for granular control over traffic between multiple V-NETs as well as to/from outside (Internet or other remote sites)  
