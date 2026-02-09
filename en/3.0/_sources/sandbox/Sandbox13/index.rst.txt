..
  #################
  Sandbox Variables
  #################
  ------------------------------------------------------------------------------------------------
  values                     | description
  ------------------------------------------------------------------------------------------------ 
  Sandbox13                  # Sandbox name Uppercase(case sensitive)
  sandbox13                  # Sandbox name Lowercase
  50.117.27.84               # Hypervisor PUBLIC IP
  10.254.45.0/24             # *STATIC NO NEED TO REPLACE* MANAGEMENT Allocation/Subnet
  10.254.46.0/24             # *STATIC NO NEED TO REPLACE* LOOPBACK Allocation/Subnet
  192.168.44.0/24            # *STATIC NO NEED TO REPLACE* ROH Allocation/Subnet
  192.168.45.64              # *STATIC NO NEED TO REPLACE* srv04 IP Address
  192.168.45.1               # *STATIC NO NEED TO REPLACE* vnet-example IP4v GW
  192.168.46.65              # *STATIC NO NEED TO REPLACE* srv05 IP Address
  192.168.46.1               # *STATIC NO NEED TO REPLACE* vnet-customer IPv4 GW
  192.168.110.0/24           # *STATIC NO NEED TO REPLACE* k8s subnet
  65007                      # *STATIC NO NEED TO REPLACE* Iris AS number bgp peer
  1131                       # Iris 1st peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  1132                       # Iris 2nd peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  45.38.161.144/28           # PUBLIC IPv4 Allocation
  45.38.161.144/30           # PUBLIC LOOPBACK subnet
  45.38.161.145              # PUBLIC Loopback IPv4 of SoftGate2
  45.38.161.148/30           # PUBLIC IPv4 NAT Subnet
  45.38.161.148/32           # CUSTOMER V-NET SNAT IP
  45.38.161.152/30           # L3LB Subnet
  45.38.161.152/32           # L3LB IP
  45.38.161.156/30           # L4LB Subnet
  45.38.161.157              # Second usable ip address in load-balancer subnet
  45.38.161.158              # Third usable ip address in load-balancer subnet
  45.38.161.162/30           # isp1-ipv4-example BGP peer local IPv4
  45.38.161.161/30           # isp1-ipv4-example BGP peer remote IPv4
  45.38.161.166/30           # isp2-ipv4-customer BGP peer local IPv4
  45.38.161.165/30           # isp2-ipv4-customer BGP peer remote IPv4
  2607:f358:11:ffcd::/64     # public IPv6 subnet
  2607:f358:11:ffcd::1       # vnet-example IP6v gateway
  2607:f358:11:ffc0::1b/127  # isp1-ipv6-example BGP peer local IPv6
  2607:f358:11:ffc0::1a/127  # isp1-ipv6-example BGP peer remote IPv6
  s13-pre-configured         # LINK
  s13-learn-by-doing         # LINK
  s13-e-bgp                  # LINK
  s13-v-net                  # LINK
  s13-nat                    # LINK 
  s13-acl                    # LINK
  s13-l3lb                   # LINK 
  s13-k8s                    # LINK
  s13-topology               # LINK

Sandbox13
=========
**Contents**: 

.. toctree::
   :maxdepth: 2

   sandbox-info
   configurations
   creating-services
   onprem-k8s
