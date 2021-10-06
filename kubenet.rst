.. meta::
    :description: Kubenet
  
#######
Kubenet
#######
Kubenet is a network service purpose-built for Kubernetes cluster nodes. Netris integrates with Kube API to provide on-demand load balancer and other Kubernetes specific networking features. Netris Kubenet is designed to complement Kubernetes CNI networking and provide a cloud-like user experience to local Kubernetes clusters.  

The Gateway and Switch Port part of Kubenet is similar to the V-NET. In fact, it is leveraging a V-NET. Kubeconfig is for granting Netris Controller access to your Kube API. Kubenet therefore, dynamically leverages Netris L4LB and other services based on events that Netris kube-watcher (Kube API integration adapter) watches in your Kube API. 

Description of Kubenet fields.

- **Name** - Unique name for the Kubenet.
- **Tenant** - Tenant, who can make any changes to current Kubenet.
- **Site** - Site where Kubernetes cluster belongs. 
- **State** - Active/Disable state for particular Kubenet service.
- **IPv4** Gateway - IPv4 address to be used as a default gateway for current Kubenet. 
- **Port** - Physical Switch Port anywhere on the switch fabric. Switch Port should be assigned to the owner tenant under Net→Switch Ports.

  - **Enabled** - Enable or disable individual Switch Port under current Kubenet.
  - **Port Name** - Switch Port format: <alias>(swp<number>)@<switch name>
  - **VLAN ID / Untag** - Specify a VLAN ID for tagging traffic on a per-port basis or set to Untag not to use tagging on a particular port. 

- **Kubeconfig** - After installing the Kubernetes cluster, add your Kube config for granting Netris at least read-only access to the Kube API. 

.. tip:: Many switches can’t autodetect old 1Gbps ports. If attaching hosts with 1Gbps ports to 10Gpbs switch ports, you’ll need to change the speed for a given Switch Port from Auto(default) to 1Gbps. You can edit a port in Net→Switch Ports individually or in bulk.

Example: Adding a new Kubenet service.

.. image:: images/new_kubenet.png
    :align: center
  
Once Netris Controller establishes a connection with Kube API, status will reflect on the listing.


Screenshot: Listing of Kubenet services. Kube API connection is successful.

.. image:: images/listing_kubenet.png
    :align: center
    

Screenshot: Physical Switch Port statuses.

.. image:: images/switch_port_statuses.png
    :align: center
    
    
Screenshot: Statuses of on-demand load balancers (type: load-balancer)

.. image:: images/load-balancer.png
    :align: center