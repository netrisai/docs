##############
New Site setup
##############

For each individual deployment, region, location, data center, etc. you should define it as a Site. All network components and resources should be associated with their respective Site and VPC.

Add a new Site.
Network → Sites → +Add

* Enter the Site name
* Enter your public Autonomous System Number (ASN) if you have one. If not, use a private ASN within the range of 64512 to 65534.
* Choose Switch fabric type “Netris”.

If you're implementing the Zero Trust security model, you may want to select the ACL Default Policy "Deny." More details can be found 
:doc:`here</acls>`.

.. image:: /tutorials/images/site_setup.png
   :align: center

