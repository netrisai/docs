**************************
Learn by Creating Services
**************************
V-Net (Ethernet/Vlan/VXlan)
===========================
Let's create a V-Net service to give the **srv04-nyc** server the ability to reach its gateway address.

* In a terminal window:

  1. SSH to the **srv04-nyc** server by typing ``ssh demo@212.5.48.109 -p 22264``.
  2. Enter the password provided in the introductory e-mail.
  3. Type ``ip route ls`` and we can see ``192.168.28.1`` is configured as the default gateway, indicated by the "**default via 192.168.28.1 dev eth2 proto kernel onlink**" line in the output.
  4. Start a ping session towards the default gateway by typing ``ping 192.168.28.1`` and keep it running as an indicator for when the service becomes fully provisioned.
  5. Until the service is provisioned, the received responses will indicate that the destination is not reachable in the form of "**From 192.168.28.64 icmp_seq=1 Destination Host Unreachable**"

* In a web browser: (*\*Fields not specified should remain unchanged and retain default values*)

  1. Log into the Netris GUI by visiting **https://demo32.netris.ai** and navigate to **Services > V-Net**.
  2. Click **+Add** to create a new V-Net service.
  3. Define a name in the **Name** field (e.g. ``V-Net Customer``).
  4. From the **Sites** drop-down menu, select **US/NYC**.
  5. Click **+IPv4 Gateway**, select subnet ``192.168.28.0/24(CUSTOMER)`` and IP ``192.168.28.1`` to match the results of the ``ip route ls`` output on **srv04-nyc**.
  6. Click **+Port** to define the port(s) to be included in the current V-Net service.
   
  * For the purposes of this exercise, you can find the required port by typing "``srv04``" in the Search field.
  
  7. Select the port named **swp2(sw21-nyc-swp2 (srv04))@sw21-nyc (Admin)**, check the **Untag** check-box and click **Add**.
  8. Click **Add** and the service will start provisioning.
  
Once fully provisioned, you will start seeing replies similar in form to "**64 bytes from 192.168.28.1: icmp_seq=1 ttl=64 time=1.66 ms**" to the ping previously started in the terminal window, indicating that now the gateway address is reachable.

E-BGP (Exterior Border Gateway Protocol)
========================================
Our internal network is already connected with the outside world so that our servers can communicate with the Internet through the E-BGP session with "**ISP1**".

Optionally you can configure an E-BGP session to ISP 2 for fault tolerance.

* In a web browser: (*\*Fields not specified should remain unchanged and retain default values*)

  1. Log into the Netris GUI by visiting **https://demo32.netris.ai** and navigate to **Net > E-BGP**.
  2. Click **+Add** to configure a new E-BGP session.
  3. Define a name in the **Name** field (e.g. ``ISP2 Customer``).
  4. From the **Sites** drop-down menu, select **US/NYC**.
  5. From the **NFV Node** drop-down menu, select **NFV2**.
  6. In the **Neighbor AS** field, type in ``200``.
  7. In the **Switch port** field, define the port on the switch that is connected to the ISP2.

  * For the purposes of this exercise, you can find the required port by typing "``ISP2``" in the Search field.

  8. In the **Local IP** field, type in ``10.20.10.10``
  9. In the **Remote IP** field, type in ``10.20.10.9``.
  10. Expand the **Advanced** section
  11. In the **Prefix List Outbound** field, type in ``permit 7.7.7.0/24``
  12. And finally click **Add**
  
Allow up to 1 minute for both sides of the BGP sessions to come up and then the BGP state on **Net > E-BGP** page as well as on **Telescope > Dashboard** pages will turn green, indication a successfully established BGP session. 

NAT (Network Address Translation)
=================================
Now when we have both internal and external facing services, we can aim for our **srv04-nyc** server to be able to communicate with **8.8.8.8**.

* In a terminal window:

  1. SSH to srv04-nyc by typing ``ssh demo@212.5.48.109 -p 22264``.
  2. Enter the password provided in the introductory e-mail.
  3. Start a ping session by typing ``ping 8.8.8.8`` and keep it running as an indicator for when the service starts to work.
  
Let's configure a source NAT so our V-Net subnet **192.168.28.0/24** can communicate with public IP **8.8.8.8**.

* In a web browser: (*\*Fields not specified should remain unchanged and retain default values*)

  1. Log into the Netris GUI by visiting **https://demo32.netris.ai** and navigate to **Net > NAT**.
  2. Click **+Add** to define a new NAT.
  3. Define a name in the **Name** field (e.g. ``NAT Customer``).
  4. From the **Action** drop-down menu, select **SNAT**.
  5. From the **Protocol** drop-down menu, select **ALL**.
  6. In the **Source** field, type in ``192.168.28.0/24``.
  7. The **Destination** field can remain as ``0.0.0.0/0``.
  8. From the **Nat IP** drop-down menu, select **7.7.7.8/32(US/NYC)**.
  
  * This IP is from our sandbox address space and is indicated in the NFV configuration to be used as a global IP for NAT.
    
  9. Click **Add**

Soon you will start seeing replies similar in form to "**64 bytes from 8.8.8.8: icmp_seq=1 ttl=62 time=1.23 ms**" to the ping previously started in the terminal window, indicating that now the **8.8.8.8** address is reachable.

ACL (Access Control List)
=========================
Now that **srv02-nyc** can communicate with both internal and external hosts, let's check Access Policy and Control options.

* In a terminal window:

  1. SSH to **srv04-nyc** by typing ``ssh demo@212.5.48.109 -p 22264``.
  2. Enter the password provided in the introductory e-mail.
  3. Start a ping session by typing ``ping 8.8.8.8`` and keep it running for the duration of this exercise.
  
* In a web browser: (*\*Fields not specified should remain unchanged and retain default values*)

  1. Log into the Netris GUI by visiting **https://demo32.netris.ai** and navigate to **Net > Sites**.
  2. Select **Edit** from the **Actions** menu indicated by three vertical dots (⋮) on the right side of the **UC/NYC** site.
  3. From the **ACL Default Policy** drop-down menu, change the value from **Permit** to **Deny**.
  4. Click **Save**.

* Back in the terminal window:

Soon you will notice that there are no new replies to our previously started ``ping 8.8.8.8`` command, indicating that the **8.8.8.8** IP address is no longer reachable.

Now that the **Default ACL Policy** is set to **Deny**, we need to configure an **ACL** entry that will allow the **srv02-nyc** server to communicate with **8.8.8.8**.

* Back in the web browser: (*\*Fields not specified should remain unchanged and retain default values*)

  1. Navigate to **Services > ACL**
  2. Click **+Add** to define a new ACL
  3. Define a name in the **Name** field (e.g. ``V-Net to WAN Customer``).
  4. From the **Protocol** drop-down menu, select **ALL**.
  5. In the Source field, type in ``192.168.28.0/24``.
  6. In the Destination field, type in ``8.8.8.8/32``.
  7. Click **Add**.
  8. Select **Approve** from the **Actions** menu indicated by three vertical dots (⋮) on the right side of the newly created "**V-Net to WAN Example**" ACL.
  9. Click **Approve** one more time in the pop-up window.

|
* Back in the terminal window again:

Once the Netris software has finished syncing the new ACL policy with all the member devices, you can see that replies to our ``ping 8.8.8.8`` command have resumed, indicating that the **srv02-nyc** server can communicate with **8.8.8.8** once again.
