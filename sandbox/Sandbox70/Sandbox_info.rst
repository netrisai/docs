*************************
Welcome to Netris Sandbox
*************************

Netris sandbox is a ready-to-use environment for testing Netris automatic NetOps. 
Please see Topology diagram, check the example services, and learn by doing with our step-by-step guide for using Netris. 

This environment provides:

* Netris Controller: Cloud-hosted and loaded with examples.
* Switching fabric: Two spine switches and four leaf switches, all Netris-operated.
* SoftGate: Two SoftGate gateway nodes for border routing, L4 Load Balancing, site-to-site VPN, and NAT. Both Netris-operated.
* Linux servers: Four Linux servers, with root access where you can run any applications for your tests.
* Kubernetes cluster: A 3 node Kubernetes cluster, integrated with Netris controller, feel free to deploy any applications for your tests.
* ISP: Internet upstream, providing the sandbox Internet connectivity with real-world routable public IP addresses.

* Feel free to reach out to us if you have any questions. https://netris.ai/slack 

Topology diagram
================

.. image:: /images/sandbox_topology.png
    :align: center

Netris GUI
==========
http://demo70.netris.ai

Accessing Linux servers
=======================
.. code-block:: shell-session

  srv01: ssh demo@166.88.17.22 -p 23061
  srv02: ssh demo@166.88.17.22 -p 23062
  srv03: ssh demo@166.88.17.22 -p 23063
  srv04: ssh demo@166.88.17.22 -p 23064
  

Accessing Kubernetes cluster
============================
In Netris GUI, navigate to Services-->Kubenet. You'll find a pre-configured example Kubenet. Kubenet is a network service purpose built for serving to Kubernetes nodes. Edit the service and copy "Kubeconfig" from the example service into your ".kube/config" on your local machine. Now you should be able to kubectl the sandbox cluster.
  
Networks used
=============
.. code-block:: shell-session

  Management subnet: 10.254.45.0/24 
  Loopback subnet:   10.254.46.0/24
  Example subnet:    192.168.45.0/24
  Customer subnet:   192.168.46.0/24
  Public subnet:     50.117.59.208/28
