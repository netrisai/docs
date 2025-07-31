=====================================
Netris Internal CloudSim Deployment Automation
=====================================

Overview
========

The ``netris-internal-cloudsim-deployment-automation.zip`` project provides Ansible playbooks and Terraform configurations to automate the deployment of the Netris CloudSim environment on your own hardware. It streamlines the provisioning of a Netris Controller and associated resources on a KVM/QEMU hypervisor, leveraging Ansible for orchestration, Terraform for defining the infrastructure in the Netris Controller, and Pulumi for infrastructure provisioning.

The project is delivered as a zip file (``netris-internal-cloudsim-deployment-automation.zip``), containing all scripts, templates, and configurations required to deploy and manage the Netris Internal CloudSim environment.

Features
========

- **Full Deployment Automation**: Configures the server as a hypervisor, provisions a Netris Controller VM, installs the Netris Controller, and sets up infrastructure using OpenTofu and Pulumi.
- **Partial Deprovisioning**: Removes Pulumi and OpenTofu-managed resources while preserving the VM and other configurations for reuse.
- **Complete Destruction**: Fully tears down the Netris Internal CloudSim environment, including the VM and all configurations.
- **Modular Architecture**: Uses modular Ansible playbooks and OpenTofu configurations for maintainability and scalability.
- **Template-Driven Configuration**: Includes Jinja2 templates for consistent VM, network, and Pulumi configurations.

Requirements
============

This project requires the following prerequisites for successful deployment and operation:

- **Operating System**: The server must run Ubuntu 24.04 LTS.
- **Network Interfaces**: The server must have at least two (2) network interfaces:

  - One interface configured with a public (or routable) IP address for internet connectivity.
  - A second interface configured to connect to an upstream BGP peer for routing.

- **Hypervisor Readiness**: A KVM/QEMU hypervisor must be configured on the server during the preparation phase to support virtual machine provisioning for the Netris Internal CloudSim Controller and Nodes.
- **Management Network**: By default, Netris CloudSim uses the ``10.254.45.0/24`` private network for its management network. To modify this configuration if it conflicts with an existing network, configure the ``netris_cloudsim_priv_cidr``, ``netris_cloudsim_ctl_priv_ip``, and ``netris_cloudsim_hyper_bridge_priv_mgmt_ip`` variables as described in the :ref:`configurable-inventory-variables` section.
- **Zip File Location**: The ``netris-internal-cloudsim-deployment-automation.zip`` file must be located in the user’s home directory.
- **Netris Controller SSH Access**: By default, the automation exposes the Netris Controller VM to SSH access over the hypervisor’s public IP on port ``2222``. To modify this behavior, configure the ``netris_cloudsim_ssh_expose`` and ``netris_cloudsim_ssh_port`` variables as described in the :ref:`configurable-inventory-variables` section.

.. _prepare-the-server:

Prepare the Server for the Netris CloudSim Environment
=====================================================

Before deploying the Netris CloudSim environment, the server must be prepared to function as the hypervisor. Follow these steps to configure the server:

1. **Install Required Packages**: Update the package index and install essential tools (python3-pip, pipx, unzip) for the Netris CloudSim deployment:

   .. code-block:: bash

      sudo apt-get update && sudo apt-get install -y python3-pip pipx unzip

2. **Extract the Project**: Unzip the provided ``netris-internal-cloudsim-deployment-automation.zip`` file to the user’s home directory:

   .. code-block:: bash

      unzip $HOME/netris-internal-cloudsim-deployment-automation.zip -d $HOME/

3. **Configure pipx**: Ensure pipx is available in the system path:

   .. code-block:: bash

      /usr/bin/pipx ensurepath

4. **Add PATH to .bashrc**: Add ~/.local/bin to the user’s PATH in their .bashrc file:

   .. code-block:: bash

      echo 'export PATH="$PATH:$HOME/.local/bin"' >> $HOME/.bashrc
      source $HOME/.bashrc

5. **Install Ansible via pipx**: Install Ansible and its dependencies using pipx to manage the Netris CloudSim deployment:

   .. code-block:: bash

      pipx install --include-deps ansible

6. **Create a Python Virtual Environment**: Set up a virtual Python environment for the Netris CloudSim hypervisor in the user’s home directory:

   .. code-block:: bash

      python3 -m venv $HOME/python_venvs/cs-hyper

7. **Configure Inventory**: Open the inventory file with your text editor of choice (e.g., ``vim``) and update the **USER-CONFIGURABLE VARIABLES** section with relevant details as described in the :ref:`configurable-inventory-variables` section below. Inventory file location:

   .. code-block:: bash

      vim $HOME/netris-internal-cloudsim-deployment-automation/ansible/inventory/inventory.yaml

8. **Configure Network Bridges**: Apply the following Netplan configuration to set up network bridges on the server for the Netris CloudSim environment:

   .. code-block:: yaml

      ...
          bridges:
              csim-ctl-mgmt:
                  interfaces: []
                  addresses:
                      - 10.254.45.254/24  # Must match the value of netris_cloudsim_hyper_bridge_priv_mgmt_ip from inventory.yaml
                  mtu: 9000
                  parameters:
                      stp: false
                  optional: true
              br-mgmt:
                  interfaces: []
                  addresses: []
                  parameters:
                      stp: false
                  optional: true
              br-public:
                  interfaces:
                      - eno4  # Name of interface leading to upstream BGP peer
                  mtu: 9000
                  addresses: []
                  parameters:
                      stp: false
                  optional: true
      ...

.. _configurable-inventory-variables:

Configurable Inventory Variables
================================

Update the following variables in the ``$HOME/netris-internal-cloudsim-deployment-automation/ansible/inventory/inventory.yaml`` file to ensure proper configuration of the Netris CloudSim environment. All values are MANDATORY!:

.. code-block:: yaml

   # USER-CONFIGURABLE VARIABLES: REPLACE DEFAULTS OR SET AS NEEDED

   # Netris Controller Version
   # Specify the desired Netris Controller version. 4.5.1 is latest production release. Leave unchanged unless requested by Netris staff (e.g. netris_ctl_version: 4.5.1)
   netris_ctl_version: 4.5.1

   # Netris CloudSim Name Prefix
   # Set a lowercase prefix for CloudSim resources. Used for setting hostname and FQDN prefixes (e.g. netris_cloudsim_name_prefix: netris)
   netris_cloudsim_name_prefix: cudo

   # Domain Name
   # Replace 'null' with your domain name for FQDN configuration (e.g. ctl_fqdn: netris-ctl.example.com)
   netris_ctl_fqdn: null

   # Create SSH Key Pair
   # Set to 'false' if an SSH key pair exists at /home/<user>/.ssh. Set to 'true' to generate a new key pair. Possible values: true | false (e.g. create_ssh_keypair: false)
   create_ssh_keypair: true

   # Netris Controller SSH Exposure
   # Set to 'true' to expose the Netris Controller VM to SSH access over the hypervisor’s public IP on the specified port (default port 2222). Set to 'false' to disable SSH exposure. Possible values: true | false (e.g. netris_cloudsim_ssh_expose: false)
   netris_cloudsim_ssh_expose: true

   # Netris Controller SSH Port
   # Specify the port for SSH access to the Netris Controller VM if exposed. Default is 2222. Update to another port if needed (e.g. netris_cloudsim_ssh_port: 3333)
   netris_cloudsim_ssh_port: 2222

   # Private Network CIDR
   # Use '10.254.45.0/24' for the management network unless it conflicts with an existing network. If conflicting, choose another private CIDR (e.g. netris_cloudsim_priv_cidr: 10.254.46.0/24)
   netris_cloudsim_priv_cidr: 10.254.45.0/24

   # Netris Controller Private IP
   # Use '10.254.45.1' for the controller’s private IP unless the management network conflicts. Update to match the chosen CIDR (e.g. netris_cloudsim_ctl_priv_ip: 10.254.46.1)
   netris_cloudsim_ctl_priv_ip: 10.254.45.1

   # Hypervisor Bridge Private Management IP and Gateway
   # Use '10.254.45.254' for the hypervisor’s bridge IP unless the management network conflicts. Update to match the chosen CIDR (e.g. netris_cloudsim_hyper_bridge_priv_mgmt_ip: 10.254.46.254)
   netris_cloudsim_hyper_bridge_priv_mgmt_ip: 10.254.45.254

   # Hypervisor Public Interface Name
   # Replace 'null' with the name of the interface configured with the public IP. Verify the interface name on your server (e.g. netris_cloudsim_hyper_public_interface: eth0)
   netris_cloudsim_hyper_public_interface: null

   # Hypervisor Public IP
   # Replace 'null' with the public IP of the hypervisor. Ensure it’s routable for internet access (e.g. netris_cloudsim_hyper_pub_ip: 216.172.128.201)
   netris_cloudsim_hyper_pub_ip: null

   # BGP CIDR Block
   # Replace 'null' with a public /29 CIDR block for BGP routing (e.g. netris_cloudsim_bgp_cidr: 45.38.161.0/29)
   netris_cloudsim_bgp_cidr: null

   # NAT CIDR Block
   # Replace 'null' with a public /29 CIDR block for NAT configuration (e.g. netris_cloudsim_nat_cidr: 45.38.161.8/29)
   netris_cloudsim_nat_cidr: null

   # Layer 4 Load Balancer CIDR Block
   # Replace 'null' with a public /29 CIDR block for the Layer 4 Load Balancer (e.g. netris_cloudsim_l4lb_cidr: 45.38.161.16/29)
   netris_cloudsim_l4lb_cidr: null

Usage
=====

The project includes three primary Ansible playbooks to manage the Netris Internal CloudSim environment. All tasks must be run from the ``$HOME/netris-internal-cloudsim-deployment-automation/ansible`` directory:

1. **Deploy the Environment**: Deploys the full NETRIS Internal CloudSim environment, including hypervisor preparation, VM provisioning, NETRIS Controller installation, and infrastructure setup via Terraform and Pulumi. Upon completion, the script outputs essential access details, such as the NETRIS CloudSim URL, username, and password, to the terminal for convenient reference:

   .. code-block:: bash

      cd $HOME/netris-internal-cloudsim-deployment-automation/ansible
      ansible-playbook netris-internal-cloudsim-env/deploy_netris_internal_cloudsim.yaml

2. **Deprovision to Baseline**: Removes Pulumi and Terraform-managed resources, preserving the VM and other configurations for reuse:

   .. code-block:: bash

      cd $HOME/netris-internal-cloudsim-deployment-automation/ansible
      ansible-playbook netris-internal-cloudsim-env/deprovision_netris_internal_cloudsim.yaml

3. **Destroy the Environment**: Completely removes the Netris Internal CloudSim environment, including the VM and all configurations:

   .. code-block:: bash

      cd $HOME/netris-internal-cloudsim-deployment-automation/ansible
      ansible-playbook netris-internal-cloudsim-env/destroy_netris_internal_cloudsim.yaml

Support
=======

For assistance, contact Netris support at `support@netris.io <mailto:support@netris.io>`_, consult the Netris documentation at `netris.ai/docs <https://netris.ai/docs>`_, or join our Slack community at `netris.io/slack <https://netris.io/slack>`_ for real-time help.

Contributing
============

This project is tailored for a specific end customer and is not open to public contributions. For modifications, contact the Netris support team at `support@netris.io <mailto:support@netris.io>`_.

Project Status
==============

This project is actively maintained for Netris Internal CloudSim deployments. Updates will be provided to the end customers as needed.
