.. meta::
    :description: NVIDIA UFM Integration Plugin for Netris Controller

####################################################
NVIDIA UFM Integration Plugin for Netris Controller
####################################################

Overview
========

The Netris-UFM plugin provides seamless integration between Netris Controller and NVIDIA UFM (Unified Fabric Manager) for AI infrastructures with hybrid InfiniBand and Ethernet networks. This integration allows infrastructure operators to define compute multi-tenancy in a single place through Netris, significantly simplifying management across both network types.

Key Benefits
--------------

- **Unified Management Interface**: Define tenant isolation by simply listing servers in a server-cluster object
- **Automated Provisioning**: Automatically configure both Ethernet (via Netris) and InfiniBand (via UFM) networks
- **Simplified Operations**: Eliminate the need to manage SwitchPorts, VLANs, VRFs on Ethernet and GUIDs, PKeys, SHARP groups on InfiniBand separately

Architecture
=============

The Netris-UFM plugin acts as the integration layer between Netris Controller and NVIDIA UFM:

1. **Netris Controller**: Orchestrates the Ethernet switches and provides the primary user interface
2. **NVIDIA UFM**: Manages the InfiniBand switches and provides specialized InfiniBand functionality
3. **Netris-UFM Plugin**: Synchronizes configurations between both systems

When you define a server cluster in Netris, the plugin automatically:

- Discovers InfiniBand port GUIDs from UFM
- Creates and manages appropriate PKeys in UFM
- Sets up SHARP reservations for high-performance operations

Prerequisites
==============

Before installing the Netris-UFM plugin, ensure:

1. A functioning Netris Controller environment
2. A properly configured NVIDIA UFM installation
3. Network connectivity between both systems
4. Appropriate access credentials for both platforms

Installation
===========

Option 1: Deploy within an existing Netris Controller Kubernetes cluster
------------------------------------------------------------------------

This option is recommended if you already have a Netris Controller running in a Kubernetes environment.

1. Download the Kubernetes deployment YAML file:

   .. code-block:: bash

      wget https://get.netris.io/netris-controller-ufm.yaml

2. Edit the YAML file to update the secret values based on your environment:

   .. code-block:: yaml

      apiVersion: v1
      kind: Secret
      metadata:
        name: netris-controller-nvidia-ufm-agent-envs
        namespace: netris-controller
      type: Opaque
      stringData:
        NETRIS_CONTROLLER_ADDR: "https://netris.example.com"
        NETRIS_CONTROLLER_LOGIN: "netris"
        NETRIS_CONTROLLER_PASSWORD: "newNet0ps"
        NETRIS_VERIFY_SSL: "true"
        NETRIS_SITE_NAME: "Site"
        UFM_ADDR: "https://ufm.example.com"
        UFM_LOGIN: "admin"
        UFM_PASSWORD: "123456"
        UFM_VERIFY_SSL: "false"
        UFM_ID: "ufm-lab"
        UFM_PKEY_RANGE: "100-7ffe"

3. Apply the configuration to your Kubernetes cluster:

   .. code-block:: bash

      kubectl apply -f netris-controller-ufm.yaml

Option 2: Deploy as a standalone Docker container
-------------------------------------------------

This option is ideal for environments without Kubernetes or when you want to deploy on a separate host.

1. Create an environment file (e.g., ``env``) with the following content:

   .. code-block:: bash

      NETRIS_CONTROLLER_ADDR="https://netris.example.com"
      NETRIS_CONTROLLER_LOGIN="netris"
      NETRIS_CONTROLLER_PASSWORD="newNet0ps"
      NETRIS_VERIFY_SSL="true"
      NETRIS_SITE_NAME="Site"
      UFM_ADDR="https://ufm.example.com"
      UFM_LOGIN="admin"
      UFM_PASSWORD="123456"
      UFM_VERIFY_SSL="false"
      UFM_ID="ufm-lab"
      UFM_PKEY_RANGE="100-7ffe"
      LOG_LEVEL="info"

2. Run the Docker container:

   .. code-block:: bash

      docker run -d \
        --env-file=env \
        --name=netris-ufm \
        --entrypoint "/app/servicebin" \
        netrisai/bare-metal-netris-ufm-agent:0.1.1

Configuration Parameters
======================

Netris Controller Configuration
------------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Parameter
     - Description
     - Example
   * - NETRIS_CONTROLLER_ADDR
     - The URL of your Netris Controller
     - https://netris.example.com
   * - NETRIS_CONTROLLER_LOGIN
     - Username for authenticating with Netris Controller
     - netris
   * - NETRIS_CONTROLLER_PASSWORD
     - Password for authenticating with Netris Controller
     - newNet0ps
   * - NETRIS_VERIFY_SSL
     - Whether to verify SSL certificates when connecting to Netris Controller
     - true or false
   * - NETRIS_SITE_NAME
     - The name of the site in Netris Controller to manage
     - Datacenter-1
   * - NETRIS_VNET_OWNER
     - The owner for virtual networks in Netris
     - Admin

NVIDIA UFM Configuration
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Parameter
     - Description
     - Example
   * - UFM_ADDR
     - The URL of your NVIDIA UFM server
     - https://ufm.example.com
   * - UFM_LOGIN
     - Username for authenticating with UFM
     - admin
   * - UFM_PASSWORD
     - Password for authenticating with UFM
     - 123456
   * - UFM_VERIFY_SSL
     - Whether to verify SSL certificates when connecting to UFM
     - true or false
   * - UFM_ID
     - Unique identifier for this UFM instance
     - ufm-lab
   * - UFM_PKEY_RANGE
     - Range of PKey IDs that can be allocated to clusters, in hexadecimal format
     - 100-7ffe

Agent Configuration
-----------------

.. list-table::
   :widths: 30 40 15 15
   :header-rows: 1

   * - Parameter
     - Description
     - Default
     - Example
   * - LOG_LEVEL
     - Logging level for the agent
     - info
     - info or debug
   * - RECONCILE_INTERVAL
     - Interval in seconds between reconciliation operations
     - 10
     - 10

Usage Guide
===========

After successfully installing and configuring the Netris-UFM agent, follow these steps to set up and use the integration:

1. Server Configuration in Netris
----------------------------------

The first step is to create servers in the Netris Controller inventory that match exactly with the servers in UFM:

1. In Netris Controller, navigate to **Network** → **Topology** → **+Add**.
2. Create servers with **identical names** as they appear in UFM (this is crucial for proper GUID mapping)
3. Once created, the Netris-UFM agent will automatically sync the InfiniBand GUIDs from UFM into Netris

.. important::
   Server names must match exactly between UFM and Netris Controller for the integration to work properly.

2. Create a Server Cluster Template
------------------------------------

Next, create a Server Cluster Template that defines the network configuration:

1. Navigate to **Services** → **Server Cluster Template**.
2. Click **Add** to create a new template
3. Configure the template using JSON with specific sections for different network fabrics

Here's an example template that configures:

- InfiniBand East-West fabric (managed by UFM)
- Ethernet North-South fabric (for in-band and storage traffic)
- OOB Management network

.. code-block:: json

   [
       {
           "postfix": "East-West",
           "type": "netris-ufm",
           "ufm": "ufm-lab",
           "pkey": "auto"
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
       }
   ]

Understanding the Template Structure
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **East-West Fabric (UFM)**:
  
  - ``"type": "netris-ufm"`` - Identifies this as an InfiniBand fabric managed by UFM
  - ``"ufm": "ufm-lab"`` - Specifies the UFM instance identifier
  - ``"pkey": "auto"`` - Automatically assigns an appropriate PKey from the configured range

- **North-South Fabric (Ethernet)**:
  
  - Standard Netris L2VPN configuration
  - ``"serverNics": ["eth9", "eth10"]`` - Specifies which NICs (9, 10) connect to this fabric

- **OOB Management**:
  
  - Separate network for out-of-band management
  - ``"serverNics": ["eth11"]`` - Specifies NIC 11 for this network

3. Create Server Clusters
--------------------------

After setting up the template, create actual server clusters:

1. Navigate to **Services** → **Server Cluster**
2. Click **Add** to create a new cluster
3. Select Site and Admin
4. Set VPC to 'create new'
5. Select the template you created in the previous step
6. Add the servers that should be part of this cluster
7. Submit the configuration

8. Verification
-----------------

Once the server cluster is created:

1. The Netris-UFM agent will automatically:

   - Identify the InfiniBand GUIDs associated with the servers in the cluster
   - Provision appropriate PKeys in UFM
   - Create necessary SHARP reservations if applicable

2. Verify the configuration:

   - Check the Netris Controller UI for successful cluster creation
   - Examine the UFM UI to confirm PKey assignments
   - Test connectivity between servers in the cluster via InfiniBand


3. Monitoring Integration Status
----------------------------------

To monitor the status of the integration:

1. Check the Netris-UFM agent logs (as described in the Monitoring section)
2. Verify the synchronization state:

   .. code-block:: bash

      # For Kubernetes
      kubectl logs -f deployment/netris-controller-nvidia-ufm-agent -n netris-controller
      
      # For Docker
      docker logs -f netris-ufm

Functional Workflow
=====================

1. **Discovery Phase**:

   - Plugin connects to both Netris Controller and NVIDIA UFM
   - InfiniBand port GUIDs are discovered from UFM and stored in Netris inventory

2. **Cluster Creation**:

   - When a server cluster is created or modified in Netris Controller
   - Plugin identifies affected servers and their InfiniBand GUIDs
   - Appropriate PKeys are automatically provisioned in UFM

3. **SHARP Integration**:

   - For high-performance network operations, SHARP reservations are created
   - These correspond to the server clusters defined in Netris

4. **Continuous Reconciliation**:

   - Plugin periodically synchronizes between Netris and UFM
   - Ensures consistency between Ethernet and InfiniBand configurations
   - Reconciliation interval is configurable (default: 10 seconds)

Monitoring and Troubleshooting
===============================

Viewing Logs
--------------

For Kubernetes deployment:

.. code-block:: bash

   kubectl logs -f deployment/netris-controller-nvidia-ufm-agent -n netris-controller

For Docker container:

.. code-block:: bash

   docker logs -f netris-ufm

Common Issues and Solutions
-----------------------------

Connection Issues to Netris Controller or UFM
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Symptoms**:

- Log messages indicating connection timeouts or authentication failures
- Missing data in Netris inventory

**Solutions**:

1. Verify network connectivity between the plugin and both systems:

   .. code-block:: bash

      ping netris.example.com
      ping ufm.example.com

2. Check credentials in the configuration:

   - Verify username/password combinations for both systems
   - Ensure API permissions are sufficient

3. Verify SSL certificate settings:

   - If using self-signed certificates, set NETRIS_VERIFY_SSL/UFM_VERIFY_SSL to "false"
   - For production, use valid certificates and set verification to "true"

PKey Assignment Issues
^^^^^^^^^^^^^^^^^^^^^^^^

**Symptoms**:

- Server clusters don't have proper isolation in InfiniBand
- Errors about PKey allocation failures in logs

**Solutions**:

1. Ensure the UFM_PKEY_RANGE has sufficient available IDs:

   - Check current PKey usage in UFM
   - Adjust the range if needed

2. Verify server naming consistency:
   
   - Server names must match exactly between Netris and UFM
   - Check for any server name discrepancies

3. Examine the PKey allocation process in debug logs:

   .. code-block:: bash

      # For Kubernetes
      kubectl logs -f deployment/netris-controller-nvidia-ufm-agent -n netris-controller | grep "PKey"
      
      # For Docker
      docker logs -f netris-ufm | grep "PKey"

SHARP Reservation Issues
^^^^^^^^^^^^^^^^^^^^^^^^^

**Symptoms**:

- InfiniBand performance is not at expected levels
- SHARP reservations are not being created

**Solutions**:

1. Verify SHARP is enabled on all relevant switches in UFM
2. Check UFM configuration for SHARP support
3. Ensure the plugin has permission to create SHARP reservations
4. Set LOG_LEVEL to "debug" for more detailed information:

   .. code-block:: bash

      LOG_LEVEL="debug"

Synchronization Delays
^^^^^^^^^^^^^^^^^^^^^^^

**Symptoms**:

- Changes in Netris don't appear quickly in UFM
- Inconsistent behavior after making configuration changes

**Solutions**:

1. Adjust the RECONCILE_INTERVAL to a shorter time period for faster synchronization
2. Check for high CPU or memory usage on the plugin host
3. Verify network latency between the plugin and both systems
4. Restart the plugin service if synchronization issues persist:

   .. code-block:: bash

      kubectl rollout restart deployment/netris-controller-nvidia-ufm-agent -n netris-controller

   or

   .. code-block:: bash

      docker restart netris-ufm

Version Compatibility
======================

.. list-table::
   :widths: 33 33 33
   :header-rows: 1

   * - Netris Controller Version
     - NVIDIA UFM Version
     - Plugin Version
   * - 4.4.1+
     - 6.15.4+
     - 0.1.1+

Getting Started Guide
======================

Quick Setup Example
--------------------

1. Install the plugin using the Kubernetes or Docker method above
2. Verify the plugin is running properly:

   .. code-block:: bash

      # For Kubernetes
      kubectl get pods -n netris-controller | grep ufm
      
      # For Docker
      docker ps | grep netris-ufm

3. Create a Server Cluster Template in Netris Controller UI or API
4. Create Server Cluster with the servers that have InfiniBand connections
5. Verify PKey assignments in UFM:

   - Check the UFM UI for PKey assignments
   - Verify servers in the cluster can communicate via InfiniBand

Additional Resources
=====================

- `NVIDIA UFM Documentation <https://docs.nvidia.com/networking/display/ufmenterpriseumv6200/>`_
- `Netris NVIDIA Spectrum-X Scenario <https://www.netris.io/docs/en/latest/try-learn/nvidia-spectrum-x-scenario.html>`_

---

You are welcome to join our `Slack channel <https://netris.io/slack>`_ to get additional support from our engineers and community. 
