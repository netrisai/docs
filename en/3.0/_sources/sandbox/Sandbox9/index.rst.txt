..
  #################
  Sandbox Variables
  #################
  ------------------------------------------------------------------------------------------------
  values                     | description
  ------------------------------------------------------------------------------------------------ 
  Sandbox9                   # Sandbox name Uppercase(case sensitive)
  sandbox9                   # Sandbox name Lowercase
  166.88.17.22               # Hypervisor PUBLIC IP
  10.254.45.0/24             # *STATIC NO NEED TO REPLACE* MANAGEMENT Allocation/Subnet
  10.254.46.0/24             # *STATIC NO NEED TO REPLACE* LOOPBACK Allocation/Subnet
  192.168.44.0/24            # *STATIC NO NEED TO REPLACE* ROH Allocation/Subnet
  192.168.45.64              # *STATIC NO NEED TO REPLACE* srv04 IP Address
  192.168.45.1               # *STATIC NO NEED TO REPLACE* vnet-example IP4v GW
  192.168.46.65              # *STATIC NO NEED TO REPLACE* srv05 IP Address
  192.168.46.1               # *STATIC NO NEED TO REPLACE* vnet-customer IPv4 GW
  192.168.110.0/24           # *STATIC NO NEED TO REPLACE* k8s subnet
  65007                      # *STATIC NO NEED TO REPLACE* Iris AS number bgp peer
  1091                       # Iris 1st peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  1092                       # Iris 2nd peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  50.117.59.192/28           # PUBLIC IPv4 Allocation
  50.117.59.192/30           # PUBLIC LOOPBACK subnet
  50.117.59.193              # PUBLIC Loopback IPv4 of SoftGate2
  50.117.59.196/30           # PUBLIC IPv4 NAT Subnet
  50.117.59.196/32           # CUSTOMER V-NET SNAT IP
  50.117.59.200/30           # L3LB Subnet 
  50.117.59.200/32           # L3LB IP
  50.117.59.204/30           # L4LB Subnet
  50.117.59.205              # Second usable ip address in load-balancer subnet
  50.117.59.206              # Third usable ip address in load-balancer subnet
  50.117.59.114/30           # isp1-ipv4-example BGP peer local IPv4
  50.117.59.113/30           # isp1-ipv4-example BGP peer remote IPv4
  50.117.59.118/30           # isp2-ipv4-customer BGP peer local IPv4
  50.117.59.117/30           # isp2-ipv4-customer BGP peer remote IPv4
  2607:f358:11:ffc9::/64     # public IPv6 subnet
  2607:f358:11:ffc9::1       # vnet-example IP6v gateway
  2607:f358:11:ffc0::13/127  # isp1-ipv6-example BGP peer local IPv6
  2607:f358:11:ffc0::12/127  # isp1-ipv6-example BGP peer remote IPv6
  s9-pre-configured          # LINK
  s9-learn-by-doing          # LINK
  s9-e-bgp                   # LINK
  s9-v-net                   # LINK
  s9-nat                     # LINK 
  s9-acl                     # LINK
  s9-l3lb                    # LINK 
  s9-k8s                     # LINK
  s9-topology                # LINK

Sandbox9
=========
**Contents**: 

.. toctree::
   :maxdepth: 2

   sandbox-info
   configurations
   creating-services
   onprem-k8s
