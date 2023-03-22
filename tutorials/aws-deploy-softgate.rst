.. meta::
  :description: Deploy a Softgate in AWS

########################
Deploy a Softgate in AWS
########################

As stated in the previous section, the following sequence of actions must be taken in order to proceed: create an EC2 instance, add Softgate into the Netris Controller, install Netris Softgate software on the EC2 instance, and configure routes in AWS VPC. Let us commence with these steps in the specified order.

Create an EC2 instance
======================

Due to Netris Softgate is a network device capable of supporting numerous network services and being equipped with its own firewall, it is advisable to open all ports for the associated EC2. To achieve this, create a security group with the "All traffic" type and "Anywhere" source for both inbound and outbound rules. Afterward, an EC2 instance can be created using the security group above.

.. image:: images/aws-security-group.png
  :align: center

To enable connectivity with other Netris sites, it is essential to create the EC2 instance in the desired VPC. Therefore, provision a new EC2 instance with the Ubuntu 22.04 operating system installed, utilizing an instance type that meets the minimum hardware requirements of 2 virtual CPUs and 4 GB of RAM, such as t2.medium/t3.medium or any other type that satisfies these specifications. It is also recommended to allocate at least 30 GB of drive space.
