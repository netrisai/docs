.. meta::
    :description: Introduction to Netris

Introduction to Netris
======================

Netris is a network automation, abstraction, and multi-tenancy platform for modern data centers and AI infrastructure environments. Netris brings cloud-like VPC abstractions for operating physical networks like it is a cloud. Netris automatically configures switching, routing, load-balancing, and network security based on user-defined services and policies. Netris continuously monitors the network’s health and either applies software remediation or informs you of necessary actions if human intervention is required. Netris abstracts away the complexities of detailed network configuration, letting you perform efficiently by operating your physical network in a top-down approach like a cloud -- instead of the legacy box-by-box operation.

Netris supports switch hardware from NVIDIA (Cumulus Linux), Dell (SONiC), Arista (EOS), and EdgeCore (SONiC). See the :doc:`Supported Platforms Matrix <supported-platform-matrix>` for a complete list of supported features and hardware.

For AI networking environments, Netris orchestrates multi-tenant isolation across Ethernet (NVIDIA Spectrum-X), InfiniBand (via :doc:`NVIDIA UFM <netris-ufm-integration>`), and NVLink GPU fabrics (via :doc:`NVIDIA NMX-C <netris-nvlink-integration>`). Netris automates the provisioning of hardware-enforced isolation constructs -- including VRF, VXLAN, ACLs, InfiniBand partition keys (PKeys), and NVLink partitions -- enabling operators to define tenant boundaries once and have them consistently enforced across all fabric types. Netris also manages :doc:`NVIDIA BlueField DPUs <bluefield-3-dpus>` as first-class network devices for hardware-accelerated multi-tenancy.

Netris :doc:`SoftGate <netris-softgate-HS>` (VPC Gateway) provides network services and is an optional, multi-tenant (VPC-aware) software component designed for cloud providers. It scales horizontally to provide ingress and egress connectivity services (NAT and L4LB). The SoftGate software runs on a dedicated set of operator-provided bare-metal x86 servers and is tightly integrated with the Netris-managed North-South fabric.

The Netris Controller is deployed entirely within the customer’s infrastructure environment. Operational data, configuration state, and administrative access remain within the organization’s security perimeter. Day-to-day operation does not require Internet connectivity. See :doc:`Netris Architecture <netris-architecture>` for details on security design principles, management network architecture, and the shared responsibility model.

.. image:: images/private-cloud-enterprise-dc-2.png
    :align: center
    
