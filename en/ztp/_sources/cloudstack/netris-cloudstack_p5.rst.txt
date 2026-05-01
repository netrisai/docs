.. meta::
  :description: Netris-CloudStack Integration

Using CloudStack with Netris Isolation Method
=============================================

This chapter outlines how to use the CloudStack platform with the Netris isolation method.

#. Creating and Managing a VPC in CloudStack with Netris Integration
#. Adding Tier Networks
#. Configuring NAT (Network Address Translation)
#. Creating Load Balancers
#. Assigning Public IPs


Creating a VPC
--------------------

To create a **VPC in CloudStack** with the **Netris Isolation Method**, follow these steps:

1. **Navigate to the VPC Creation Page**:

   - In the **CloudStack UI**, go to the **"VPC"** section and click **Add VPC**.

2. **Fill in the VPC Details**:

   - **Name**: Assign a name to the VPC (e.g., `vpc1`).
   - **Zone**: Select the Zone (`Zone1`).
   - **CIDR**: Define the CIDR range for the VPC (e.g., `10.0.0.0/16`).
   - **VPC Offering**: Choose **VPC offering with Netris - NAT Mode**.
   - **DNS 1/DNS 2 (optional)**: Provide DNS servers for the VPC.
   - **Start**: Toggle the **start** option to enable the VPC.

3. **Save the VPC**:

   - Click **OK** to save and create the **VPC**.

After the **VPC is created**, open it:

- Navigate to the **Public IP addresses** tab.
- You will notice that a **public IP** has been allocated with the **“Source NAT”** label.
- This IP is dynamically **picked from the Netris Public Network Pool**.
- If you check the **Netris Controller** (`Services → NAT`), you will see that a **SNAT Rule** has been **automatically created in Netris** for the **VPC’s CIDR**.


Creating a Network Tier
---------------------------

To create a **Network Tier** within the **VPC**, follow these steps:

1. **From the VPC details page**, navigate to the **Networks** tab and click **Add New Network Tier**.

2. **Fill in the Network Tier Details**:

   - **Name**: Assign a name to the network (e.g., `vpc1-network1`).
   - **Network Offering**: Choose **Offering for Netris enabled networks on VPCs - NAT Mode**.
   - **Gateway**: Specify the gateway for this tier (e.g., `10.0.0.1`).

     - Ensure the **gateway is within the VPC’s CIDR range**.

   - **Netmask**: Provide the subnet mask (e.g., `255.255.255.0`).

     - The **netmask should match the VPC’s CIDR range**.

   - **ACL**: Select an appropriate **ACL** (default is `default_allow`).

3. **Save the Network Tier**:

   - Click **OK** to create the **tier**.

After the **tier is created**:

- Navigate to **Netris Controller → Services → V-Nets**.
- You will see a **newly created vnet** based on the **network tier details**.
- The **Tags** for this vnet correspond to the **hypervisor tags**, which define where this **network can be used**.
- These **tags ensure** that the **network is only utilized** by the **hypervisors associated with the VPC**.


Port Forwarding
------------------------------

Seamless Integration Between CloudStack and Netris
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Port Forwarding in CloudStack** is directly synchronized with the **Netris Controller**. When a user creates any type of **NAT rule** in CloudStack, **CloudStack automatically pushes** that rule to **Netris Controller**, ensuring **seamless integration** between the two systems. This **eliminates manual configurations** in Netris, as **CloudStack handles** the NAT rule creation and enforcement within the **Netris networking stack**.

Step-by-Step Process for Configuring Port Forwarding in CloudStack with Netris
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. **Deploy a VM in the VPC Network**

   - Ensure you have already **created a network tier** (e.g., `vpc1-network1`) in your **VPC** (e.g., `vpc1`).
   - Deploy a **virtual machine** in the **VPC network** using CloudStack.

2. **Acquire a New Public IP**

   - Navigate to the **VPC Page** in CloudStack and go to the **Public IP Addresses** tab.
   - Click the **Acquire New IP** button to allocate a **new public IP address** from the **Netris public network pool**.
   - The **public IP** will be visible in the **Public IP Addresses list**.

3. **Configure Port Forwarding in CloudStack**

   - Click on the **newly acquired public IP** to open its configuration page.
   - Go to the **Port Forwarding** tab.
   - Enter the following details to **create a port forwarding rule**:

     - **Private Port**: Enter the **port(s) used** by the service on the internal VM. *(Example: `22` for SSH)*.
     - **Public Port**: Enter the **corresponding port(s)** to be **exposed externally**. *(Example: `22` for SSH)*.
     - **Protocol**: Select the **protocol**, such as **TCP** or **UDP**.
     - **Add Instance**: Choose the **deployed VM** (e.g., `vm1-test1-vpc1`) to link with the **port forwarding rule**.

   - Click **Add** to save the **port forwarding rule**. The rule will now be **displayed in the Port Forwarding list**.

4. **Verify the DNAT Rule in Netris**

   - Navigate to **Network → NAT** in the **Netris Controller**.
   - Verify the **DNAT Rule** created by CloudStack.
   - The rule will **map the acquired public IP address** to the **internal private IP address** of the VM.
   - Ensure the **Source Port** and **Destination Port** align with the **CloudStack configuration**.

   **Example Configuration:**

   - **Source Address**: `0.0.0.0/0`
   - **Destination Address**: The **newly acquired public IP**.
   - **DNAT to IP**: The **private IP of the VM**.
   - **DNAT to Port**: The **private port used** by the service (e.g., `22`).

Key Notes:
^^^^^^^^^^

✔ **Automatic Integration**: CloudStack **directly pushes NAT rules** to Netris, eliminating **manual configuration**.

✔ **Efficient Public Access**: Users can **seamlessly expose internal services** through CloudStack’s UI, and the changes are **instantly reflected in Netris**.

✔ **Real-Time Sync**: Any **updates or removals** of **NAT rules** in CloudStack are **immediately applied** in Netris.  


Configuring Static NAT in CloudStack
-----------------------------------------

How Static NAT Works with CloudStack and Netris
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Static NAT** provides a **1:1 mapping** between a **public IP** and a **private IP**, allowing **bidirectional traffic flow** without port restrictions. When a user **enables Static NAT** in CloudStack, **CloudStack automatically configures** the corresponding rule in **Netris Controller**.

Steps to Configure Static NAT:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. **Access the Public IP Addresses Tab:**

   - Navigate to the **VPC page** in **CloudStack**.
   - Click on the **Public IP addresses** tab.

2. **Acquire a New Public IP:**

   - Click the **Acquire new IP** button.
   - Confirm the allocation of a **new public IP**.
   - Once acquired, **select the newly allocated public IP**.

3. **Enable Static NAT:**

   - Locate the **+ (add)** button in the **top-right corner** of the page.
   - Click on it, and a **pop-up window** will appear.

4. **Assign Static NAT:**

   - In the pop-up, choose:

     - The **desired network tier**.
     - The **VM to be assigned** to the public IP.

   - Click **OK** to finalize the configuration.

5. **Verify Static NAT in Netris Controller:**

   - Navigate to **Network → NAT** in the **Netris Controller**.
   - Locate the **newly created Static NAT rule**, which will **map the public IP** to the **private IP of the VM**.

How CloudStack and Netris Work Together
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

✔ **CloudStack Automatically Creates the Static NAT Rule in Netris**: No need for separate configurations in Netris.
 
✔ **All Traffic Is Forwarded**: Unlike **Port Forwarding**, **Static NAT applies to all ports and protocols**.

✔ **Ensures Public Availability**: VMs assigned a **Static NAT public IP** are fully accessible **without additional configurations**.


Final Notes
^^^^^^^^^^^

- **Use Static NAT** when a **VM needs full public access** on **all ports and protocols**.  
- **Use Port Forwarding** when **exposing specific services only** (e.g., **SSH, HTTP**).  
- **CloudStack handles all NAT configurations**, and **Netris automatically enforces them**.  

By following this setup, **CloudStack’s networking is fully automated** and **managed by Netris**, ensuring **seamless operation without manual intervention in Netris**.
