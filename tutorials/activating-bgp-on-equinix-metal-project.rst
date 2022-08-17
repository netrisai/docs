#######################################
Activating BGP on Equinix Metal Project
#######################################

Why use BGP with Equinix Metal?
SoftGate nodes are like border routers to your VPC, they are routing traffic between hosts inside your project and the Internet. We are going to establish 2 BGP sessions between SoftGate nodes and Equinix Metal. So there will be 4 BGP sessions total. 

We need these BGP sessions for moving further. In the next chapters we are going to request pools of public IP addresses, that Netris will automatically advertise to Equinix Metal, so inbound traffic “knows” how to reach Load Balancer, NAT, and other services that you will use within your VPC. 

.. image:: /tutorials/images/equinix-metal-bgp-diagram.png
    :align: center

You only need to activate BGP on the Equinix Metal Project. Netris will handle the rest.
In the Equinix Metal web console go to IPs & Networks → BGP then click Activate BGP on This Project. (see below screenshots)

.. image:: /tutorials/images/equinix-metal-activate-bgp.png
    :align: center

Netris will handle the rest behind the scenes automatically. Netris will enable BGP peering on the Equinix Metal side, Netris will pull the metadata with the BGP info, and will automatically configure FRR (Free Range Routing BGP daemon) on both SoftGate nodes to bring up the BGP sessions up.

After a few minutes you should see 4 new BGP sessions in your Netris web console under Net → E-BGP. (example screenshot below).

.. image:: /tutorials/images/equinix-metal-netris-bgp-up.png
    :align: center


Now your Netris VPC has established BGP sessions with Equinix Metal Project, and you can proceed to the next step.
