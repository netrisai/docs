.. meta::
  :description: Netris-CloudStack Integration

Prerequisites
=============

`Switch fabric up & running <https://www.netris.io/docs/en/latest/tutorials/vpc-gateways-with-managed-fabric.html>`_

`ISP upstreams connected through BGP <https://www.netris.io/docs/en/latest/tutorials/connecting-fabric-to-isp.html>`_

Step-by-Step Configuration Instructions for the Netris Controller
-----------------------------------------------------------------

Accessing the Netris Controller
* Access the Netris Controller UI by navigating to its IP or hostname in your web browser.
* Log in using your administrator credentials.


IPAM Setup
----------

The Netris IPAM allows users to manage your IP addresses and monitor pool usage effectively. With a hierarchical view, IPAM facilitates subnetting tasks by assigning specific purposes (roles) to subnets or addresses before utilizing them in services like V-Net, NAT, and Load Balancing.


Create an Allocation
^^^^^^^^^^^^^^^^^^^^

Allocations represent IP ranges assigned to an organization, such as private IP ranges or those obtained from RIR/LIR. Subnets are created within allocations and serve as prefixes for various services.

1. Navigate to: **Network** → **IPAM** → **+Add**.
2. **In the Add Allocation form, fill in the following**:

  * **Prefix**: 10.0.0.0/8.
  * **Name**: Provide a descriptive name (e.g., “Private IP Allocation”).
  * **VPC**: Associate the allocation with the default VPC (vpc-1:Default).
  * **Tenant**: Assign the allocation to a tenant (e.g., “Admin”).
  * **Type**: Select Allocation.

3. Click **Add** to create the allocation.

[todo]Refer to the screenshot for guidance:


Create Subnets
^^^^^^^^^^^^^^

Subnets are prefixes that fall under allocations and are used for specific purposes. Let’s create two subnets within the allocation for management and loopback purposes.

1. Loopback Subnet:

  * **Prefix**: 10.0.0.0/16.
  * **Name**: “Loopback IP Subnet”.
  * **VPC**: Select vpc-1:Default.
  * **Tenant**: Assign to “Admin”.
  * **Type**: Select Subnet.
  * **Purpose**: Choose Loopback.
  * **Sites**: Associate with your Netris site.

2. Management Subnet:

  * **Prefix**: 10.10.0.0/16.
  * **Name**: “OOB Management Subnet”.
  * **VPC**: Select vpc-1:Default.
  * **Tenant**: Assign to “Admin”.
  * **Type**: Select Subnet.
  * **Purpose**: Choose Management.
  * **Default Gateway**: Set to 10.10.0.1.
  * **Sites**: Associate with your Netris site.

3. Click **Add** after filling in the fields for each subnet.

Refer to the screenshots for guidance:

  * Loopback Subnet: 
  * Management Subnet: 


Inventory Setup
---------------

The Inventory Setup in Netris allows you to add and manage devices such as switches, SoftGates, and servers.

Adding Servers
^^^^^^^^^^^^^^

In this step, we’ll configure the servers for the **Netris inventory**. The first server **(Server 1)** will be configured differently from the remaining three servers **(Server 2, 3, and 4)**, which act as CloudStack KVM hypervisors.


1. Go to: **Network** → **Topology** → **+Add**.

**Prerequisites**:

  * **Loopback subnet** must be defined in **Netris IPAM**.
  * **Management subnet** must be defined in **Netris IPAM**.

2. Add Servers

* **Server 1 (CloudStack Management Node)**:
  
  * **Name**: Server 1
  * **Tenant**: Assign to Admin.
  * **Description**: Leave blank or add relevant details.
  * **Type**: Select Server.
  * **Site**: Assign to your site.
  * **AS Number**: Assign automatically or provide a unique ASN.
  * **Main IP Address**: Select Disabled (as no Main IP is needed).
  * **Management IP Address**: Assign 10.10.10.1 (from the Management Subnet).
  * **Role**: Generic.
  * **Port Count**: Set to 4.
  * **Tags**:

    * iface.eth1=CS-Cloud1-MGMT
    * iface.eth2=CS-Cloud1-MGMT

Click **Add** to save the configuration for **Server 1**.

📌 **Why isn’t underlay enabled for Server 1?**

	Server 1 does not run the netris-cloudstack-agent, and its traffic will be encapsulated in **traditional VLAN** instead of **VXLAN**.


* **Server 2, 3, and 4 (CloudStack KVM Hypervisors)**:

  * **Name**:
  
    * Server 2 for the first hypervisor.
    * Server 3 for the second hypervisor.
    * Server 4 for the third hypervisor.
  
  * **Tenant**: Assign to Admin.
  * **Description**: Leave blank or add relevant details.
  * **Type**: Select Server.
  * **Site**: Assign to your site.
  * **AS Number**: Assign automatically or provide a unique ASN.
  
  * **Main IP Address**: Assign from the **Loopback Subnet**:
  
    * 10.0.8.2 for **Server 2**.
    * 10.0.8.3 for **Server 3**.
    * 10.0.8.4 for **Server 4**.
  
  * **Management IP Address**: Assign from the **Management Subnet**:
  
    * 10.10.10.2 for **Server 2**.
    * 10.10.10.3 for **Server 3**.
    * 10.10.10.4 for **Server 4**.
  
  * **Role**: Hypervisor:CloudStack.
  * **Port Count**: Set to 4.
  * **Tags**:

    * iface.eth1=CS-Cloud1-Compute
    * iface.eth2=CS-Cloud1-Compute
  
  * **Custom Field**:
  
  For each server, use the following JSON with the specific **ipv4** address:

    * **Server 2**:

    .. code-block:: json

      {
        "cloudstack": {
          "mgmt": {
            "bridge-name": "cloudbr0",
            "ipv4": "10.100.1.2/21",
            "nameservers": ["1.1.1.1", "8.8.8.8"]
          }
        }
      }

    * **Server 3**:

    .. code-block:: json

      {
        "cloudstack": {
          "mgmt": {
            "bridge-name": "cloudbr0",
            "ipv4": "10.100.1.3/21",
            "nameservers": ["1.1.1.1", "8.8.8.8"]
          }
        }
      }

    * **Server 4**:

    .. code-block:: json

      {
        "cloudstack": {
          "mgmt": {
            "bridge-name": "cloudbr0",
            "ipv4": "10.100.1.4/21",
            "nameservers": ["1.1.1.1", "8.8.8.8"]
          }
        }
      }


Repeat the process for **Server 2**, **Server 3**, and **Server 4**, updating the Main and Management IP addresses and JSON as per the above configuration.


📌 **What is the purpose of these configurations?**

* **Tags** will be used later in network assignments (V-Nets) to ensure that networks are correctly assigned to the hypervisors.
* **JSON Configuration** serves as a **template** that the ``netris-cloudstack-agent`` will use to configure cloudbr0 on the hypervisor nodes.


3. Save the Configuration

  * For each server, click **Add** to save the configuration.

Terraform Example for Adding a Server
"""""""""""""""""""""""""""""""""""""

The following Terraform configuration example demonstrates how to **automate server provisioning** in Netris:

.. code-block::

   resource "netris_server" "server_1" {
     name        = "Server-1"
     tenantid    = "Admin"
     siteid      = data.netris_site.sv.id
     description = "CloudStack Management Node"
     role        = "generic"
     portcount   = 4
     tags = ["iface.eth1=CS-Cloud1-MGMT", "iface.eth2=CS-Cloud1-MGMT"]

   resource "netris_server" "server_hypervisor" {
     count       = 3
     name        = "Server-${count.index + 2}"
     tenantid    = "Admin"
     siteid      = data.netris_site.sv.id
     description = "CloudStack Hypervisor Node"
     role        = "hyperv_cs"
     portcount   = 4
     asnumber    = "auto"
     tags = ["iface.eth1=CS-Cloud1-Compute", "iface.eth2=CS-Cloud1-Compute"]
     customdata = <<EOF
   {
     "cloudstack": {
       "mgmt": {
         "bridge-name": "cloudbr0",
         "ipv4": "10.100.1.${count.index + 2}"/21",
         "nameservers": ["1.1.1.1", "8.8.8.8"]
       }
     }
   }
   EOF


Creating Servers’ Links
^^^^^^^^^^^^^^^^^^^^^^^

To fully establish the network topology, you need to create the links between leaf switches and servers as illustrated in the first diagram. This section explains how to create the links step-by-step.

**Navigate to the Device**

#. In the Topology view, right-click on one of the leaf switch that will be part of the link (e.g., Leaf-1).
#. Select Create Link from the context menu.


**Configure the Link**

1. **From Section:**

  * **Device**: Automatically selected based on the device you right-clicked.
  * **Port**: Choose the port on the selected device (e.g., swp1 on Leaf-1).
  
2. **To Section**:

  * **Device**: Select the other device participating in the link (e.g., Leaf-1).
  * **Port**: Choose the appropriate port on the second device (e.g., eth1 on Server 1).

3. **Options**:

  * **Underlay**:
    * **Mark** the checkbox for all links **except the link involving Server 1**.

4. Click **Add** to save the link.


**Repeat for All other servers’ interfaces**


**Notes**:

  * For links involving **Server 1**, leave the **Underlay** checkbox **unmarked**.

Unlike CloudStack hypervisors, **Server 1 does not have the Netris-CloudStack Agent installed**. This means it does not need dynamic networking capabilities or VXLAN encapsulation. Instead, its traffic remains inside a **traditional VLAN**. Disabling **Underlay** for Server 1 ensures:

  * CloudStack **management traffic remains isolated**.
  * Management traffic **does not require VXLAN encapsulation**.
  * It uses **a simpler VLAN-based connection** instead of participating in the Netris overlay network.


Terraform Example for Creating Servers’ Links
"""""""""""""""""""""""""""""""""""""""""""""

The following Terraform configuration example demonstrates how to **automate servers’ links** in Netris:

.. code-block::

   resource "netris_link" "srv1-eth1-to-leaf1-swp1" {
     ports   = [
       "swp1@Leaf-1",
       "eth1@Server-1"
     ]
     depends_on = [netris_server.server_1, netris_switch.leaf1]
   }

   resource "netris_link" "srv2-eth1-to-leaf1-swp2" {
     ports   = [
       "swp2@Leaf-1",
       "eth1@Server-2"
     ]
     underlay = "enabled"
     depends_on = [netris_server.server_2, netris_switch.leaf1]
   }
