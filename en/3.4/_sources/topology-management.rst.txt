.. _topology-management:
.. meta::
    :description: Topology Management

=========
Inventory
=========
The Inventory section allows you to add/edit/delete network switches and SoftGates.  Initial setup of a Netris managed network is a three part process:

#. Create Inventory Profiles
#. Adding Switches
#. Adding Softgates

Inventory Profiles
==================
Inventory profiles allow security hardening of inventory devices. By default all traffic flow destined to switch/SoftGate is allowed. 
As soon as the inventory profile is attached to a device it denies all traffic destined to the device except Netris-defined and user-defined custom flows. Generated rules include:

*  SSH from user defined subnets
*  NTP from user defined ntp services
*  DNS from user defined DNS servers
*  Custom user defined rules

.. csv-table:: Inventory Profile Fields
   :file: tables/inventory-profile-fields.csv
   :widths: 25, 75
   :header-rows: 0

**Example:** In this example Netris Controller is used to provide NTP and DNS services to the switches (common setup).

.. image:: images/inventory-profile.png
   :align: center
   :class: with-shadow

.. _topology-management-adding-switches:

Adding Switches
===============
Every switch needs to be added to the Netris Controller inventory.  You can add new devices with the following process:

#. Navigate to **Net→Inventory**
#. Click the **Add** button
#. Fill in the fields as described below
#. Click the **Add** button

 .. csv-table:: Add Inventory Fields - Switch
    :file: tables/inventory-add-switch.csv
    :widths: 25, 75
    :header-rows: 0

**Example:**  Add a new Switch.

  .. image:: images/add-new-hardware.png
     :align: center
     :class: with-shadow

.. note:: Repeat this process to define all your switches.

.. _topology-management-adding-softgates:

Adding SoftGates
================
Every SoftGate node needs to be added to the Netris Controller inventory.  To add a SoftGate node:

#. Navigate to **Net→Topology**
#. Click **Add**
#. Fill in the fields as described below
#. Click the **Add** button

.. csv-table:: Add Inventory Fields - SoftGate
   :file: tables/inventory-add-softgate.csv
   :widths: 25, 75
   :header-rows: 0

Example: Adding a SoftGate Node to Topology.

.. image:: images/add-softgate.png
   :align: center
   :class: with-shadow

Viewing Inventory
=================

Inventory Listing shows also Heartbeat and monitoring statuses of each device.

Heartbeat - Shows the status of device reachability.
Health - Shows number of successful and failed checks on the device.

  .. image:: images/inventory-listing.png
     :align: center
     :class: with-shadow      

.. note:: You can also add new devices in the Topology view.

================
Topology Manager
================

The topology manager is for describing and monitoring the desired network topology. Netris Switch Agents will configure the underlying network devices according to this topology dynamically and start watching against potential failures.

Adding Links
============

To define the links in the network:

#. Right-click on the spine switch
#. Click **Create Link**
#. Select the **From Port** and the **To Port**

See the example below:  

.. image:: images/create_link.png
   :align: center
   :class: with-shadow
    
.. image:: images/topology_manager.png
   :align: center
   :class: with-shadow
    
Once the links have been defined, the network is automatically configured as long as physical connectivity is in place and Netris Agents can communicate with Netris Controller.

.. tip:: You can drag/move the units to your desired positions and click “Save positions”.

Hairpin Links (Nvidia Cumulus only) 
===================================
With Nvidia Cumulus Linux only, we need to loop two ports on spine switches (hairpin cable) in the current release, usually two upstream (higher capacity) ports. We are planning to lift this requirement in the next Netris release (v2.10).

To define what ports will be used as a hairpin, navigate to Net→Switch Ports, or right-click on the spine switch, click Ports in Net-->Topology.

Example: Accessing Switch Ports from Net→Topology

.. image:: images/switch_port.png
   :align: center
   :class: with-shadow

For each spine switch, find the two ports that you are going to connect (loop/hairpin) and configure one port as a “hairpin **l2**” and another port as “hairpin **l3**”. The order doesn’t matter. The system needs to know which ports you have dedicated for the hairpin/loop on each spine switch. (do not do this for non-Cumulus switches)  
|
Example: Editing Switch Port from Net→Switch Ports.

.. image:: images/edit_switch_port.png
   :align: center
   :class: with-shadow
    
Example: Setting port types to “hairpin l2” and “hairpin l3”.

.. image:: images/hairpin.png
   :align: center
   :class: with-shadow
    
Screenshot: Hairpin visualized in Net→Topology

.. image:: images/hairpin_topology.png
   :align: center
   :class: with-shadow
