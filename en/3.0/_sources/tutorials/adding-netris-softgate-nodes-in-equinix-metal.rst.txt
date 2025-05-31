###########################################################
Provisioning Netris SoftGate nodes in Equinix Metal Project
###########################################################

For SoftGate nodes you can start with two c3.small.x86 or larger servers. In the future if you happen to need to upgrade to high-performance SoftGate PRO (with DPDK acceleration) you can upgrade the servers one-by-one. 

Request two servers(c3.small.x86) from Equinix Metal with Ubuntu 22.04 OS and wait until provisioned. 

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
