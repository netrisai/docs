###########################
Site Mesh with GCP Overview
###########################

Introduction
-------------

This guide provides a step-by-step process to set up and configure Netris Softgate in GCP for establishing a site mesh network between the user's on-premises, GCP, and other cloud environments.


Concept
--------

Netris Softgate in GCP is an VM instance that runs the Netris software. Therefore, you'll first need to create an VM instance for Netris Softgate and install the Netris software on it. Once that's done, you'll need to configure the routes in your GCP VPC for all destination IP subnets that exist in your other environments, such as on-premises or other clouds. This will allow your GCP VPC to access those destinations through the Netris Softgate VM instance.

.. image:: images/gcp-concept-traffic-flows.png
  :align: center

Once the routes are configured, you can enable a site mesh between Netris Softgate instances in different environments. Enabling the site mesh allows for secure communication between different environments and enables you to route traffic between the different subnets in a secure and efficient way.
