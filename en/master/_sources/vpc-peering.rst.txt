.. meta::
    :description: Netris VPC Peering

======================
VPC Peering
======================

VPC peering allows routing between two VPCs. It is typically used to connect a tenant VPC to a "shared" VPC where the shared services (like storage access, DNS, etc.) are located.

Consider the following scenario. Customer VPC A and Customer VPC B accessing common services in a "Shared" VPC via VPC peering.

Customer A and Customer B cannot access each other's VPCs.

Customer A VPC will have routes of the "Shared" VPC, it will NOT have routes of Customer B VPC. Customer B VPC will have routes of the "Shared" VPC, it will NOT have routes of Customer A VPC.

The "Shared" VPC will have routes of both A and B. Because A does not have routes of B and vice versa they cannot reach each other.

Network Administrators are free to define prefix lists of VPC peering: if VPC A is configured to accept routes of VPC B from the "Shared" VPC, then Customer A can reach Customer B, but not if peering is created without defining a prefix list (letting Netris auto-populate).

Peering a BGP-only VPC
^^^^^^^^^^^^^^^^^^^^^^

A VPC that has no V-Nets — only BGP sessions — can still be peered. The BGP session provisions the VPC's VRF on the switch where it terminates, so peering works without creating a placeholder ("dummy") V-Net just to bring the VRF into existence. See :ref:`How a VPC's VRF is placed on the fabric <vpc_vrf_placement>` on the Netris VPC page for the underlying behavior.

.. note::

   Additional details are coming soon…

----

**See also:** :doc:`Netris VPC <vpc>` and :doc:`VPC Connect <vpc-connect>`. VPC Peering connects VPCs to one another, while VPC Connect connects a VPC to external networks — both concern connectivity beyond a single VPC's boundary.
