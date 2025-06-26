.. meta::
    :description: Server Cluster and Server Cluster Template

============
Server Cluster and Server Cluster Template
============

In Netris, A **Server Cluster** is a high-level abstraction representing a group of servers that share a uniform network configuration, driven by a common template. While it appears as a list of servers, its true function is to resolve into a deterministic set of switch port configurations and associated virtual networks.

By referencing a **Server Cluster Template** when defining a Server Cluster, Netris is able to  automatically infer which switch ports to configure, how to configure them (e.g., tagging, VLANs, LAGs), and which V-Nets to instantiate in the switch fabric and across those ports. This abstraction allows operators to manage complex, multi-server networking scenarios declaratively—without having to manually define VPCs, V-Nets, or individually select switchports to include.

In practice, this means a Server Cluster acts as a blueprint-to-deployment bridge: a network engineer defines the design once in the template, and from there, DevOps or infrastructure teams can deploy and scale server environments with full network consistency and minimal involvement from the networking team.

Server Cluster Template
=======================

Before a Server Cluster can be created, a Server Cluster Template must be defined. The template specifies the network configuration that will be applied consistently to every server in the cluster, including which network interfaces on the servers correspond to which V-Nets, VLAN tagging, IP addressing, and other relevant parameters.

Prior to the introduction of the Server Cluster and the Server Cluster Template functionality the engineer was required to navigate to ``Network->VPC``, ``Network->IPAM``, and ``Services->V-Net`` sections and create these objects, list switch ports for Netris to implement the necessary configurations.

With the introduction of Server Cluster and Server Cluster Template, the network engineer can now define these higher-level abstractions, and Netris will automatically create the necessary VPC, IPAM, and V-Net objects based on the server names and their network interfaces. This is particularly beneficial for cloud providers, as it abstracts away the complexity of dealing with individual switch ports, allowing cloud builders to focus on server-level configurations.

Restrictions:
-----------------

* This functionality assumes that server NIC names are consistent across all servers in the cluster. For example, if eth1 is used for east-west traffic on one server, it should be the same on all other servers in that cluster.

Template Fields Explained:
--------------------------

Typically, a Server Cluster Template is made up of just two key-value pairs:

- Name: A descriptive name for the template.

- Vnets: A JSON array defining the V-Nets to be created for each server in the cluster. Each object in the array includes:

  - postfix: A string appended to the server cluster name to form the V-Net name.
  - type: The type of V-Net (e.g., l2vpn, l3vpn, netris-ufm).
  - vlan: Specifies whether the V-Net is tagged or untagged.
  - vlanID: The VLAN ID, which can be set to 'auto' for automatic assignment.
  - serverNics: An array of NIC names on the server that will be associated with this V-Net.
  - ipv4Gateway (optional): The IPv4 gateway for the V-Net, if applicable.
  - ipv4DhcpEnabled (optional): Boolean to enable/disable DHCP for IPv4.
  - ipv6Gateway (optional): The IPv6 gateway for the V-Net, if applicable.
  - Ufm (optional): UFM settings for type "netris-ufm". See UFM documentation for details.
  - Pkey (optional): Pkey settings for type "netris-ufm". See UFM documentation for details.

- ID: A unique identifier for the template, typically auto-generated and is not exposed to the user.

Server Cluster Template Example
--------------------------------

In this example, we have 11 NICs per server, where eth1-eth8 are for east-west traffic (L3VPN VXLAN), eth9-eth10 are for north-south traffic (L2VPN VXLAN with EVPN-MH bonding enabled), and eth11 is for out-of-band management (L2VPN VXLAN) and a UFM V-Net.

.. code-block:: shell-session

  {
    "name": "My-Cluster-Template-flavor",
    "vnets": [
      {
          "postfix": "East-West",
          "type": "l3vpn",
          "vlan": "untagged",
          "vlanID": "auto",
          "serverNics": [
              "eth1",
              "eth2",
              "eth3",
              "eth4",
              "eth5",
              "eth6",
              "eth7",
              "eth8"
          ]
      },
      {
          "postfix": "North-South-in-band-and-storage",
          "type": "l2vpn",
          "vlan": "untagged",
          "vlanID": "auto",
          "serverNics": [
              "eth9",
              "eth10"
          ],
          "ipv4Gateway": "192.168.7.254/21"
      },
      {
          "postfix": "OOB-Management",
          "type": "l2vpn",
          "vlan": "untagged",
          "vlanID": "auto",
          "serverNics": [
              "eth11"
          ],
          "ipv4Gateway": "192.168.15.254/21"
      },
      {
          "postfix": "UFM8",
          "type": "netris-ufm",
          "ufm": "ufm-88",
          "pkey": "auto"
      }
    ]
  }

Adding a Server Cluster Template
--------------------------------

To define a Server Cluster Template in the web console, navigate to ``Services->Server Cluster Template`` - click ``+Add``, give the template a descriptive name like 'GPU-Cluster-Template'. Enter JSON style configuration defining V-Nets and which server NICs must be placed into these V-Nets. 

.. image:: images/add-server-cluster-template.png
  :align: center
  :class: with-shadow
  
.. raw:: html
  
  <br />

Note that when using the UI, the JSON configuration shall only include the 'vnets' array, as the 'name' field is provided separately in the form. The 'id' field is auto-generated and should not be included in the UI input.

Server Cluster
==============

With a Server Cluster Template defined, a Server Cluster can be instantiated by referencing that template and specifying a list of servers. This operation triggers the creation of network primitives—such as V-Nets, IP subnets, and switch port configurations—based on the template’s definitions. It is important to note that defining a template alone does not result in the creation of any network constructs; resources are only provisioned upon the creation of a Server Cluster that uses the template.

To define a Server CLuster navigate to ``Services->Server Cluster`` and click +Add. Give the new cluster a name, set Admin to the appropriate tenant (this is define who can edit/delete this cluster), set the site, set VPC to 'create new', select the Template created earlier, and click +Add server to start selecting server members. Click Add.

Go ahead and create another Server Cluster, including the next 10 servers—or any other servers. The system won’t let you 'double-book' any server in more than one cluster, to avoid conflicts.

Shared Endpoints
----------------

In most cases, servers in a cluster are exclusively assigned. Each physical server belongs to one server cluster and is provisioned for a single tenant. This exclusive ownership model ensures clear operational boundaries, simplifies networking logic, and supports deterministic switch configuration. It is the expected behavior for bare metal infrastructure.

However, certain infrastructure components, such as hypervisors or shared storage nodes, may need to serve multiple tenants simultaneously. In such cases, these endpoints must participate in more than one server cluster.

To support this need, Netris allows administrators to designate specific endpoints as shared. A shared endpoint may be assigned to multiple server clusters, making it possible for virtualized workloads running on shared infrastructure (e.g., VMs) to be exposed across tenant boundaries.

Designating an endpoint as shared changes how the associated switch port is provisioned. Netris automatically configures the switch port in tagged mode, or the functional equivalent in environments such as InfiniBand or NVLink. In essence:

Shared endpoint = Tagged switch port

This is the primary behavioral change triggered by marking an endpoint as shared.

It is important to note that server clusters do not automatically account for hypervisor mobility scenarios (such as VM migration in platforms like VMware). Ensuring all relevant hypervisors are appropriately included in each server cluster is the responsibility of the orchestrator or cloud operator.

Netris enforces exclusivity and sharing as mutually exclusive states. If an endpoint is added as a shared member in one server cluster, it must not appear as an exclusive member in another. The system will reject such conflicting configurations to avoid ambiguity in switch port management.

Additionally, Netris does not manage of influence the internal networking configurations of hypervisors or shared storage nodes. The responsibility for ensuring that virtual machines or storage services are correctly networked within their respective environments lies with the orchestrator or cloud operator.

Server Cluster Fields Explained:
--------------------------

- Name: A descriptive name for the server cluster.
- Admin: The tenant that administers this server cluster.
- Site: The site where the server cluster is located.
- VPC: The VPC to which the server cluster belongs. Typically set to 'create new' to generate a new VPC.
- Template: The Server Cluster Template that defines the network configuration for this cluster.
- Servers: An array of server names that are exclusive members of this cluster.
- SharedEndpoints: An array of server names that are shared members of this cluster.

Adding a Server Cluster
-----------------------

To define a Server Cluster in the web console, navigate to ``Services->Server Cluster`` - click ``+Add``, give the cluster a descriptive name. Set Admin to the appropriate tenant (this defines which tenant can edit/delete this cluster), set the site, set VPC to 'create new', select the Template created earlier, and click +Add server to start selecting server members. Click Add. 

.. image:: images/add-server-cluster.png
  :align: center
  :class: with-shadow
  
.. raw:: html
  
  <br />

- VPC creation is only automatic when 'create new' is selected. If an existing VPC is chosen, the system will not create a new VPC, and it is assumed that the selected VPC already contains the necessary network constructs.
- After creation, the template, VPC, and site fields are locked. Servers may be added or removed, but only if their NIC layout matches the template.
- When deleting a cluster, users may choose to retain or delete the associated VPC. If the VPC is still used by other resources, it will not be removed.
- To avoid misconfiguration, all servers in a cluster must share identical NIC names and counts. Templates assume symmetry; mismatched layouts will be rejected.
- Shared endpoints must not be listed as exclusive members in any cluster. The system enforces this exclusivity to prevent configuration conflicts.

Server Cluster Example
--------------------------------

In this example, we are creating a Server Cluster named 'My-Cluster-01' in Site-1, using the previously defined template 'My-Cluster-Template-flavor'. The cluster includes five servers for compute workloads and five servers designated for shared endpoints.

.. code-block:: shell-session

  {
    "name": "My-Cluster-01",
    "admin": "tenant-a",
    "site": "Site-1",
    "vpc": "create new",
    "template": "My-Cluster-Template-flavor",
    "servers": [
        "server-01",
        "server-02",
        "server-03",
        "server-04",
        "server-05"
    ]
    "SharedEndpoints": [
        "server-10",
        "server-11",
        "server-12",
        "server-13",
        "server-15"
    ]
  }

Best Practices
===============

- Use descriptive names for templates and clusters to convey their purpose.
- Maintain consistent NIC naming conventions across servers in a cluster.
- Double-check NIC layouts before adding servers to ensure compatibility with the template.

