..
  #################
  Sandbox Variables
  #################
  ------------------------------------------------------------------------------------------------
  values                     | description
  ------------------------------------------------------------------------------------------------ 
  Sandbox5                   # Sandbox name Uppercase(case sensitive)
  sandbox5                   # Sandbox name Lowercase
  166.88.17.187              # Hypervisor PUBLIC IP
  10.254.45.0/24             # *STATIC NO NEED TO REPLACE* MANAGEMENT Allocation/Subnet
  10.254.46.0/24             # *STATIC NO NEED TO REPLACE* LOOPBACK Allocation/Subnet
  192.168.44.0/24            # *STATIC NO NEED TO REPLACE* ROH Allocation/Subnet
  192.168.45.64              # *STATIC NO NEED TO REPLACE* srv04 IP Address
  192.168.45.1               # *STATIC NO NEED TO REPLACE* vnet-example IP4v GW
  192.168.46.65              # *STATIC NO NEED TO REPLACE* srv05 IP Address
  192.168.46.1               # *STATIC NO NEED TO REPLACE* vnet-customer IPv4 GW
  192.168.110.0/24           # *STATIC NO NEED TO REPLACE* k8s subnet
  65007                      # *STATIC NO NEED TO REPLACE* Iris AS number bgp peer
  1051                       # Iris 1st peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  1052                       # Iris 2nd peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  50.117.59.128/28           # PUBLIC IPv4 Allocation
  50.117.59.128/30           # PUBLIC LOOPBACK subnet
  50.117.59.129              # PUBLIC Loopback IPv4 of SoftGate2
  50.117.59.132/30           # PUBLIC IPv4 NAT Subnet
  50.117.59.132/32           # CUSTOMER V-NET SNAT IP
  50.117.59.136/30           # L3LB Subnet 
  50.117.59.136/32           # L3LB IP
  50.117.59.140/30           # L4LB Subnet
  50.117.59.141              # Second usable ip address in load-balancer subnet
  50.117.59.142              # Third usable ip address in load-balancer subnet
  50.117.59.82/30            # isp1-ipv4-example BGP peer local IPv4
  50.117.59.81/30            # isp1-ipv4-example BGP peer remote IPv4
  50.117.59.86/30            # isp2-ipv4-customer BGP peer local IPv4
  50.117.59.85/30            # isp2-ipv4-customer BGP peer remote IPv4
  2607:f358:11:ffc5::/64     # public IPv6 subnet
  2607:f358:11:ffc5::1       # vnet-example IP6v gateway
  2607:f358:11:ffc0::b/127   # isp1-ipv6-example BGP peer local IPv6
  2607:f358:11:ffc0::a/127   # isp1-ipv6-example BGP peer remote IPv6
  s5-pre-configured          # LINK
  s5-learn-by-doing          # LINK
  s5-e-bgp                   # LINK
  s5-v-net                   # LINK
  s5-nat                     # LINK 
  s5-acl                     # LINK
  s5-l3lb                    # LINK 
  s5-k8s                     # LINK
  s5-topology                # LINK

Sandbox5
=========
**Contents**: 

.. toctree::
   :maxdepth: 2

   sandbox-info
   configurations
   creating-services
   onprem-k8s
