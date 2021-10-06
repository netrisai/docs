.. meta::
    :description: Netris Services and Configuration Examples
  
#############################
L3 Load Balancer (Anycast LB)
#############################
L3 (Anycast) load balancer is leveraging ECMP load balancing and hashing capability of spine and leaf switches to deliver line-rate server load balancing with health checks.

ROH servers, besides advertising their unicast (unique) loopback IP address, need to configure and advertise an additional anycast (the same IP) IP address. Unicast IP address is used for connecting to each individual server. 

End-user traffic should be destined to the anycast IP address. Switch fabric will ECMP load balance the traffic towards every server, as well as will hash based on IP/Protocol/Port such that TCP sessions will keep complete between given end-user and server pair. Optionally health checks are available to reroute the traffic away in the event of application failure. 

To configure L3 (Anycast) load balancing, edit an existing ROH instance entry and add an extra IPv4 address, and select Anycast. This will create a service under Services→Load Balancer and permit using the Anycast IP address in multiple ROH instances. 


Example: Adding an Anycast IPv4 address

.. image:: images/anycast_IPv4_address.png
    :align: center
    
   
Example: Under Services→Load Balancer, you can find the listing of L3 (Anycast) Load Balancers, service statuses, and you can add/remove more ROH instances and/or health checks.

.. image:: images/listing_L3.png
    :align: center
    

Screenshot: L3 (Anycast) Load Balancer listing.


.. image:: images/loadbalancer_listing.png
    :align: center


#######################
L4 Load Balancer (L4LB)
#######################
Netris L4 Load Balancer (L4LB) is leveraging SoftGate(Linux router) nodes for providing Layer-4 load balancing service, including on-demand cloud load balancer with native integration with Kubernetes. 

Enabling L4LB service
---------------------
L4 Load Balancer service requires at least one SoftGate node to be available in a given Site, as well as at least one IP address assignment (purpose=load balancer).

The IP address pool for L4LB can be defined in the Net→Subnets section by adding an Allocation and setting the purpose field to ‘load-balancer.’ You can define multiple IP pools for L4LB at any given Site.  See the below example.

Example: Adding a load-balancer IP pool assignment.

.. image:: images/IP_pool_assignment.png
    :align: center
    
    
Screenshot: Listing of Net→Subnets after adding a load-balancer assignment

.. image:: images/NetSubnets_listing.png
    :align: center
    
    
Consuming L4LB service
----------------------
This guide describes how to request an L4 Load Balancer using GUI. For Kubernetes integration, check the Kubenet section.

Click +add under Services→L4 Load Balancer to request an L4LB service.

Add new L4 Load Balancer fields are described below:

**General fields**

* **Name*** - Unique name. 
* **Protocol*** - TCP or UDP. 
* **Tenant*** - Requestor Tenant should have access to the backend IP space.
* **Site*** - Site where L4LB service is being requested for. Backends should belong on this site.
* **State*** - Administrative state.

**Frontend**

* **Address*** - Frontend IP address to be exposed for this L4LB service. “Assign automatically” will provide the next available IP address from the defined load-balancer pool. Alternatively, users can select manually from the list of available addresses.   
* **Port*** -  TCP or UDP port to be exposed.

**Health-check**

* **Type*** - Probe backends on service availability.

  * **None** - load balance unconditionally.
  * **TCP** - probe backend service availability through TCP connect checks.
  * **HTTP** - probe backend service availability through http GET checks.

* **Timeout(ms)*** - Probe timeout in milliseconds. 
* **Request path*** - Http request path. 

**Backend**

* **+Add** - add a backend host.
* **Address** - IP address of the backend host.
* **Port** - Service port on the backend host.
* **Enabled** - Administrative state of particular backend. 


Example: Requesting an L4 Load Balancer service.

.. image:: images/request_L4.png
    :align: center
    
Example: Listing of L4 Load Balancer services

.. image:: images/listing_L4.png
    :align: center
    
    
##########################
Access Control Lists (ACL)
##########################
Netris supports ACLs for switch network access control. (ACL and ACL2.0) ACL is for defining network access lists in a source IP: Port, destination IP: Port format. ACL2.0 is an object-oriented service way of describing network access.

Both ACL and ACL2.0 services support tenant/RBAC based approval workflows. Access control lists execute in switch hardware providing line-rate performance for security enforcement. It’s important to keep in mind that the number of ACLs is limited to the limited size of TCAM of network switches. 

Screenshot: TCAM utilization can be seen under Net→Inventory

.. image:: images/TCAM.png
    :align: center
    
Netris is applying several optimization algorithms to minimize the usage of TCAM while achieving the user-defined requirements.  

ACL Default Policy.
-------------------
The ACL default policy is to permit all hosts to communicate with each other.  You can change the default policy on a per Site basis by editing the Site features under Net→Sites. Once the “ACL Default Policy” is changed to “Deny,” the given site will start dropping any traffic unless specific communication is permitted through ACL or ACL2.0 rules.

Example: Changing “ACL Default Policy” for the site “siteDefault”.

.. image:: images/siteDefault.png
    :align: center
    

ACL rules
---------
ACL rules can be created, listed, edited, approved under Services→ACL.

Description of ACL fields.
General

* **Name*** - Unique name for the ACL entry.
* **Protocol*** - IP protocol to match.

  * All - Any IP protocols.
  * IP - Specific IP protocol number.
  * TCP - TCP.
  * UDP - UDP.
  * ICMP ALL - Any IPv4 ICMP protocol.
  * ICMP Custom - Custom IPv4 ICMP code.
  * ICMPv6 ALL - Any IPv6 ICMP protocol. 
  * ICMPv6 Custom - Custom IPv6 ICMP code.
  
* **Active Until** - Disable this rule at the defined date/time. 
* **Action** - Permit or Deny forwarding of matched packets.
* **Established/Reverse** - For TCP, also match reverse packets except with TCP SYN flag. For non-TCP, also generate a reverse rule with swapped source/destination.  

Source/Destination - Source and destination addresses and ports to match.

* **Source*** IPv4/IPv6 - IPv4/IPv6 address.
* **Ports Type*** 

  * Port Range - Match on the port or a port range defined in this window.
  * Port Group - Match on a group of ports defined under Services→ ACL Port Group.
  
* **From Port*** - Port range starting from.
* **To Port*** - Port range ending with.

* **Comment** - Descriptive comment, commonly used for approval workflows.

* **Check button** - Check if Another ACL on the system already permits the described network access.

Example: Permit hosts in 10.0.3.0/24 to access hosts in 10.0.5.0/24 by SSH, also permit the return traffic (Established).

.. image:: images/action_permit.png
    :align: center
    
   
Example: “Check” shows that requested access is already provided by a broader ACL rule.

.. image:: images/ACL_rule.png
    :align: center
    
    
ACL approval workflow
---------------------
When one Tenant (one team) needs to get network access to resources under the responsibility of another Tenant (another team), an ACL can be created but will activate only after approval of the Tenant responsible for the destination address resources. See the below example.

Example: User representing QA_tenant is creating an ACL where source belongs to QA_tenant, but destination belongs to the Admin tenant.

.. image:: images/ACL_approval.png
    :align: center
    
Screenshot: ACL stays in “waiting for approval” state until approved.
    
.. image:: images/waiting_approval.png
    :align: center
    
Screenshot: Users of tenant Admin, receive a notification in the GUI, and optionally by email. Then one can review the access request and either approve or reject it.

.. image:: images/approve_reject.png
    :align: center
    
Screenshot: Once approved, users of both tenants will see the ACL in the “Active” state, and soon Netris Agents will push the appropriate config throughout the switch fabric.

.. image:: images/ACL_active.png
    :align: center
    
The sequence order of ACL rules
-------------------------------
1. User-defined Deny Rules
2. User-defined Permit Rules
3. Deny the rest

