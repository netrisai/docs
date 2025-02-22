.. meta::
  :description: Using Multi-interface SoftGate (experimental)

#############################################
Using Multi-interface SoftGate (experimental)
#############################################

By default, Netris uses the bond0 interface of SoftGates exclusively. For each V-NET, Netris creates a new subinterface (e.g., bond0.700) with the next available VLAN ID from the :doc:`Site's defined VLAN ID range <vpc-anywhere-check-default-site>`. However, a proposed experimental solution aims to modify this behavior.


   
Creating a V-Net
================

If you want to create a V-Net but prefer Netris to use existing interfaces instead of creating a new subinterface on the bond0 interface, you can achieve that by using the "int=<interface_name>" tag.

example - ``int=eth1``

.. image:: /tutorials/images/vpc-anywhere-vnet-experimental.png
    :align: center


SoftGate to SoftGate Link
=========================

In addition to creating a subinterface on the bond0 interface for each V-NET, Netris also creates a separate subinterface for SoftGates' internal use. This subinterface enables two SoftGates to communicate and synchronize mission-critical information. By default, Netris uses the last VLAN ID from the :doc:`Site's defined VLAN ID range <vpc-anywhere-check-default-site>` for this subinterface (e.g., bond0.900).

To change this behavior and use an existing interface instead of creating a new subinterface, navigate to the **Net → Inventory** section of the Netris web console. Click the **three vertical dots (⋮)** on the right side of the SoftGate node and select **Edit**. In the **Description** field of the opened window, type "int=<interface_name>" and save the changes.

example - ``int=eth2``

.. image:: /tutorials/images/vpc-anywhere-sg-to-sg-experimental.png
    :align: center

Repeat this action for the second SoftGate. 
