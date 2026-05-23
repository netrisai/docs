.. meta::
    :description: Definitions

===========
Definitions
===========

When configuring and operating a Netris system, the following nomenclature is important to understand:

* **User** - An account for accessing the Netris Controller through the web console, REST API, or Kubernetes integration. Users authenticate against the controller and are assigned permissions through User Roles and Permission Groups. Default administrator credentials are documented in :doc:`Controller Installation </installation/installation>` and must be changed immediately after deployment.

* **Netris VPC** - logically segregated virtual network.The VPC acts as a VRF in traditional networking, providing the flexibility to employ overlapping IP ranges across various VPCs while maintaining secure management and operation of resources.

* **V-Net (Virtual Network)** is a Netris construct for grouping switch ports into a defined network segment—much like a traditional VLAN or a public cloud subnet. It is a virtual networking service that provides Layer-2 (unrouted) or Layer-3 (routed) virtual network segments in a Netris VPC. V-Net is assigned to one VPC and one or multiple sites. Your endpoints (servers, VMs) are connected to V-Nets.

    * **L2VPN (Layer 2 Virtual Private Network)** is a V-Net type and is similar to a traditional VLAN with modern and scalable implementation.
    * **L3VPN** is a V–Net type and is typically used for back-end (east–west) connectivity in GPU clusters on Ethernet-based AI fabrics such as NVIDIA Spectrum-X. Built as one mini-subnet per switch port, a VXLAN L3VPN is conceptually similar to MPLS L3VPN in provider networks.

* **Tenant** - IP addresses and Switch Ports are network resources assigned to different Tenants to have under their management. Admin is the default tenant, and by default, it owns all the resources. You can use different Tenants for sharing and delegation of control over the network resources. Network teams typically use Tenants to grant access to other groups to request and manage network services using the Netris Controller as a self-service portal or programmatically (with Kubernetes CRDs or Terraform) via a DevOps/NetOps pipeline.

* **Permission Group** - List of permissions on a per section basis can be attached individually to a User or a User Role. 

* **User Role** - Group of user permissions and tenants for role-based access control (RBAC).

* **Site** - Each separate deployment (a region or a data center) should be defined as a Site. All network components and resources should be associated with their respective Site and VPC. Site entry defines global attributes such as; AS numbers, default ACL policy, and other site-level parameters.

* **IPAM** - You can create IP Allocations and Subnet assignments for a VPC. These may overlap between different VPCs. A Subnet can be assigned to multiple sites if you aim to extend your V-Net to multiple locations.

* **Subnet** - IPv4/IPv6 address resources linked to *Sites* and *Tenants* 

* **Switch Port** - Physical ports of all switches attached to the system, or server endpoints in a Bare Metal Cloud environment.

* **Inventory** - Inventory of all network units that are operated using Netris Agent.

* **External connections** - You can connect your VPC to ISP providers or other segments of your network using Netris E-BGP service, or statically by defining a V-Net and using Net->Routes. For natively integrated Bare Metal Cloud Providers, please refer to the provider-specific tutorial, as external connections usually establish automatically.

* **E-BGP** - Defines all External BGP peers (iBGP and eBGP).

* **NAT services** - SNAT allows your endpoints to communicate with the Internet. DNAT allows your endpoints to be accessible from the Internet.

* **Load-balancing service** - A Netris service that distributes traffic across a pool of endpoints using L4 load balancing.

* **Access lists** - ACLs provide a layer of security that acts as a firewall for controlling traffic in and out of one or more subnets.

* **SU (Scalable Unit)** - In the context of NVIDIA Spectrum-X deployments, a Scalable Unit is a group of GPU servers. Netris uses SUs as the standard unit of scale for rail-optimized topology calculations.

* **Server Cluster** - A group of servers that share the same network configuration, defined by a Server Cluster Template. When a Server Cluster is created, Netris automatically provisions the required VPCs, V-Nets, IPAM subnets, and (when configured) InfiniBand PKeys and NVLink partitions for all servers in the cluster. See :doc:`server-cluster`.

* **Server Cluster Template** - A JSON template that defines the network configuration to be applied to servers in a Server Cluster. Templates specify V-Net types, IP addressing schemes, and integration parameters for Ethernet, InfiniBand, and NVLink fabrics.

* **SoftGate (VPC Gateway)** - An optional, multi-tenant software component that provides ingress and egress connectivity services (elastic IPs, NAT, tenant-specific connectivity, L4 load balancing) for VPCs. Runs on dedicated bare-metal x86 servers. See :doc:`netris-softgate-HS`.

* **Inventory Profile** - A configuration baseline applied to managed switches, SoftGate nodes, and DPUs. Includes management access allow-lists, fabric optimization settings, and GPU cluster-specific parameters such as QoS for RoCE. See :doc:`inventory-profile`.
