.. meta::
   :description: Netris Controller General Settings

################
General Settings
################

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

Settings → General holds the controller-wide parameters of a Netris Controller. These settings apply to every Site, VPC, and device the Controller manages; there is no per-Site override for any of them. Most deployments set the Controller FQDN, Local Repository, and Controller Management Address during installation and leave the rest at defaults.

To change a setting, navigate to Settings → General and click Edit. Changes take effect immediately on save; no Controller restart is required.

Settings
--------

.. list-table::
   :header-rows: 1
   :widths: 25 15 60

   * - Setting
     - Default
     - Description
   * - Netris Version
     - —
     - Read-only. Version of the Netris Controller software.
   * - Netris Auth Token
     - generated at install
     - Shared secret that Netris agents on switches, SoftGate nodes, and DPUs present when registering with the Controller. The agent installation one-liner embeds it. Use the eye icon to reveal it and the copy icon to copy it.
   * - Noreply email address
     - noreply@example.local
     - Sender address for email the Controller generates (alerts, notifications). Set it to an address your mail system accepts.
   * - Controller FQDN or IP address
     - —
     - Address at which switches, SoftGate nodes, DPUs, and users reach the Controller. Used in the agent installation one-liner and in generated links. Use an FQDN when the Controller is secured with a certificate issued for that name.
   * - Approval check for source address matching
     - true
     - When enabled, an agent's registration request is approved only if it arrives from the IP address recorded for that device in Inventory.
   * - Optimized deployment of ACLs for subinterfaces
     - true
     - When enabled, Netris installs ACL entries once per parent interface instead of once per subinterface where the result is equivalent, reducing rule count on the switch.
   * - L4LB: Number of probes in each health check iteration
     - 5
     - Probes sent to each L4 Load Balancer backend per health check iteration.
   * - L4LB: Number of failures to mark a backend as failed
     - 3
     - Consecutive failed iterations before a backend is removed from the pool.
   * - L4LB: Number of consecutive successes for the probe to be considered successful after having failed
     - 1
     - Consecutive successful iterations before a failed backend is returned to the pool.
   * - L4LB: Interval (seconds) between health checks
     - 10
     - Time between health check iterations.
   * - K8s Layer 4 load-balancer timeout (ms)
     - 2000
     - Timeout for L4 Load Balancer services created through the Netris Kubernetes integration.
   * - System ASN range
     - 4200000000 – 4209999999
     - Pool from which Netris assigns a BGP Autonomous System Number to each switch whose AS Number is set to assign automatically in Inventory. Site Public ASNs and E-BGP peer ASNs must not fall inside this range. See :doc:`Netris Site <site>`.
   * - Local Repository
     - disabled
     - When enabled, agents download the Netris agent installer, packages, and NOS images from the repository at this URL instead of the Netris public repository. Required for air-gapped deployments and for ZTP. See :doc:`installation/controller-k3s-air-gap-ha` and :doc:`installation/ztp`.
   * - Controller Management Address
     - disabled
     - IP address the agent installation one-liner and ZTP use to reach the Controller from the management network. Set it to the Controller's North-South VIP; in Hybrid OOB deployments, set it to the CMN address while provisioning seed switches, then to the N/S VIP. See :doc:`installation/ztp`.

UFM Settings
------------

These settings apply only when the NVIDIA UFM integration is in use. See :doc:`NVIDIA UFM (InfiniBand) Integration <netris-ufm-integration>`.

.. list-table::
   :header-rows: 1
   :widths: 25 15 60

   * - Setting
     - Default
     - Description
   * - Dry Run
     - false
     - When enabled, Netris computes the InfiniBand PKey changes it would apply to UFM and logs them without applying them.
   * - Debug
     - false
     - Enables verbose logging for the UFM integration.
   * - Reconcile Interval (seconds)
     - 30
     - How often Netris compares its intended PKey state with UFM and corrects drift.
