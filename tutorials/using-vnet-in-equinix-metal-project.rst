########################################################################
Using V-Net (isolated virtual network) services in Equinix Metal Project
########################################################################

V-Net, under Services --> V-Net,  is an isolated virtual network service. Netris loads your bare metal server metadata from Equinix Metal Project into the Netris database. So when you create a V-Net service (a virtual network), you list the bare-metal servers you need to get on that virtual network. 

Netris V-Net (in Equinix Metal scenario) has a global VLAN ID. Per every V-Net, Netris will provision a Layer-2 network using Equinix Metal API. Then Netris will include the listed bare metal servers + SoftGate nodes into that newly created Layer-2 network. SoftGate nodes are the default gateway for the V-Net services. 

You should create a corresponding V-Net for each virtual network if you use Vmware, KVM, or any other server virtualization platform or VLANs in any way. VLAN ID will be the unique identifier between Netris, Equinix, and your Compute.

.. image:: /tutorials/images/netris-creating-vnet-for-equinix-metal.png
    :align: center

In this example, the new V-NET has VLAN ID 2, subnet 10.0.0.0/24, and gateway 10.0.0.1. That means three servers (server-01, server-02, server-03) can launch VMs (or subinterfaces) into a virtual network with VLAN ID 2, and they should use IP addresses from 10.0.0.2-254 pointing to 10.0.0.1 as the default gateway. Netris SoftGate will serve that traffic, and since we have enabled NAT globally in previous chapters, hosts living in VLAN 2 will have Internet access over the NAT.

.. image:: /tutorials/images/netris-vnet-ready-in-equinix-metal.png
    :align: center

Note that you can use Services --> ACLs for granular control over traffic between multiple V-NETs as well as to/from outside (Internet or other. remote sites)  
