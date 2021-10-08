.. meta::
    :description: Kubenet
  
#######
Kubenet
#######
Kubenet is a network service purpose-built for Kubernetes cluster nodes. Netris integrates with Kube API to provide on-demand load balancer and other Kubernetes specific networking features. Netris Kubenet is designed to complement Kubernetes CNI networking and provide a cloud-like user experience to local Kubernetes clusters.  

The Gateway and Switch Port part of Kubenet leverages a the V-Net service. Kubeconfig is for granting Netris Controller access to your Kube API. Kubenet dynamically leverages Netris L4LB and other services based on events that Netris kube-watcher (Kube API integration adapter) watches in your Kube API. 

Enabling Kubenet
----------------

To add a new Kubenet instance:

#. Navigate to 
#. Click the **Add** button

 .. csv-table:: Add Kubenet Fields
    :file: tables/kubenet.csv
    :widths: 25, 75
    :header-rows: 0

Example: Adding a new Kubenet service.

.. image:: images/new_kubenet.png
    :align: center
    :class: with-shadow
  
Once Netris Controller establishes a connection with Kube API, status will reflect on the listing.

Screenshot: Listing of Kubenet services. Kube API connection is successful.

.. image:: images/listing_kubenet.png
    :align: center
    :class: with-shadow
    
Screenshot: Physical Switch Port statuses.

.. image:: images/switch_port_statuses.png
    :align: center
    :class: with-shadow
      
Screenshot: Statuses of on-demand load balancers (type: load-balancer)

.. image:: images/load-balancer.png
    :align: center
    :class: with-shadow

