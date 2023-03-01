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

Tags
====

Starting from Netris `v3.3.0 <https://www.netris.io/netris-release-3-3-0>`_, it is possible to dynamically associate bare-metal servers with V-NET. For that, set any tag to the V-NET and add the same tag to the metal server(s). Then, Netris will include and exclude metal servers to the Layer-2 network based on that tag. Due to this, you can make flexible V-NETs, and there is no need to include every new server in the V-NET.

.. image:: /tutorials/images/equinix-metal-vnet-with-tag.png
    :align: center

This feature is even more efficient when you build your infrastructure via Terraform. For example, let's say you've created a V-NET with a tag using Netris Terraform Provider, then order several metal servers with the same tag using Equinix Metal Terraform Provider. And that's it, when the servers are ready, Netris will detect them and make them part of the V-NET.

.. image:: /tutorials/images/equinix-metal-vnet-with-tag-terraform.png
    :align: center

Unmanaged
=========

Another option is turning the existing Layer-2 network (VLAN) into Netris V-Net. All VLANs in the particular project that aren't used in other services, like an E-BGP, are visible as "unmanaged" in the  V-Net section.

.. image:: /tutorials/images/unmanaged-vlan-equinix.png
    :align: center
.. image:: /tutorials/images/unmanaged-vnet.png
    :align: center

The "manage" button will open a dialogue window where it's also possible to add a default gateway for the appropriate VLAN.


.. warning::
  Once the VLAN is being converted into V-Net, it will be managed by Netris and no longer manageable through Equinix Metal console.

.. image:: /tutorials/images/manage-vnet.gif
    :align: center

Note that you can use Services --> ACLs for granular control over traffic between multiple V-NETs as well as to/from outside (Internet or other remote sites)  
