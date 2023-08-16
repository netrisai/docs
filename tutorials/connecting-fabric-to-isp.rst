##########################################
Connecting Netris managed fabric to an ISP
##########################################

BGP is used to connect the Netris managed fabric to an ISP for internet access. To do this, connect a cable from the ISP to your switch port. Then, use the information provided by your ISP to configure a BGP session within the Netris Controller.

To create a BGP session go to Network → E-BGP → +Add

.. image:: /images/create_bgp.png
    :align: center

If everything is correct, State, port and BGP will get green status.

.. image:: /images/bgp_status.png
    :align: center

Check out advanced BGP configuration here, if you require additional features.
