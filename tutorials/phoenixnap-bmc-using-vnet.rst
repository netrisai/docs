##################################################################
Using V-Net (isolated virtual network) services in phoenixNAP BMC
##################################################################

V-Net, under Services --> V-Net, is an isolated virtual network service. Netris loads your bare metal server metadata from phoenixNAP BMC into the Netris database. So when you create a V-Net service (a virtual network), you list the bare-metal servers you need to get on that virtual network. 

Netris V-Net (in phoenixNAP BMC scenario) has a global VLAN ID. Per every V-Net, Netris will provision a Private Network using phoenixNAP BMC API. Then Netris will include the listed bare metal servers + SoftGate nodes into that newly created Private Network. SoftGate nodes are the default gateway for the V-Net services. 

Adding Subnets for V-Net
========================

Before starting to use the V-NETs, you need to create a few subnets of private IP address blocks to be used by you and your colleagues later on for creating V-Nets. For now you can set the Tenant field to Admin, but in the future if you need to create a separate user role that should be able to consume Netris VPC but not administer it, you will need to create a separate Tenant and give that Tenant IP resources.

.. image:: /tutorials/images/phoenixnap-netris-create-common-subnets.png
    :align: center
   
Creating a V-Net
========================

You should create a corresponding V-Net for each virtual network if you use Vmware, KVM, or any other server virtualization platform or VLANs in any way. VLAN ID will be the unique identifier between Netris, phoenixNAP BMC, and your Compute.

.. image:: /tutorials/images/phoenixnap-netris-creating-vnet.png
    :align: center

.. # [todo] add NAT scenario

In this example, the new V-NET has VLAN ID 3000, subnet 10.128.1.0/24, and gateway 10.128.1.1. That means three servers (server-01, server-02, server-03) can launch VMs (or subinterfaces) into a virtual network with VLAN ID 3000, and they should use IP addresses from 10.128.1.2-254 pointing to 10.128.1.1 as the default gateway or use DHCP. Netris SoftGate will serve that traffic, and since we have enabled NAT globally in previous chapters, hosts living in VLAN 3000 will have Internet access over the NAT.

.. image:: /tutorials/images/phoenixnap-netris-vnet-ready.png
    :align: center

Note that you can use Services --> ACLs for granular control over traffic between multiple V-NETs as well as to/from outside (Internet or other. remote sites)  
