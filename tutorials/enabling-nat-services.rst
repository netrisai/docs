#####################
Enabling NAT services
#####################

If you utilize private address space for your hosts, you may need a NAT service to enable internet access.
Netris Softgates support SNAT, DNAT and Masquerade features. 

.. note::
  Softgate PRO will support Masquerade in the future releases.

Navigate to Network → NAT → +Add

Create a SNAT service to allow connections from your hosts to the Internet.

.. image:: images/snat_add.png
    :align: center

Selecting a SNAT pool will allocate the entire pool for this service, preventing the use of IP addresses from the pool for DNAT or other SNAT purposes.

Create a DNAT service to allow connections from the Internet to your internal hosts with private IP.

.. image:: images/dnat_add.png
    :align: center
