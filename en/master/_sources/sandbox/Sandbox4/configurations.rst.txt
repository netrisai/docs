.. _s4-pre-configured:

********************************
Provided Example Configurations
********************************

.. contents::
   :local:

Once you log into the Netris Controller, you will find that certain services have already been pre-configured for you to explore and interact with. You can also learn how to create some of these services yourself by following the step-by-step instructions in the :ref:`"Learn by Creating Services"<s4-learn-by-doing>` document.

V-Net (Ethernet/Vlan/VXlan) Example
===================================
To access the V-Net service example, first log into the Netris Controller by visiting `https://sandbox4.netris.io <https://sandbox4.netris.io>`_ and navigating to **Services → V-Net**, where you will find a pre-configured V-Net service named "**vnet-example**" available as an example.

To examine the service settings, select **Edit** from the **Actions** menu indicated by three vertical dots (**⋮**) on the right side of the "**vnet-example**" service, where you'll see that the V-Net service is configured with VLAN ID **45** in order to enable **EVPN Multihoming** on the underlying switches.

You'll also see that the V-Net service is configured with both an IPv4 gateway (**192.168.45.1**) from the "**192.168.45.0/24 (EXAMPLE)**" subnet and an IPv6 gateway (**2607:f358:11:ffc4::1**) from the "**2607:f358:11:ffc4::/64 (EXAMPLE IPv6)**" subnet.

Additionally, the V-Net service is configured to utilize network interfaces on both switches 21 and 22. Specifically, it is connected to **swp4(swp4)@sw21-nyc (Admin)** on switch 21 and **swp4(swp4)@sw22-nyc (Admin)** on switch 22.

You may also verify that the service is working properly from within the GUI: (*\*Fields not specified should remain unchanged and retain default values*)

1. Navigate to **Network → Looking Glass**.
2. Make sure "**vpc-1:Default**" is selected from the **VPC** drop-down menu.
3. Select "**SoftGate1(45.38.161.80)**" from the **Hardware** drop-down menu.
4. Leave the "**Family: IPV4**" as the selected choice from the **Adrress Family** drop-down menu.
5. Select "**Ping**" from the **Command** drop-down menu.
6. Leave the "**Selecet IP address**" as the selected choice from the **Source** drop-down menu.
7. Type ``192.168.45.64`` (the IP address configured on **bond0.45** on **srv04-nyc**) in the field labeled **IPv4 address**.
8. Click **Submit**.

The result should look similar to the output below, indicating that the communication between SoftGate **SoftGate1** and server **srv04-nyc** is working properly thanks to the configured V-Net service.

.. code-block:: shell-session

  SoftGate1# ping -c 5 192.168.45.64
  PING 192.168.45.64 (192.168.45.64) 56(84) bytes of data.
  64 bytes from 192.168.45.64: icmp_seq=1 ttl=61 time=6.29 ms
  64 bytes from 192.168.45.64: icmp_seq=2 ttl=61 time=5.10 ms
  64 bytes from 192.168.45.64: icmp_seq=3 ttl=61 time=4.82 ms
  64 bytes from 192.168.45.64: icmp_seq=4 ttl=61 time=4.82 ms
  64 bytes from 192.168.45.64: icmp_seq=5 ttl=61 time=4.79 ms
  --- 192.168.45.64 ping statistics ---
  5 packets transmitted, 5 received, 0% packet loss, time 4002ms
  rtt min/avg/max/mdev = 4.787/5.161/6.285/0.572 ms

If you are interested in learning how to create a V-Net service yourself, please refer to the step-by-step instructions found in the :ref:`"V-Net (Ethernet/Vlan/VXlan)"<s4-v-net>` section of the :ref:`"Learn by Creating Services"<s4-learn-by-doing>` document.

More details about V-Net (Ethernet/Vlan/VXlan) can be found on the the :ref:`V-Net"<v-net_def>` page.

E-BGP (Exterior Border Gateway Protocol) Example
================================================

Navigate to **Network → E-BGP**. Here, aside from the required system generated IPv4/IPv6 E-BGP peer connections between the two border routers ( **SoftGate1** & **SoftGate2** ) and the rest of the switching fabric (which can be toggled on/off using the **Show System Generated** toggle at the top of the page), you will also find two E-BGP sessions named "**iris-isp1-ipv4-example**" and "**iris-isp1-ipv6-example**" configured as examples with **IRIS ISP1**. This ensures communication between the internal network and the Internet.

You may examine the particular session configurations of the E-BGP connections by selecting **Edit** from the **Actions** menu indicated by three vertical dots (**⋮**) on the right side of either the "**iris-isp1-ipv4-example**" and "**iris-isp1-ipv6-example**" connections. You may also expand the **Advanced** section located toward the bottom of the **Edit** window to be able to access the more advanced settings available while configuring an E-BGP session.

If you are interested in learning how to create an additional E-BGP session with **IRIS ISP2** in order to make the Sandbox upstream connections fault tolerant yourself, please refer to the step-by-step instructions found in the :ref:`"E-BGP (Exterior Border Gateway Protocol)"<s4-e-bgp>` section of the :ref:`"Learn by Creating Services"<s4-learn-by-doing>` document.

More details about E-BGP (Exterior Border Gateway Protocol) can be found on the the :ref:`"BGP"<bgp_def>` page.

NAT (Network Address Translation) Example
=========================================
Navigate to **Network → NAT** and you will find a NAT rule named "**NAT Example**" configured as an example for you. The configured "**SNAT**" rule ensures that there can be communication between the the private "**192.168.45.0/24 (EXAMPLE)**" subnet and the Internet.

You can examine the particular settings of the NAT rule by clicking **Edit** from the **Actions** menu indicated by three vertical dots (**⋮**) on the right side of the "**NAT Example**" service.

You may also observe the functioning NAT rule in action by pinging any public IP address (e.g. **1.1.1.1**)  from the **srv04-nyc** server.

* In a terminal window:

  1. SSH to server **srv04-nyc**: ``ssh demo@216.172.128.204 -p 30064``.
  2. Enter the password provided in the introductory e-mail.
  3. Start a ping session: ``ping4 1.1.1.1``

You will see replies in the form of "**64 bytes from 1.1.1.1: icmp_seq=1 ttl=62 time=1.10 ms**" indicating proper communication with the **1.1.1.1** public IP address.

If you are interested in learning how to create a NAT rule yourself, please refer to the step-by-step instructions found in the :ref:`"NAT (Network Address Translation)"<s4-nat>` section of the :ref:`"Learn by Creating Services"<s4-learn-by-doing>` document.

More details about NAT (Network Address Translation) can be found on the :ref:`"NAT"<nat_def>` page.

ACL (Access Control List) Example
=================================
Navigate to **Services → ACL** and you will find an ACL services named "**V-Net Example to WAN**" set up as an example for you. This particular ACL ensures that the connectivity between the the private "**192.168.45.0/24 (EXAMPLE)**" subnet and the Internet is permitted through all protocols and ports, even in a scenario where the the "**ACL Default Policy**" for the "**US/NYC**" site configured under **Network → Sites** in our Sandbox is changed from **Permit** to **Deny**.

You can examine the particular settings of this ACL policy by selecting **Edit** from the **Actions** menu indicated by three vertical dots (**⋮**) on the right side of the "**V-Net Example to WAN**" ACL policy.

By utilizing ACLs, you can impose granular controls and implement policies that would permit or deny particular connections of any complexity. If you are interested in learning how to create ACL policies yourself, please refer to the step-by-step instructions found in the :ref:`"ACL (Access Control List)"<s4-acl>` section of the :ref:`"Learn by Creating Services"<s4-learn-by-doing>` document.

More details about ACL (Access Control List) can be found on the :ref:`"ACL"<acl_def>` page.
