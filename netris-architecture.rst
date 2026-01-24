.. meta::
    :description: Netris Architecture

.. _netris_architecture:

###################
Netris Architecture
###################

A Netris system is composed of 3 elements:

* Netris Controller
* Netris Switch Agent
* Netris SoftGate

.. _netris_controller_def:

Netris Controller
=================

Netris Controller is the main operations control center for engineers using GUI/RestAPI/Kubernetes, systems, and network devices. The Netris Controller stores the data representing the user-defined network services and policies, health, statistics, analytics received from the network devices, and information from integration modules with external systems (Kubernetes, Terraform, etc.). Netris Controller can run as a VM or container, on/off-prem, or in Netris cloud.

Diagram: High level Netris architecture

.. image:: images/netris_controller_diagram.png
    :align: center
  
* **Controller HA** We highly recommend running more than one copy of the controller for database replication. Find here :doc:`backup and restore</controller-k3s-installation>` procedure.
* **Multiple sites** Netris is designed to operate multiple sites with just a single controller with HA
* **What if the controller is unreachable.** Netris operated switches/routers can tolerate the unreachability of the Netris Controller. Changes and stats collection will be unavailable during the controller unavailability window; however, switches/routers core operations will not be affected.

.. _netris_sw_agent:

Netris Switch Agent
===================

Netris Switch Agent is software running in the user space of the network operating system (NOS) of the switch and is responsible for automatically generating the particular switch configuration according to service requirements and policies defined in the Netris Controller. Netris Switch Agent uses an encrypted GRPC protocol for secure communication with the Netris Controller accessible through a local management network or over the Internet.

.. _netris_sg_agent:

Netris SoftGate
===============

In multi-tenant environments, tenants typically require controlled ingress and egress connectivity to their VPCs. For example, the workload access to and from the Internet.
SoftGate is an optional, multi-tenant (VPC-aware) software component designed for cloud providers and scales horizontally to provide this ingress and egress connectivity services (NAT and L4LB). The SoftGate software runs on a dedicated set of operator-provided bare-metal servers and is tightly integrated with the Netris-managed North-South fabric

You can learn more about SoftGate architecture and deployment scenarios in the :doc:`Netris SoftGate HS <netris-softgate-HS>` document.