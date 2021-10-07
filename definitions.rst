.. meta::
    :description: Definitions

===========
Definitions
===========

* **User** - A user account for accessing Netris Controller through GUI, RestAPI, and Kubernetes. The default username is ``netris``, with password ``newNet0ps``. 
* **Tenant** - IP addresses and Switch Ports are network resources assigned to different Tenants to have under their management. Admin is the default tenant, and by default, it owns all the resources. You can use different Tenants for sharing and delegation of control over the network resources. Network teams typically use Tenants to grant access to other groups to request & manage network services using the Netris Controller as a self-service portal or programmatically (with Kubernetes CRDs) DevOps/NetOps pipeline.  
* **Permission Group** - List of permissions on a per section basis can be attached individually to a User or a User Role.  
* **User Role** - Group of user permissions and tenants for role-based access control. 

* **Site** - Each separate deployment (each data center) should be defined as a Site. All network units and resources are attached to a site. Netris Controller comes with a "default" site preconfigured. Site entry defines global attributes such as; AS numbers, default ACL policy, Site Mesh (site to site VPN) type.
* **Subnet** - IPv4/IPv6 address resources linked to Sites and Tenants. 
* **Switch Port** - Physical ports of all switches attached to the system. Switch port objects represent statuses, take basic parameters, and are assigned to Tenants.
* **Inventory** - This is an inventory of all network units that are operated using Netris Agent.
* **E-BGP** - Is for defining all External BGP peers (iBGP and eBGP). 