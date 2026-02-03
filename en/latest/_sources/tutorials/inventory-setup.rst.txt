###############
Inventory setup
###############

The Inventory section includes Netris-managed devices and allows you to add, edit, or delete network switches and SoftGates.
The initial setup of the Netris managed fabric consists of a three-step process:

* Create Inventory Profiles
* Add Switches
* Add Softgates

.. note::
  You can also add new devices in the Topology view.


**Inventory profiles**

Inventory profiles enable security hardening for inventory devices. By default, all traffic flow destined for a switch or SoftGate is allowed. However, once an inventory profile is attached to a device, it denies all traffic destined for the device except for Netris-defined and user-defined custom flows. Generated rules include:

* SSH from user-defined subnets
* NTP from user-defined NTP services
* DNS from user-defined DNS servers
* Custom user-defined rules

The Netris Controller includes a preconfigured Inventory profile named "default-inventory-profile." You can either edit this profile or create your own.

**SoftGate creation**

Each SoftGate node needs to be added to the Netris Controller inventory.
Network → Inventory → +Add

.. image:: images/inventory_softgate.png
    :align: center

**Switch creation**

Each Switch node needs to be added to the Netris Controller inventory.
Network → Inventory → +Add

.. image:: images/inventory_switch.png
    :align: center





