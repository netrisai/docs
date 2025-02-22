.. meta::
    :description: Getting Started for Equinix Metal

########################################
Equinix Metal API integration enablement
########################################


For each Equinix Metal Project+location you need to define an individual Site in Netris Controller.

Go to Netris Web Console → Net → Sites and click +Add.

You only need to deal with the below 5 fields. Leave the rest to default values for now. 


.. list-table:: 
   :widths: 25 50
   :header-rows: 1
   
   * - Netris Parameter
     - What to do:
   * - Switch Fabric
     - Select "Equinix Metal" from the dropdown menu.
   * - Name
     - Type a descriptive name for your Equinix Metal Project+location.
   * - Equinix Project ID
     - Copy/Paste the Project ID from Equinix Metal portal under Project Settings → General → Project ID.
   * - Equinix Project API key
     - Create a new Read/Write API key in Equinix Metal portal under Project Settings → Project API keys → + Add New Key. Then copy/paste here.
   * - Equinix Location
     - Select your equinix location from the dropdown menu.


Equinix Metal Project ID

.. image:: /tutorials/images/equinix-metal-project-id.png
    :align: center


Equinix Metal Project API key

.. image:: /tutorials/images/equinix-metal-project-api-keys.png
    :align: center


Netris Create New Site

.. image:: /tutorials/images/netris-create-equinix-metal-site.png
    :align: center
    

Adding Netris SoftGate nodes
============================

For SoftGate nodes you can start with two servers of the smallest flavor. In the future if you happen to need to upgrade to high-performance SoftGate PRO (with DPDK acceleration) you can upgrade the servers one-by-one. 

Request two servers from Equinix Metal with Ubuntu 22.04 OS and wait until provisioned. 

1) At this point you should see Netris Controller listing newly created servers as “Equinix Metal Server” under  Netris Web Console → Net → Inventory

.. image:: /tutorials/images/softgate-nodes-created-in-equinix.png
    :align: center

2) When Equinix finishes provisioning of the servers, click on each server name, then click tag, and add a tag “netris-softgate”. 

    Tag “netris-softgate” will signal Netris Controller that these two servers are going to be used as Netris SoftGate nodes in this particular site (Project+Location).

Then you should see in Netris web console that description changes from “Equinix Metal Server” into “Softgate Softgate1(2)”. You will also notice IP addresses listed per SoftGate, and Heartbeat: CRIT. We will bring Heartbeat to OK in next step.

.. image:: /tutorials/images/softgate-nodes-recognized-in-netris.png
    :align: center

3) Provision SoftGate nodes.

Netris Controller provides a one-liner command for provisioning SoftGate nodes. 
Go to Netris web console → Net → Inventory, click on the 3 dots menu, and click “Install Agent”, and copy the one-liner command.

Then SSH to the corresponding SoftGate server as a root user and paste the one-liner there. 

.. image:: /tutorials/images/softgate-one-liner-provisioning.png
    :align: center

When provisioning is done, reboot the server. In a few minutes Netris Controller should sense the heart beats from SoftGate as in the below screenshot. Repeat for the second SoftGate too.  

.. image:: /tutorials/images/softgate-green.png
    :align: center
