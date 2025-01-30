.. meta::
  :description: Netris-CloudStack Integration

Configuring CloudStack for Netris Integration
==============================================

This chapter focuses on **initializing**, **configuring**, and **utilizing CloudStack** to integrate seamlessly with the Netris Controller. By following these steps, you will enable advanced networking capabilities within CloudStack using the Netris plugin and configure the environment for optimal performance.

Enabling the Netris Plugin in CloudStack
-----------------------------------------

Once the CloudStack Management service is installed and running, the next step is to enable the Netris plugin.

  #. Navigate to the CloudStack GUI and log in as an administrator.
  #. Go to **Configuration** → **Global Settings**.
  #. In the search field, type "netris" to locate the Netris plugin setting.
  #. Enable the Netris plugin by toggling the switch to "ON."
  #. Save the settings.

After enabling the plugin, restart the CloudStack Management service to apply the changes:

   .. code-block:: shell

      systemctl restart cloudstack-management.service



Initializing CloudStack Setup
-----------------------------

After enabling the **Netris plugin**, log back into the CloudStack GUI. You will be greeted with the **Dashboard** screen that guides you through the initial setup of your CloudStack environment.

Steps to Initialize CloudStack
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Access the Dashboard
""""""""""""""""""""

1. Once logged into the CloudStack GUI, navigate to the **Dashboard** where the initial setup guide is displayed.
2. Click **Continue with Installation** to proceed.

Add a Zone
""""""""""

1. Set a new password to start the process of adding a new **zone**. Zones are logical data center constructs that define network and compute resources.

Step 1: Zone Type
""""""""""""""""""

- Select **Core** as the zone type.
- Core zones are ideal for data center-based deployments with full networking capabilities.
- Click **Next**.

Step 2: Core Zone Type
"""""""""""""""""""""""

- Select **Advanced** as the core zone type.
- Ensure the **Security Groups** option is disabled.
- Click **Next** to proceed.

Step 3: Zone Details
""""""""""""""""""""

Fill in the following details for your zone:

- **Name**: Provide a unique name for the zone (e.g., `zone1`).
- **IPv4 DNS 1** and **IPv4 DNS 2**: Enter DNS server addresses that work for your environment (e.g., `1.1.1.1` and `8.8.8.8`).
- **Internal DNS 1**: This field is mandatory; provide a DNS server address that suits your needs (it does not necessarily need to be an "internal" DNS).
- **Internal DNS 2**: Optionally, enter a secondary DNS server address.
- **Hypervisor**: Select **KVM** as the hypervisor type.

Click **Next** to continue the setup process.

Step 4: Network
""""""""""""""""

Define the physical network for the zone.

- **Network Name**: Use a descriptive name for the physical network (e.g., `Physical Network 1`).
- **Isolation Method**: Select **NETRIS** as the isolation method.
- **Traffic Types**: Add the following traffic types to the network:

  - **Guest**: For guest VMs.
  - **Management**: For management traffic.
  - **Public**: For public-facing traffic.

- Tags can be left empty unless specific tags are required for traffic routing.

Click **Next** to proceed.

Step 5: Netris Provider Configuration
"""""""""""""""""""""""""""""""""""""

On the **Netris Provider** page, provide the following information:

- **Netris Provider Name**: Set a name for the Netris provider (e.g., `netris`).
- **Netris Provider Hostname**: Enter the URL or IP of the **Netris Controller** (e.g., `https://netris.example.com`).
- **Netris Provider Port**: Leave empty unless your **Netris Controller** is using a non-default port.
- **Netris Provider Username**: Enter the username for the **Netris Controller** (e.g., `netris`).
- **Netris Provider Password**: Enter the corresponding password for the **Netris Controller**.
- **Netris Provider Site Name**: Specify the **site name** that matches the site created in the **Netris Controller**.
- **Netris Provider Admin Tenant Name**: Use the **default tenant name** (e.g., `Admin`).
- **Netris Tag**: Ensure this matches the tag defined for the **CloudStack Management (Hypervisor Nodes) VNet** in **Netris**. For this example, use `CS-Cloud1-Compute`.

Click **Next** to proceed.

Step 6: Public Traffic Configuration
"""""""""""""""""""""""""""""""""""""

Define subnets for **public-facing traffic**, using details from the corresponding **Netris VNets**:

- **System VMs Public Network**: Use information from the **CloudStack System VMs VNet** in **Netris**.
- **Virtual Routers Public Network**: Use information from the **CloudStack VRs VNet** in **Netris**.

Example Configuration:

- **System VMs Public Network**:

  - **Gateway**: `203.0.113.1`
  - **Netmask**: `255.255.255.224`
  - **VXLAN/VNI**: Use the **VXLAN ID** from **Netris** for **System VMs** (e.g., `vxlan://12`).
  - **Start and End IP**: `203.0.113.2 - 203.0.113.30`

- **Virtual Routers Public Network**:

  - **Gateway**: `203.0.113.129`
  - **Netmask**: `255.255.255.128`
  - **VXLAN/VNI**: Use the **VXLAN ID** from **Netris** for **Virtual Routers** (e.g., `vxlan://13`).
  - **Start and End IP**: `203.0.113.130 - 203.0.113.254`

Click **Add** for each network and verify that the details align with your **Netris VNet** configurations.

**Note**: The **gateways** for the subnets can vary depending on your **Netris setup**. The values provided above are examples based on the screenshots. Replace them with the actual details from your deployment.

Then click **Next**.

Step 7: Netris Public IP Pool
""""""""""""""""""""""""""""""

- Add the **public IP pool** from the **Netris Subnet for Netris Services**. This pool is consumed by **CloudStack** for **NAT and Load Balancer services**.

Example Configuration:

- **Gateway**: `198.51.100.1` (from the **Subnet for Netris Services** in **Netris IPAM**).
- **Netmask**: `255.255.255.128`.
- **Start and End IP**: `198.51.100.2 - 198.51.100.254`.

**Note**: For the **Netris Public IP Pool**, the **VLAN/VNI** field is **inactive** because this is not a **VNet**, but a **pool of IPs** that **CloudStack** will consume to create services like **NAT and load balancers**.

Click **Add** and then **Next**.

Step 8: Configuring Pod Management Network
"""""""""""""""""""""""""""""""""""""""""""

On this page, configure the **Pod’s management network**. This network is essential for **internal communication** within the **Pod** and is derived from the **Netris CloudStack Management (Hypervisor Nodes) VNet**.

Example Configuration:

- **Pod Name**: `pod1`
- **Reserved System Gateway**: `10.100.0.1`
- **Reserved System Netmask**: `255.255.248.0`
- **Start Reserved System IP**: `10.100.5.1`
- **End Reserved System IP**: `10.100.5.255`

Click **Next** to proceed.

Step 9: Configuring VPC Tiers VXLAN Range
"""""""""""""""""""""""""""""""""""""""""

On this page, configure the **VXLAN range** for **VPC tiers**. This range defines the **VXLAN Network Identifiers (VNIs)** used for isolating **guest traffic** within the cloud.

Example Configuration:

- **VXLAN Range**:
  - **Start**: `1000000`
  - **End**: `2000000`
  - If needed, extend the range to allow for additional **VPC tiers**.

Click **Next** to proceed.

Step 10: Final Steps in Zone Configuration
""""""""""""""""""""""""""""""""""""""""""

The final steps in configuring the **CloudStack zone** involve setting up **essential components** for the **cluster**. These include:

1. **Setting the Cluster Name**
2. **Adding the First Hypervisor**
3. **Attaching Primary Storage**
4. **Attaching Secondary Storage**

Since **Netris** is **not involved** in these processes, no specific recommendations or guidance are necessary from **Netris**.

**Recommendation**: Users should refer to the `Apache CloudStack Documentation <https://cloudstack.apache.org/>`_ for detailed guidance on these steps.
