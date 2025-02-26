.. meta::
    :description: Inventory Profiles

==================
Inventory Profiles
==================

Inventory profiles allow security hardening of inventory devices. By default all traffic flow destined to switch/softgate is allowed. 
As soon as the inventory profile is attached to a device it denies all traffic destined to the device except netris-defined and user-defined custom flows. Generated rules include:

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
   :alt: Adding an inventory profile
