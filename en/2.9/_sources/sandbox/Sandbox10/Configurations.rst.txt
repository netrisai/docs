********************************
Provided Example Configurations
********************************
Once you log into the Netris GUI, you will find that certain services have already been pre-configured for you to explore and interact with. You can also learn how to create some of these services yourself by following the `step-by-step instructions <http://creating_services/>`

V-Net (Ethernet/Vlan/VXlan) Example
===================================
Once you log into the Netris GUI by visiting **https://sandbox10.netris.ai** and navigating to **Services > V-Net**, you will find a V-Net service named "**V-Net Example**" already configured for you as an example. You can examine the particular service settings by selecting **Edit** from the **Actions** menu indicated by three vertical dots (⋮) on the right side of the "**V-Net Example**" service.

You may also verify that the service is working properly from within the GUI: (*\*Fields not specified should remain unchanged and retain default values*)

1. Navigate to **Net > Looking Glass**.
2. Select the **sw01-nyc(10.254.46.1)** switch from the **Select switch** drop-down menu.
3. Select the **Ping** radio button from the row of available choices.
4. Type in ``192.168.45.64`` in the field labeled "**IPv4 address**".
5. Click **Submit**.

The result should look similar to the output below, indicating that the communication between the **sw01-nyc** switch and **srv04-nyc** server is working properly thanks to the configured V-Net service.

.. code-block:: shell-session

  sw01-nyc# ping -c 5 192.168.45.64
  PING 192.168.45.64 (192.168.45.64) 56(84) bytes of data.
  64 bytes from 192.168.45.64: icmp_seq=1 ttl=64 time=33.4 ms
  64 bytes from 192.168.45.64: icmp_seq=2 ttl=64 time=27.1 ms
  64 bytes from 192.168.45.64: icmp_seq=3 ttl=64 time=0.702 ms
  64 bytes from 192.168.45.64: icmp_seq=4 ttl=64 time=1.37 ms
  64 bytes from 192.168.45.64: icmp_seq=5 ttl=64 time=0.609 ms
  --- 192.168.45.64 ping statistics ---
  5 packets transmitted, 5 received, 0% packet loss, time 4008ms
  rtt min/avg/max/mdev = 0.609/12.660/33.422/14.545 ms

If you are interested in learning how to create a V-Net service yourself, please refer to the step-by-step instructions in the "**V-Net (Ethernet/Vlan/VXlan)**" section below.

E-BGP (Exterior Border Gateway Protocol) Example
================================================

Navigate to **Net > E-BGP**. Here, aside from the system generated IPv4/IPv6 E-BGP peer connections between the two border routers ( **SoftGate1 & SoftGate2** ) and their respective adjacent spine switches ( **sw01-nyc & sw02-nyc** ), you will also find an E-BGP session named "**ISP1 Example**" configured as example with ISP1. This ensures communication of the inside network with the Internet. You can examine the particular session settings of the E-BGP connection by selecting Edit from the Actions menu indicated by three vertical dots (⋮) on the right side of the "**ISP1 Example**" connection. While viewing the settings, you may also expand the **Advanced** section located toward the bottom of the initial screen to able to see the more advanced settings available while configuring an E-BGP session.

If you are interested in learning how to create a fault tolerant E-BGP session with ISP2 yourself, please refer to the step-by-step instructions in the "**E-BGP (Exterior Border Gateway Protocol)**" section below.

NAT (Network Address Translation) Example
=========================================
Navigate to **Net > NAT** and you will find a NAT service named "**NAT Example**" configured as an example . The configured services ensures that there can be communication between the the private **192.168.45.0/24** network with the public **1.1.1.1** IP address. You can examine the particular settings of the NAT service by clicking **Edit** from the Actions menu indicated by three vertical dots on the right side of the "**NAT Example**" service.

You may observe the functioning service by pinging the pubblic **1.1.1.1** IP address from the **srv04-nyc** server.

* In a terminal window:

  1. SSH to srv04-nyc by typing ``ssh demo@166.88.17.22 -p 23064``.
  2. Enter the password provided in the introductory e-mail.
  3. Start a ping session by typing ``ping 1.1.1.1``

You will see replies in the form of "**64 bytes from 1.1.1.1: icmp_seq=1 ttl=62 time=1.10 ms**" indicating proper communication with the public **1.1.1.1** IP address.

If you are interested in learning how to create a NAT services yourself, please refer to the step-by-step instructions in the "**NAT (Network Address Translation)**" section below.

ACL (Access Control List) Example
=================================
Navigate to **Services > ACL** and you will find an ACL services named "**V-Net to WAN Example**" set up as an example. This particular ACL ensures that the connectivity between the the private **192.168.45.0/24** network with the public **1.1.1.1** IP address is permitted through all protocols and ports, even in a scenario where the the **Default Site Policy** for the "**US/NYC**" site configured in the our Sandbox is changed from **Permit** to **Deny**. You can examine the particular settings of this ACL policy by selecting **Edit** from the **Actions** menu indicated by three vertical dots (⋮) on the right side of the "**V-Net to WAN Example**" ACL policy.

By utilizing ACLs, you can impose granular controls and implement policies that would allow or disallow particular connections. If you are interested in learning how to create a ACL policies yourself, please refer to the step-by-step instructions in the "**ACL (Access Control List)**" section below.
