.. _s5-learn-by-doing:

**************************
Learn by Creating Services
**************************

Following these short exercises we will be able to demonstrate how the :ref:`Netris Controller<netris_controller_def>`, in conjunction with the :ref:`Netris Agents<netris_sw_agent>` deployed on the switches and SoftGates, is able to intelligently and automagically deploy the necessary configurations across the network fabric to provision desired services within a matter of minutes.


.. _s5-v-net:

V-Net (Ethernet/Vlan/VXlan)
===========================
Let's create a V-Net service to give the **srv05-nyc** server the ability to reach its gateway address.

* In a terminal window:

  1. SSH to server **srv05-nyc**: ``ssh demo@166.88.17.187 -p 30065``.
  2. Enter the password provided in the introductory e-mail.
  3. Type ``ip route ls`` and we can see **192.168.46.1** is configured as the default gateway, indicated by the "**default via 192.168.46.1 dev eth1 proto kernel onlink**" line in the output.
  4. Start a ping session towards the default gateway: ``ping 192.168.46.1`` 
  5. Keep the ping running as an indicator for when the service becomes fully provisioned.
  6. Until the service is provisioned, we can see that the destination is not reachable judging by the outputs in the form of "**From 192.168.46.64 icmp_seq=1 Destination Host Unreachable**".

* In a web browser: (*\*Fields not specified should remain unchanged and retain default values*)

  1. Log into the Netris Controller by visiting `https://sandbox5.netris.ai <https://sandbox5.netris.ai>`_ and navigate to **Services → V-Net**.
  2. Click the **+ Add** button in the top right corner of the page to get started with creating a new V-Net service.
  3. Define a name in the **Name** field (e.g. ``vnet-customer``).
  4. From the **Owner** drop-down menu, select "**Demo**".
  5. From the **Sites** drop-down menu, select "**US/NYC**".
  6. From the **IPv4 Gateway** drop-down menu, select the "**192.168.46.0/24(CUSTOMER)**" subnet.
  7. The first available IP address "**192.168.46.1**" is automatically selected in the second drop-down menu of the list of IP addresses. This matches the results of the ``ip route ls`` command output on **srv05-nyc** we observed earlier.
  8. From the **Add Port** drop-down menu put a check mark next to switch port "**swp2(swp2 | srv05-nyc)@sw22-nyc (Demo)**", which we can see is the the port where **srv05-nyc** is wired into when we reference the :ref:`"Sandbox Topology diagram"<s11-topology>`.

    *  The drop-down menu only contains this single switch port as it is the only port that has been assigned to the **Demo** tenant.

  9. Check the **Untag** check-box and click the **Add** button.
  10. Click the **Add** button at the bottom right of the "**Add new V-Net**" window and the service will start provisioning.

After just a few seconds, once fully provisioned, you will start seeing successful ping replies, similar in form to "**64 bytes from 192.168.46.1: icmp_seq=55 ttl=64 time=1.66 ms**", to the ping that was previously started in the terminal window, indicating that now the gateway address is reachable from host **srv05-nyc**.

More details about V-Net (Ethernet/Vlan/VXlan) can be found on the the :ref:`"V-NET"<v-net_def>` page.

.. _s5-e-bgp:

E-BGP (Exterior Border Gateway Protocol)
========================================
Our internal network is already connected with the outside world so that our servers can communicate with the Internet through the E-BGP session with IRIS ISP1 named "**iris-isp1-example**".

Optionally you can configure an E-BGP session to IRIS ISP2 for fault tolerance.

* In a web browser: (*\*Fields not specified should remain unchanged and retain default values*)

  1. Log into the Netris Controller by visiting `https://sandbox5.netris.ai <https://sandbox5.netris.ai>`_ and navigate to **Net → E-BGP**.
  2. Click the **+ Add** button in the top right corner of the page to configure a new E-BGP session.
  3. Define a name in the **Name** field (e.g. ``iris-isp2-ipv4-customer``).
  4. From the **Site** drop-down menu, select "**US/NYC**".
  5. From the **BGP Router** drop-down menu, select "**SoftGate2**".
  6. From the **Switch Port** drop-down menu, select port "**swp16(swp16 | ISP2)@sw02-nyc (Admin)**" on the switch that is connected to the ISP2.

    * For the purposes of this exercise, the required switch port can easily be found by typing ``ISP2`` in the Search field.

  7. For the **VLAN ID** field, uncheck the **Untag** check-box and type in ``1052``.
  8. In the **Neighbor AS** field, type in ``65007``.
  9. In the **Local IP** field, type in ``50.117.59.126``.
  10. In the **Remote IP** field, type in ``50.117.59.125``.
  11. Expand the **Advanced** section
  12. In the **Prefix List Inbound** field, type in ``permit 0.0.0.0/0`` 
  13. In the **Prefix List Outbound** field, type in ``permit 50.117.59.128/28 le 32``
  14. And finally click **Add**

Allow up to 1 minute for both sides of the BGP sessions to come up and then the BGP state on **Net → E-BGP** page as well as on **Telescope → Dashboard** pages will turn green, indication a successfully established BGP session. We can glean further insight into the BGP session details by navigating to **Net → Looking Glass**.

  1. Select "**SoftGate2(50.117.59.129)**" (the border router where our newly created BGP session is terminated on) from the **Select device** drop-down menu.
  2. Leaving the **Family** drop-down menu on IPv4 and the **Command** drop-down menu on "**BGP Summary**", click on the **Submit** button.

We are presented with the summary of the BGP sessions terminated on **SoftGate2**. You can also click on each BGP neighbor name to further see the "**Advertised routes**" and "**Routes**" received to/from that BGP neighbor.

More details about E-BGP (Exterior Border Gateway Protocol) can be found on the the :ref:`"BGP"<bgp_def>` page.

.. _s5-nat:

NAT (Network Address Translation)
=================================
Now that we have both internal and external facing services, we can aim for our **srv05-nyc** server to be able to communicate with the Internet.

* In a terminal window:

  1. SSH to server **srv05-nyc**: ``ssh demo@166.88.17.187 -p 30065``.
  2. Enter the password provided in the introductory e-mail.
  3. Start a ping session towards any public IP address (e.g. ``ping 1.1.1.1``).
  4. Keep the ping running as an indicator for when the service starts to work.

Let's configure a source NAT so our Customer subnet **192.168.46.0/24**, which is used in the V-Net services called **vnet-customer**, can communicate with the Internet.

* In a web browser: (*\*Fields not specified should remain unchanged and retain default values*)

  1. Log into the Netris Controller by visiting `https://sandbox5.netris.ai <https://sandbox5.netris.ai>`_ and navigate to **Net → NAT**.
  2. Click the **+ Add** button in the top right corner of the page to define a new NAT rule.
  3. Define a name in the **Name** field (e.g. ``NAT Customer``).
  4. From the **Site** drop-down menu, select "**US/NYC**".
  5. From the **Action** drop-down menu, select "**SNAT**".
  6. From the **Protocol** drop-down menu, select "**ALL**".
  7. In the **Source Address** field, type in ``192.168.46.0/24``.
  8. In the **Destination Address** field, type in ``0.0.0.0/0``.
  9. Toggle the switch from **SNAT to Pool** to **SNAT to IP**.
  10. From the **Select subnet** drop-down menu, select the "**50.117.59.132/30 (NAT)**" subnet. 
  11. From the **Select IP** drop-down menu, select the "**50.117.59.132/32**" IP address.

    * This public IP is part of **50.117.59.132/30 (NAT)** subnet which is configured in the **NET → IPAM** section with the purpose of **NAT** and indicated in the SoftGate configurations to be used as a global IP for NAT by the :ref:`"Netris SoftGate Agent"<netris_sg_agent>`..

  12. Click **Add**

Soon you will start seeing replies similar in form to "**64 bytes from 1.1.1.1: icmp_seq=1 ttl=62 time=1.23 ms**" to the ping previously started in the terminal window, indicating that now the Internet is reachable from **srv05-nyc**.

More details about NAT (Network Address Translation) can be found on the :ref:`"NAT"<nat_def>` page.

.. _s5-acl:

ACL (Access Control List)
=========================
Now that **srv05-nyc** can communicate with both internal and external hosts, let's check Access Policy and Control options.

* In a terminal window:

  1. SSH to server **srv05-nyc**: ``ssh demo@166.88.17.187 -p 30065``.
  2. Enter the password provided in the introductory e-mail.
  3. Start a ping session: ``ping 1.1.1.1``.
  4. If the previous steps were followed, you should see successful ping replies in the form of "**64 bytes from 1.1.1.1: icmp_seq=55 ttl=62 time=1.23 ms**".
  5. Keep the ping running as an indicator for when the service starts to work.

* In a web browser: (*\*Fields not specified should remain unchanged and retain default values*)

  1. Log into the Netris Controller by visiting `https://sandbox5.netris.ai <https://sandbox5.netris.ai>`_ and navigate to **Net → Sites**.
  2. Click **Edit** from the **Actions** menu indicated by three vertical dots (**⋮**) on the right side of the **UC/NYC** site.
  3. From the **ACL Default Policy** drop-down menu, change the value from "**Permit**" to "**Deny**".
  4. Click **Save**.

Soon you will notice that there are no new replies to our previously started ``ping 1.1.1.1`` command in the terminal window, indicating that the **1.1.1.1** IP address is no longer reachable.Now that the **Default ACL Policy** is set to **Deny**, we need to configure an **ACL** entry that will allow the **srv05-nyc** server to communicate with the Internet.

* Back in the web browser: (*\*Fields not specified should remain unchanged and retain default values*)

  1. Navigate to **Services → ACL**.
  2. Click the **+ Add** button in the top right corner of the page to define a new ACL.
  3. Define a name in the **Name** field (e.g. ``V-Net Customer to WAN``).
  4. From the **Protocol** drop-down menu, select "**ALL**".
  5. In the Source field, type in ``192.168.46.0/24``.
  6. In the Destination field, type in ``0.0.0.0/0``.
  7. Click **Add**.
  8. Select **Approve** from the **Actions** menu indicated by three vertical dots (**⋮**) on the right side of the newly created "**V-Net Customer to WAN**" ACL.
  9. Click **Approve** one more time in the pop-up window.

Once the Netris software has finished syncing the new ACL policy with all the member devices, we can see in the terminal window that replies to our ``ping 1.1.1.1`` command have resumed, indicating that the **srv05-nyc** server can communicate with the Internet once again..

More details about ACL (Access Control List) can be found on the :ref:`"ACL"<acl_def>` page.

.. _s5-l3lb:

L3LB (Anycast L3 load balancer)
===============================
In this exercise we will quickly configure an Anycast IP address in the Netris Controller for two of our :ref:`"ROH (Routing on the Host)"<roh_def>` servers (**srv01-nyc** & **srv02-nyc**) which both have a running Web Server configured to display a simple HTML webpage and observe **ECMP** load balancing it in action.

* In a web browser: (*\*Fields not specified should remain unchanged and retain default values*)

  1. Log into the Netris Controller by visiting `https://sandbox5.netris.ai <https://sandbox5.netris.ai>`_ and navigate to **Services → Instances(ROH)**.
  2. Click **Edit** from the **Actions** menu indicated by three vertical dots (**⋮**) on the right side of the "**srv01-nyc**" server.
  3. From the **IPv4** drop-down menu, select the "**50.117.59.136/30 (L3 LOAD BALANCER)**" subnet.
  4. From the second drop-down menu that appears to the right, select the first available IP "**50.117.59.216**".
  5. Check the **Anycast** check-box next to the previously selected IP and click the **Save** button. 
  6. Repeat steps **3** through **4** for "**srv02-nyc**" by first clicking **Edit** from the **Actions** menu indicated by three vertical dots (**⋮**) on the right side of the "**srv02-nyc**" server.

    * While editing "**srv02-nyc**", after selecting the "**50.117.59.216**" IP address , the **Anycast** check-box will already be automatically checked as we had designated the IP address as such in step **5**.

* In a new web browser window/tab:

  1. Type in the Anycast IP address we just configured (**50.117.59.216**) into the browser's address bar or simply visit `http://50.117.59.216/ <http://50.117.59.216/>`_.
  2. Based on the unique hash calculated from factors such as source IP/Protocol/Port, the **L3LB** will use **ECMP** to load balance the traffic from your browser to either **srv01-nyc** or **srv02-nyc**, with the text on the website indicating where the traffic ended up.

    * It should be noted that the TCP session will continue to exist between the given end-user and server pair for the lifetime of the session. In our case we have landed on **srv01-nyc**.

.. image:: /images/l3lb_srv01.png
    :align: center

In order to trigger the L3 load balancer to switch directing the traffic towards the other backend server (in this case from **srv01-nyc** to **srv02-nyc**, which based on the unique hash in your situation could be the other way around), we can simulate the unavailability of backend server we ended up on by putting it in **Maintenance** mode.

* Back in the Netris Controller, navigate to **Services → Load Balancer**.

  1. Expand the **LB Vip** that was created when we defined the **Anycast** IP address earlier by clicking on the **>** to the left of "**50.117.59.216 (name_50.117.59.216)**".
  2. Click **Action v** to the right of the server you originally ended up on (in this case **srv01-nyc**).
  3. Click **Maintenance on**.
  4. Click **Maintenance** one more time in the pop-up window.

* Back in the browser window/tab directed at the **50.117.59.216** Anycast IP address.

  1. After just a few seconds, we can observe that now the website indicates that the traffic is routed to **srv02-nyc** (once more, your case could be opposite for you based on the original hash).

.. image:: /images/l3lb_srv02.png
    :align: center

More details about AL3LB (Anycast L3 load balancer) can be found on the :ref:`"L3 Load Balancer (Anycast LB)"<l3lb_def>` page.