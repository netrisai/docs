.. meta::
    :description: Definitions

===========
Definitions
===========

The following nomenclature appears throughout this documentation. Entries are grouped by topic for quick lookup. For the high-level picture, see the :doc:`Introduction <introduction>` and :doc:`Netris Architecture <netris-architecture>` pages.

Access and roles
----------------

* **User** - An account for accessing the Netris Controller through the web console, REST API, or Terraform. Users authenticate against the controller and are assigned permissions through User Roles and Permission Groups. Default administrator credentials are documented in :doc:`Controller Installation </installation/installation>` and must be changed immediately after deployment.

* **User Role** - A named group of permissions and tenants used to implement role-based access control (RBAC). Apply a role to a user to grant scoped access to network resources.

* **Permission Group** - A set of per-section permissions that can be attached individually to a User or to a User Role.

* **Tenant** - A named principal used to delegate management of network resources. A Tenant has only a unique name and an optional description; it carries no quota, billing identity, or login of its own. Tenants are referenced from objects that support ownership (VPC, V-Net, IPAM allocations and subnets, Inventory units, switch ports, L4 Load Balancer, Server Cluster) and from User accounts to scope which resources a user can administer. The built-in ``Admin`` tenant owns all resources by default; additional tenants are created to delegate self-service access to other teams — for example, a DevOps team using the Netris Controller GUI, Kubernetes CRDs, or Terraform.

.. TODO: Enumerate the specific parameters managed by Admin Tenant for VPC and V-Net once confirmed with engineering/architects.

* **Admin Tenant** - The tenant that owns a VPC or V-Net and can manage all of its parameters.

* **Guest Tenant** - A tenant granted delegated access to add and remove resources inside a VPC or V-Net, without permission to change the parameters of the VPC or V-Net itself. Guest Tenants of a VPC can add and remove services inside the VPC (V-Nets, L4 Load Balancers, Server Clusters, IPAM subnets). Guest Tenants of a V-Net can add and remove switch ports in the V-Net.

Fabric roles
------------

Brief glossary entries for the four AI data center fabric roles. The :doc:`Introduction <introduction>` covers each fabric in depth with reference architecture diagrams.

* **North-South (frontend) fabric** - The Ethernet fabric that connects the data center to the outside world (ISPs, peering, WAN, public Internet) and carries tenant API traffic, storage traffic, and the data path for ingress and egress services such as NAT and L4 load balancing. Also called the *frontend network*.

* **East-West (backend, scale-out) fabric** - A dedicated, high-bandwidth, lossless network that connects GPU servers to each other for collective communications. Implemented over Ethernet (e.g., NVIDIA Spectrum-X) or over InfiniBand using NVIDIA Quantum. Also called the *backend network* or *scale-out network*.

* **NVL72 (rack-scale) fabric** - An NVLink-based, in-rack fabric that connects up to 72 GPUs in a single liquid-cooled rack into one NVLink domain. Ships with NVIDIA GB200 NVL72 and GB300 NVL72 rack-scale systems. Managed by NVIDIA NMX, with Netris integration for tenant NVLink partitions.

* **Out-of-band (OOB) management fabric** - A separate management network used to reach the management interfaces of every device in the deployment. Carries no tenant traffic. Can be deployed as part of the North-South fabric or as a standalone fabric.

Network constructs
------------------

* **Netris VPC** - A logically segregated virtual network. A Netris VPC acts as a VRF in traditional networking, allowing overlapping IP ranges across different VPCs while keeping resources securely managed and isolated.

* **V-Net (Virtual Network)** - A Netris construct for grouping switch ports into a defined network segment — much like a traditional VLAN or a public cloud subnet. A virtual networking service that provides Layer 2 (unrouted) or Layer 3 (routed) virtual network segments inside a Netris VPC. A V-Net is assigned to one VPC and one or more sites. Endpoints (servers, VMs) are connected to V-Nets.

    * **L2VPN (Layer 2 Virtual Private Network)** - A V-Net type similar to a traditional VLAN, implemented with modern, scalable techniques.
    * **L3VPN (Layer 3 Virtual Private Network)** - A V-Net type typically used for back-end (East-West) connectivity in GPU clusters on Ethernet-based AI fabrics (e.g., NVIDIA Spectrum-X). Built as one mini-subnet per switch port, a VXLAN L3VPN is conceptually similar to MPLS L3VPN in provider networks.

* **Site** - A discrete deployment — a region, data center, or other location. All network components and resources are associated with their respective Site and VPC. A Site entry defines global attributes such as AS numbers, default ACL policy, and other site-level parameters.

* **IPAM** - IP Address Management. Create IP allocations and subnet assignments per VPC. Allocations may overlap between different VPCs. A subnet can be assigned to multiple sites to extend a V-Net across multiple locations.

* **Subnet** - An IPv4 or IPv6 address resource linked to one or more Sites and Tenants.

* **Switch Port** - A physical port on a Netris-managed switch, or a server endpoint in a Bare Metal Cloud environment.

Services
--------

* **NAT services** - SNAT lets your endpoints communicate with the Internet. DNAT lets your endpoints be reached from the Internet.

* **Load-balancing service** - A Netris service that distributes traffic across a pool of endpoints using L4 load balancing.

* **Access lists (ACLs)** - A layer of security that acts as a firewall, controlling traffic in and out of one or more subnets.

* **External connections** - Connect a VPC to ISP providers or to other segments of your network. Use the Netris E-BGP service for dynamic peering, or define a V-Net with static routes. For natively integrated Bare Metal Cloud Providers, external connections typically establish automatically — refer to the provider-specific tutorial.

* **E-BGP** - The Netris service that defines all External BGP peers (iBGP and eBGP).

* **SoftGate (VPC Gateway)** - An optional, multi-tenant software component that provides ingress and egress connectivity services (elastic IPs, NAT, tenant-specific connectivity, L4 load balancing) for VPCs. Runs on dedicated bare-metal x86 servers. See :doc:`netris-softgate-HS`.

AI-specific
-----------

* **SU (Scalable Unit)** - In the context of NVIDIA Spectrum-X deployments, a Scalable Unit is a group of GPU servers. Netris uses SUs as the standard unit of scale for rail-optimized topology calculations.

* **Server Cluster** - A group of servers that share the same network configuration, defined by a Server Cluster Template. When a Server Cluster is created, Netris automatically provisions the required VPCs, V-Nets, IPAM subnets, and (when configured) InfiniBand PKeys and NVLink partitions for all servers in the cluster. See :doc:`server-cluster`.

* **Server Cluster Template** - A JSON template that defines the network configuration to be applied to servers in a Server Cluster. Templates specify V-Net types, IP addressing schemes, and integration parameters for Ethernet, InfiniBand, and NVLink fabrics.

Infrastructure and operations
-----------------------------

* **Controller Management Network (CMN)** - A physically separate, non-Netris-managed network that connects Netris Controller nodes and seed switches. Not one of the four fabric roles; exists to prevent circular dependencies between the controller and the fabrics that the controller manages. See the :ref:`management_network_architecture` section of Netris Architecture for the full design.

* **Seed switches** - A set of 2 to 6 Netris-managed switches provisioned before any other Netris-managed switches in a deployment. Seed switches connect their management interfaces directly to the CMN and form the root of the OOB management hierarchy in Hybrid OOB (hierarchical) deployments. Not used in Direct-to-CMN deployments. See :ref:`management_network_architecture`.

* **Direct-to-CMN deployment topology** - A management plane topology in which all Netris-managed switches connect their management interfaces directly to the CMN. No seed switches are required. Suitable for smaller deployments — typically up to about 90 Netris-managed switches. See :ref:`management_network_architecture`.

* **Hybrid OOB (hierarchical) deployment topology** - A management plane topology in which a small set of seed switches connects directly to the CMN and forms the root of an OOB management hierarchy. The remaining Netris-managed switches connect their management interfaces to the OOB network. Used for larger deployments. See :ref:`management_network_architecture`.

* **Inventory** - The collection of all Netris-managed network units in the system — switches, SoftGate nodes, and DPUs — each running a Netris agent and registered with the Netris Controller.

* **Inventory Profile** - A configuration baseline applied to managed switches, SoftGate nodes, and DPUs. Includes management access allow-lists, fabric optimization settings, and GPU cluster-specific parameters such as QoS for RoCE. See :doc:`inventory-profile`.
