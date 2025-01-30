.. meta::
  :description: Netris-CloudStack Integration

Server Configuration and Software Installation
==============================================

Here we are going to configure the servers' network, install the `netris-cloudstack` agents on hypervisors, install CloudStack management software on `Server 1`, and install the CloudStack agent on `Server 2-4`.

Configuring Network on CloudStack Management Server (Server 1)
--------------------------------------------------------------

To set up the CloudStack **Management Server** (Server 1) effectively, we need to configure its **network**. The following steps describe how to prepare the server’s **network interfaces**, set up **bonding** for redundancy, and integrate it with the Netris-managed fabric.

Understanding the Network Layout
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. **eno1**:

  * Connected to the **Out-of-Band** (OOB) switch.
  * Used for administrative tasks, **package installation**, and **emergency access**.
  * This interface will remain **separate** from the **Netris fabric**.

2. **eno2** and **eno3**:

  * Connected to **leaf1** and **leaf2** switches in the Netris fabric, respectively.
  * These interfaces will be **bonded** to form bond0, ensuring link **redundancy** and better throughput through **LACP** (Link Aggregation Control Protocol).

3. **bond0**:

  * This bonded interface will **carry all traffic** routed through the Netris-managed network.
  * It will use an IP address within the 10.99.0.0/21 **subnet** for communication with CloudStack resources and the Netris fabric.


Netplan Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^

Below is a Netplan configuration file to set up the network:

.. code-block:: yaml

   network:
     ethernets:
       eno1:
         addresses:
           - 10.254.96.39/24
         routes:
           - to: 10.254.95.0/24
             via: 10.254.96.1
       eno2:
         dhcp4: false
         dhcp6: false
       eno3:
         dhcp4: false
         dhcp6: false
       eno4:
         dhcp4: false
         dhcp6: false
     bonds:
       bond0:
         interfaces:
           - eno2
           - eno3
         addresses:
           - 10.99.1.1/21
         nameservers:
           addresses:
             - 1.1.1.1
             - 8.8.8.8
           search:
             - netris.local
         routes:
           - to: default
             via: 10.99.0.1
         parameters:
           mode: 802.3ad
           lacp-rate: fast
           transmit-hash-policy: layer3+4
           mii-monitor-interval: 100

**Explanation**

1. **eno1** Configuration:

  - Assigned an IP address (10.254.96.39/24) for **OOB** management access.
  - A static **route** is added to ensure that the CloudStack Management Server **communicates** with the **Netris API** via the OOB network (10.254.95.0/24 via 10.254.96.1).

2. **eno2** and **eno3** Configuration:

  - These interfaces are explicitly **disabled** from **DHCP** to avoid conflicts as they are **part** **of** **bond0**.

3. **bond0** Configuration:

   - Bonded interface combines **eno2** and **eno3** for link redundancy and throughput.
   - Configured with the 10.99.1.1/21 IP address for connectivity within the **CloudStack Management** subnet.
   - Nameservers (1.1.1.1 and 8.8.8.8) and search domain (netris.local) ensure proper DNS resolution.
   - A **default route** (via 10.99.0.1) directs traffic to the gateway.

Netris Fabric Integration
- From the Netris side, **no** manual **configuration** is **required** for the bonded interface.
- Once the server is connected, the Netris fabric will **detect** **LACP** packets and **automatically** configure EVPN-MH (MultiHoming) for redundancy.

**Verification:**

1. After **applying** the **Netplan** configuration, use the following commands to verify:

.. code-block::

  sudo netplan apply

2. **Check** that **bond0** is up and operational with the correct **IP and default route**.

.. code-block::

  ip addr show bond0
  ip route show

3. Confirm that **LACP** is working by checking the **bond** status:

.. code-block::

  cat /proc/net/bonding/bond0

**Best Practices**

  - Keep eno1 isolated from the Netris fabric to ensure uninterrupted OOB management access.
  - Regularly monitor the bond interface (bond0) for any link failures or misconfigurations.

Install Netris-CloudStack Agent on Hypervisor Servers
---------------------------------------------------------

The **netris-cloudstack agent** acts as a bridge between CloudStack and the Netris Controller. It automates the provisioning and configuration of network resources required for CloudStack’s operations on hypervisor nodes. The agent ensures seamless integration by performing the following key functions:

Key Functions of the Netris-CloudStack Agent
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. **Bridge Management**:

  - Automatically creates and configures the **cloudbr0** bridge on hypervisors based on the JSON configuration provided during setup.
  - Ensures the bridge is correctly associated with the **CloudStack Management Network**.

2. **Network Automation**:

  - Configures VXLAN overlays to extend Layer 2 networks across the Netris fabric.
  - Integrates with Netris EVPN to enable dynamic exchange of MAC and IP address information.

Installation Steps
^^^^^^^^^^^^^^^^^^

To provision the **netris-cloudstack agent** on the hypervisor servers (Server 2-4):

1. Navigate to: **Net → Inventory**.
2. Locate the desired server node (e.g., **Server 2**).
3. Click the three vertical dots (**⋮**) on the right-hand side of the node and select **Install Agent**.
4. A **one-line installer command** will appear. Copy this command to your clipboard.

   - **Note:** Each installer command is unique to the specific node.
  
5. SSH into the server and execute the copied command:
6. Repeat this process for each hypervisor server (**Servers 2, 3, and 4**).

Example Successful Output of One-Liner Script
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Below is an example of a successful installation output after executing the **one-liner script** on a hypervisor server:

.. code-block:: shell

  root@Server-2:~# curl -fsSL https://get.netris.io | sh -s -- --lo 10.0.8.2 --controller netris.example.com --ctl-version 4.4.0-011 --hostname Server-2 --auth UTuO5CvRGtlaHFpnwGRHCBGeEwxerpr2uLuDIbBc --node-type acs_hyper
  === Installing Netris-CloudStack Agent ===
  + Configuring the Netris repository...
  + Updating list of available packages
    * Proceeding with the new version of netris config files
  + Configuring Netris-CloudStack Agent
  + Enabling bgpd in FRR
  + Restarting FRR service
  + Starting Netris-CloudStack Agent service
  === Netris-CloudStack Agent is now installed! ===
  + Get started with Netris: https://netris.io/docs/en/stable/

Verification Steps
^^^^^^^^^^^^^^^^^^

1. **Check the agent service** to ensure it is running:

   .. code-block:: shell

      systemctl status netris-cloudstack-agent.service

2. **Confirm that the `cloudbr0` bridge has been created**, has the correct IP address, and that the default gateway is reachable:

   .. code-block:: shell

      ip addr show cloudbr0
      ping 10.100.0.1


Install CloudStack Management Service
-------------------------------------

The user is responsible for installing the **CloudStack Management** service. You are free to follow your preferred method for installation. **Netris isolation method** is officially available in CloudStack starting from version **21**.

For earlier access, the development version is available at **ShapeBlue's repository**:

**Repository URL:** `http://packages.shapeblue.com/cloudstack/custompublic/kapik/`

Installation Steps
^^^^^^^^^^^^^^^^^^

Follow these steps to install the CloudStack Management service:

1. **Create the keyring directory**:

   .. code-block:: shell

      mkdir -p /etc/apt/keyrings

2. **Add the repository key**:

   .. code-block:: shell

      wget -O- http://packages.shapeblue.com/release.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/cloudstack.gpg > /dev/null

3. **Add the repository**:

   .. code-block:: shell

      echo deb [signed-by=/etc/apt/keyrings/cloudstack.gpg] http://packages.shapeblue.com/cloudstack/custompublic/kapik/debian/4.20 / > /etc/apt/sources.list.d/cloudstack.list

4. **Update the package list**:

   .. code-block:: shell

      apt-get update -y
