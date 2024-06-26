..
  #################
  Sandbox Variables
  #################
  ------------------------------------------------------------------------------------------------
  values                     | description
  ------------------------------------------------------------------------------------------------ 
  Sandbox7                   # Sandbox name Uppercase(case sensitive)
  sandbox7                   # Sandbox name Lowercase
  216.172.128.207            # Hypervisor PUBLIC IP
  10.254.45.0/24             # *STATIC NO NEED TO REPLACE* MANAGEMENT Allocation/Subnet
  10.254.46.0/24             # *STATIC NO NEED TO REPLACE* LOOPBACK Allocation/Subnet
  192.168.44.0/24            # *STATIC NO NEED TO REPLACE* ROH Allocation/Subnet
  192.168.45.64              # *STATIC NO NEED TO REPLACE* srv04 IP Address
  192.168.45.1               # *STATIC NO NEED TO REPLACE* vnet-example IP4v GW
  192.168.46.65              # *STATIC NO NEED TO REPLACE* srv05 IP Address
  192.168.46.1               # *STATIC NO NEED TO REPLACE* vnet-customer IPv4 GW
  192.168.110.0/24           # *STATIC NO NEED TO REPLACE* k8s subnet
  65007                      # *STATIC NO NEED TO REPLACE* Iris AS number bgp peer
  1071                       # Iris 1st peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  1072                       # Iris 2nd peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  50.117.59.160/28           # PUBLIC IPv4 Allocation
  50.117.59.160/30           # PUBLIC LOOPBACK subnet
  50.117.59.161              # PUBLIC Loopback IPv4 of SoftGate2
  50.117.59.164/30           # PUBLIC IPv4 NAT Subnet
  50.117.59.164/32           # CUSTOMER V-NET SNAT IP
  50.117.59.168/30           # L3LB Subnet 
  50.117.59.168/32           # L3LB IP
  50.117.59.172/30           # L4LB Subnet
  50.117.59.173              # Second usable ip address in load-balancer subnet
  50.117.59.174              # Third usable ip address in load-balancer subnet
  50.117.59.98/30            # isp1-ipv4-example BGP peer local IPv4
  50.117.59.97/30            # isp1-ipv4-example BGP peer remote IPv4
  50.117.59.102/30           # isp2-ipv4-customer BGP peer local IPv4
  50.117.59.101/30           # isp2-ipv4-customer BGP peer remote IPv4
  2607:f358:11:ffc7::/64     # public IPv6 subnet
  2607:f358:11:ffc7::1       # vnet-example IP6v gateway
  2607:f358:11:ffc0::f/127   # isp1-ipv6-example BGP peer local IPv6
  2607:f358:11:ffc0::e/127   # isp1-ipv6-example BGP peer remote IPv6
  s7-pre-configured          # LINK
  s7-learn-by-doing          # LINK
  s7-e-bgp                   # LINK
  s7-v-net                   # LINK
  s7-nat                     # LINK 
  s7-acl                     # LINK
  s7-l3lb                    # LINK 
  s7-k8s                     # LINK
  s7-topology                # LINK

Sandbox7
=========
**Contents**: 

.. toctree::
   :maxdepth: 2

   sandbox-info
   configurations
   creating-services
   onprem-k8s
