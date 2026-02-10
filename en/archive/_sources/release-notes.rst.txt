.. meta::
    :description: Netris Release Notes

#############
Release notes
#############
* DPDK​ ​data plane support for SoftGate nodes​. - Provides higher SoftGate performance. Up to 27Mpps, 100Gbps for L3 routing, 12Mpps with NAT rules on.
* L4 Load Balancer​. - In addition to switch-based Anycast Load Balancer, we now support a SoftGate/DPDK-based L4 Load Balancer. L4LB integrates with Kubernetes providing cloud-like load balancer service (type: load-balancer).
* Kubenet​ - a network service purpose-built for Kubernetes cluster nodes. Kubenet integrates with Kube API to provide an on-demand load balancer andother Kubernetes specific networking features. Netris Kubenet is designed to complement Kubernetes CNI networking with modern physical networking.
* API logs​ - Comprehensive logging of all API calls sent to Netris Controller with the ability to search by various attributes, sort by each column, and filter by method type.
* Site Mesh​ - a Netris service for automatically configuring site-to-site interconnect over the public Internet. Site Mesh supports configuration for WireGuard to create encrypted tunnels between participating sites andautomatically generates configuration for FRR to run dynamic routing. In a few clicks, services in one site get connectivity to services in other sites over a mesh of WireGuard tunnels.
* Ubuntu/SwitchDev updates​ - Removed the requirement for a hairpin loop cable. Removed the need for IP address reservation for V-NET, switching entirely to the anycast default gateway.
* Controller distributions​ - Netris controller, is now available in three deployment forms. 1) On-prem KVM virtual machine. 2) Kubernetes application. 3) Managed/Hosted in the cloud.
* Inventory Profiles​ - A construct for defining access security, timezone, DNS,NTP settings profiles for network switches and SoftGate nodes.
* Switch/SoftGate agents​ - New installer with easy initial config tool. Support for IP and FQDN as a controller address. Authentication key.
* GUI​ - Improved Net→Topology section, becoming the main and required place for defining the network topology. All sections got a column organizer, so every user can order and hide/show columns to their comfort.
