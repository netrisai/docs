.. meta::
  :description: Using V-Net (isolated virtual network) services in phoenixNAP BMC

.. _phxnap_vnet:

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
================

You should create a corresponding V-Net for each virtual network if you use Vmware, KVM, or any other server virtualization platform or VLANs in any way. VLAN ID will be the unique identifier between Netris, phoenixNAP BMC, and your Compute.

.. image:: /tutorials/images/phoenixnap-netris-creating-vnet.png
    :align: center

In this example, the new V-NET has VLAN ID 3000, subnet 10.128.1.0/24, and gateway 10.128.1.1. That means three servers (server-01, server-02, server-03) can launch VMs (or subinterfaces) into a virtual network with VLAN ID 3000, and they should use IP addresses from 10.128.1.2-254 pointing to 10.128.1.1 as the default gateway or use DHCP. Netris SoftGate will serve that traffic, and since we have enabled NAT globally in previous chapters, hosts living in VLAN 3000 will have Internet access over the NAT.

.. image:: /tutorials/images/phoenixnap-netris-vnet-ready.png
    :align: center


Deploy a new server into an existing V-Net
------------------------------------------

Netris creates a private network in phoenixNAP BMC based on declared V-Nets. Besides creation, Netris continuously monitors that private networks. As a result of this continuous monitoring, you can't edit private networks created by Netris from the phoenixNAP BMC console. However, if any modifications are made, Netris will automatically roll everything back to its state. 

The only exception is a case with newly deployed servers. When you request a server from phoenixNAP BMC without any public IP address, use some Netris V-Net as a private network and mark the DHCP checkbox "**Use your own privately managed DHCP server (Obtain IP address automatically)**" - Netris will automatically add that server into the V-Net.

.. image:: /tutorials/images/phoenixnap-vnet-import-a-new-server.png
    :align: center

Thanks to that functionality, you can request a bare-metal server directly into Netris V-Net. As a result, you will have bare-metal servers in a private subnet that can connect to services outside your VPC (since we have enabled NAT globally in previous chapters), but external services cannot initiate a connection with those servers. Once the servers have been provisioned, they will get a private IP from Netris DHCP, and you can find those IPs by pressing the "**IP/MAC Info**" button on the V-NET.

.. image:: /tutorials/images/phoenixnap-vnet-imported-new-server.png
    :align: center

In order to connect via SSH to the newly deployed server, you can either create a DNAT rule and connect via Public IP, or if you don't need permanent ssh access to that server, you can simply connect using Softgate as a JumpHost.

.. code-block:: shell-session

  ssh -o ProxyCommand="ssh -W %h:%p ubuntu@<SoftGate Main IP>" ubuntu@<Server Private IP>


.. image:: /tutorials/images/phoenixnap-vnet-ssh-to-server.png
    :align: center


Tags
----

Tags are used to associate bare-metal servers with V-NET dynamically. For that, set any tag to the V-NET and add the same tag to the metal server(s). Then, Netris will include and exclude metal servers from the Private Network based on that tag. Thus, you can make flexible V-NETs, and there is no need to include every new server in the V-NET.

.. image:: /tutorials/images/phoenixnap-vnet-with-tag.png
    :align: center

This feature is even more efficient when you build your infrastructure via Terraform. For example, let's say you've created a V-NET with a tag using Netris Terraform Provider, then order several servers with the same tag using phoenixNAP Terraform Provider. And that's it, when the servers are ready, Netris will detect them and make them part of the V-NET.

.. image:: /tutorials/images/phoenixnap-vnet-with-tag-terraform.png
    :align: center


Unmanaged
---------

Another option is turning the existing private network into Netris V-Net. All private networks from the allowed VLAN IDs range and in the proper location that Netris has not created are visible as "unmanaged" in the V-Net section.

.. image:: /tutorials/images/phoenixnap-vnet-unmanaged-vnet.png
    :align: center

The "manage" button will open a dialogue window where it's also possible to add a default gateway for the appropriate VLAN.


.. warning::
  Once the private network is being converted into V-Net, it will be managed by Netris and no longer manageable through phoenixNAP BMC console.

.. image:: /tutorials/images/phoenixnap-vnet-managed-vnet.png
    :align: center

Note that you can use Services --> ACLs for granular control over traffic between multiple V-NETs as well as to/from outside (Internet or other remote sites)  
