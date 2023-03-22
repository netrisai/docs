###################################
Site-to-Site Mesh with AWS Overview
###################################

Introduction
-------------

This guide provides a step-by-step process to set up and configure Netris Softgate in AWS for establishing a site-to-site mesh network between the user's on-premises, AWS, and other cloud environments.


Concept
--------

Netris Softgate in AWS is an EC2 instance that runs the Netris software. Once the user creates an EC2 instance and installs Netris Softgate software on it, they need to configure the routes for all destination IP subnets that exist in their other environments, such as on-premises or other clouds. This enables the AWS VPC to have access to those destinations and vice versa.

.. image:: images/aws-concept-traffic-flows.png
  :align: center

To accomplish this, the user needs to enable a site-to-site VPN connection between the Netris Softgate instance in AWS and their on-premises environment or between Netris Softgate instances in different cloud environments. This VPN connection allows for secure communication between different environments and enables the user to route traffic between the different subnets in a secure and efficient way.
