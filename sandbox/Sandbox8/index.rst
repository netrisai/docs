..
  #################
  Sandbox Variables
  #################
  ------------------------------------------------------------------------------------------------
  values                     | description
  ------------------------------------------------------------------------------------------------ 
  Sandbox8                   # Sandbox name Uppercase(case sensitive)
  sandbox8                   # Sandbox name Lowercase
  166.88.17.29               # Hypervisor PUBLIC IP
  10.254.45.0/24             # *STATIC NO NEED TO REPLACE* MANAGEMENT Allocation/Subnet
  10.254.46.0/24             # *STATIC NO NEED TO REPLACE* LOOPBACK Allocation/Subnet
  192.168.44.0/24            # *STATIC NO NEED TO REPLACE* ROH Allocation/Subnet
  192.168.45.64              # *STATIC NO NEED TO REPLACE* srv04 IP Address
  192.168.45.1               # *STATIC NO NEED TO REPLACE* vnet-example IP4v GW
  192.168.46.65              # *STATIC NO NEED TO REPLACE* srv05 IP Address
  192.168.46.1               # *STATIC NO NEED TO REPLACE* vnet-customer IPv4 GW
  192.168.110.0/24           # *STATIC NO NEED TO REPLACE* k8s subnet
  65007                      # *STATIC NO NEED TO REPLACE* Iris AS number bgp peer
  1081                       # Iris 1st peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  1082                       # Iris 2nd peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  50.117.59.176/28           # PUBLIC IPv4 Allocation
  50.117.59.176/30           # PUBLIC LOOPBACK subnet
  50.117.59.177              # PUBLIC Loopback IPv4 of SoftGate2
  50.117.59.180/30           # PUBLIC IPv4 NAT Subnet
  50.117.59.180/32           # CUSTOMER V-NET SNAT IP
  50.117.59.184/30           # L3LB Subnet 
  50.117.59.184/32           # L3LB IP
  50.117.59.188/30           # L4LB Subnet
  50.117.59.189              # Second usable ip address in load-balancer subnet
  50.117.59.190              # Third usable ip address in load-balancer subnet
  50.117.59.106/30           # isp1-ipv4-example BGP peer local IPv4
  50.117.59.105/30           # isp1-ipv4-example BGP peer remote IPv4
  50.117.59.110/30           # isp2-ipv4-customer BGP peer local IPv4
  50.117.59.109/30           # isp2-ipv4-customer BGP peer remote IPv4
  2607:f358:11:ffc8::/64     # public IPv6 subnet
  2607:f358:11:ffc8::1       # vnet-example IP6v gateway
  2607:f358:11:ffc0::11/127  # isp1-ipv6-example BGP peer local IPv6
  2607:f358:11:ffc0::10/127  # isp1-ipv6-example BGP peer remote IPv6
  s8-pre-configured          # LINK
  s8-learn-by-doing          # LINK
  s8-e-bgp                   # LINK
  s8-v-net                   # LINK
  s8-nat                     # LINK 
  s8-acl                     # LINK
  s8-l3lb                    # LINK 
  s8-k8s                     # LINK
  s8-topology                # LINK

Sandbox8
=========
**Contents**: 

.. toctree::
   :maxdepth: 2

   sandbox-info
   configurations
   creating-services
   onprem-k8s
