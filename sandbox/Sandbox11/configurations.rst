.. _s11-pre-configured:

********************************
Provided Example Configurations
********************************
Once you log into the Netris Controller, you will find that certain services have already been pre-configured for you to explore and interact with. You can also learn how to create some of these services yourself by following the step-by-step instructions in the :ref:`"Learn by Creating Services"<s11-learn-by-doing>` document.

V-Net (Ethernet/Vlan/VXlan) Example
===================================
After logging into the Netris Controller by visiting `https://sandbox11.netris.io <https://sandbox11.netris.io>`_ and navigating to **Services → V-Net**, you will find a V-Net service named "**vnet-example**" already configured for you as an example. 

If you examine the particular service settings ( select **Edit** from the **Actions** menu indicated by three vertical dots (**⋮**) on the right side of the "**vnet-example**" service), you will find that the services is configured on the second port of **switch 21** named "**swp2(swp2)@sw21-nyc (Admin)**". 

The V-Net servicers is also configured with both an IPv4 and IPv6 gateway, **192.168.45.1** (from the "**192.168.45.0/24 (EXAMPLE)**" subnet) and **2607:f358:11:ffcb::1** (from the "**2607:f358:11:ffcb::/64 (EXAMPLE IPv6)**" subnet) respectively. 

You may also verify that the service is working properly from within the GUI: (*\*Fields not specified should remain unchanged and retain default values*)

1. Navigate to **Net → Looking Glass**.
2. Select switch "**sw21-nyc(10.254.46.21)**" (the switch the "**vnet-example**" service is configured on) from the **Select device** drop-down menu.
3. Select "**Ping**" from the **Command** drop-down menu.
4. Type ``192.168.45.64`` (the IP address of **srv04-nyc** connected to **swp2@sw21-nyc**) in the field labeled **IPv4 address**.
5. Click **Submit**.

The result should look similar to the output below, indicating that the communication between switch **sw21-nyc** and server **srv04-nyc** is working properly thanks to the configured V-Net service.

.. code-block:: shell-session

  sw21-nyc# ip vrf exec Vrf_netris ping -c 5 192.168.45.64
  PING 192.168.45.64 (192.168.45.64) 56(84) bytes of data.
  64 bytes from 192.168.45.64: icmp_seq=1 ttl=64 time=0.562 ms
  64 bytes from 192.168.45.64: icmp_seq=2 ttl=64 time=0.745 ms
  64 bytes from 192.168.45.64: icmp_seq=3 ttl=64 time=0.690 ms
  64 bytes from 192.168.45.64: icmp_seq=4 ttl=64 time=0.737 ms
  64 bytes from 192.168.45.64: icmp_seq=5 ttl=64 time=0.666 ms

  --- 192.168.45.64 ping statistics ---
  5 packets transmitted, 5 received, 0% packet loss, time 4092ms
  rtt min/avg/max/mdev = 0.562/0.680/0.745/0.065 ms

If you are interested in learning how to create a V-Net service yourself, please refer to the step-by-step instructions found in the :ref:`"V-Net (Ethernet/Vlan/VXlan)"<s11-v-net>` section of the :ref:`"Learn by Creating Services"<s11-learn-by-doing>` document.

More details about V-Net (Ethernet/Vlan/VXlan) can be found on the the :ref:`"V-NET"<v-net_def>` page.

E-BGP (Exterior Border Gateway Protocol) Example
================================================

Navigate to **Net → E-BGP**. Here, aside from the necessary system generated IPv4/IPv6 E-BGP peer connections between the two border routers ( **SoftGate1** & **SoftGate2** ) and the rest of the switching fabric (which can be toggled on/off using the **Show System Generated** toggle at the top of the page), you will also find two E-BGP sessions named "**iris-isp1-ipv4-example**" and "**iris-isp1-ipv6-example**" configured as example with **IRIS ISP1**. This ensures communication between the internal network with the Internet. 

You may examine the particular session configurations of the E-BGP connections by selecting **Edit** from the **Actions** menu indicated by three vertical dots (**⋮**) on the right side of either the "**iris-isp1-ipv4-example**" and "**iris-isp1-ipv6-example**" connections. You may also expand the **Advanced** section located toward the bottom of the **Edit** window to be able to access the more advanced settings available while configuring an E-BGP session.

If you are interested in learning how to create an additional E-BGP session with **IRIS ISP2** in order to make the Sandbox upstream connections fault tolerant yourself, please refer to the step-by-step instructions found in the :ref:`"E-BGP (Exterior Border Gateway Protocol)"<s11-e-bgp>` section of the :ref:`"Learn by Creating Services"<s11-learn-by-doing>` document.

More details about E-BGP (Exterior Border Gateway Protocol) can be found on the the :ref:`"BGP"<bgp_def>` page.

NAT (Network Address Translation) Example
=========================================
Navigate to **Net → NAT** and you will find a NAT rule named "**NAT Example**" configured as an example for you. The configured "**SNAT**" rule ensures that there can be communication between the the private "**192.168.45.0/24 (EXAMPLE)**" subnet and the Internet. 

You can examine the particular settings of the NAT rule by clicking **Edit** from the **Actions** menu indicated by three vertical dots (**⋮**) on the right side of the "**NAT Example**" service.

You may also observe the functioning NAT rule in action by pinging any public IP address (e.g. **1.1.1.1**)  from the **srv04-nyc** server.

* In a terminal window:                                                                                   
                             
  1. SSH to server **srv04-nyc**: ``ssh demo@50.117.27.82 -p 30064``.
  2. Enter the password provided in the introductory e-mail.
  3. Start a ping session: ``ping4 1.1.1.1``

You will see replies in the form of "**64 bytes from 1.1.1.1: icmp_seq=1 ttl=62 time=1.10 ms**" indicating proper communication with the **1.1.1.1** public IP address.

If you are interested in learning how to create a NAT rule yourself, please refer to the step-by-step instructions found in the :ref:`"NAT (Network Address Translation)"<s11-nat>` section of the :ref:`"Learn by Creating Services"<s11-learn-by-doing>` document.

More details about NAT (Network Address Translation) can be found on the :ref:`"NAT"<nat_def>` page.

ACL (Access Control List) Example
=================================
Navigate to **Services → ACL** and you will find an ACL services named "**V-Net Example to WAN**" set up as an example for you. This particular ACL ensures that the connectivity between the the private "**192.168.45.0/24 (EXAMPLE)**" subnet and the Internet is permitted through all protocols and ports, even in a scenario where the the "**ACL Default Policy**" for the "**US/NYC**" site configured under **Net → Sites** in our Sandbox is changed from **Permit** to **Deny**. 

You can examine the particular settings of this ACL policy by selecting **Edit** from the **Actions** menu indicated by three vertical dots (**⋮**) on the right side of the "**V-Net Example to WAN**" ACL policy.

By utilizing ACLs, you can impose granular controls and implement policies that would permit or deny particular connections of any complexity. If you are interested in learning how to create ACL policies yourself, please refer to the step-by-step instructions found in the :ref:`"ACL (Access Control List)"<s11-acl>` section of the :ref:`"Learn by Creating Services"<s11-learn-by-doing>` document.

More details about ACL (Access Control List) can be found on the :ref:`"ACL"<acl_def>` page.