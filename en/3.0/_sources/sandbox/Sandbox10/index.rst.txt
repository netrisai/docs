..
  #################
  Sandbox Variables
  #################
  ------------------------------------------------------------------------------------------------
  values                     | description
  ------------------------------------------------------------------------------------------------ 
  Sandbox10                  # Sandbox name Uppercase(case sensitive)
  sandbox10                  # Sandbox name Lowercase
  166.88.17.19               # Hypervisor PUBLIC IP
  10.254.45.0/24             # *STATIC NO NEED TO REPLACE* MANAGEMENT Allocation/Subnet
  10.254.46.0/24             # *STATIC NO NEED TO REPLACE* LOOPBACK Allocation/Subnet
  192.168.44.0/24            # *STATIC NO NEED TO REPLACE* ROH Allocation/Subnet
  192.168.45.64              # *STATIC NO NEED TO REPLACE* srv04 IP Address
  192.168.45.1               # *STATIC NO NEED TO REPLACE* vnet-example IP4v GW
  192.168.46.65              # *STATIC NO NEED TO REPLACE* srv05 IP Address
  192.168.46.1               # *STATIC NO NEED TO REPLACE* vnet-customer IPv4 GW
  192.168.110.0/24           # *STATIC NO NEED TO REPLACE* k8s subnet
  65007                      # *STATIC NO NEED TO REPLACE* Iris AS number bgp peer
  1101                       # Iris 1st peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  1102                       # Iris 2nd peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  50.117.59.208/28           # PUBLIC IPv4 Allocation
  50.117.59.208/30           # PUBLIC LOOPBACK subnet
  50.117.59.209              # PUBLIC Loopback IPv4 of SoftGate2
  50.117.59.212/30           # PUBLIC IPv4 NAT Subnet
  50.117.59.212/32           # CUSTOMER V-NET SNAT IP
  50.117.59.216/30           # L3LB Subnet 
  50.117.59.216/32           # L3LB IP
  50.117.59.220/30           # L4LB Subnet
  50.117.59.221              # Second usable ip address in load-balancer subnet
  50.117.59.222              # Third usable ip address in load-balancer subnet
  50.117.59.122/30           # isp1-ipv4-example BGP peer local IPv4
  50.117.59.121/30           # isp1-ipv4-example BGP peer remote IPv4
  50.117.59.126/30           # isp2-ipv4-customer BGP peer local IPv4
  50.117.59.125/30           # isp2-ipv4-customer BGP peer remote IPv4
  2607:f358:11:ffca::/64     # public IPv6 subnet
  2607:f358:11:ffca::1       # vnet-example IP6v gateway
  2607:f358:11:ffc0::15/127  # isp1-ipv6-example BGP peer local IPv6
  2607:f358:11:ffc0::14/127  # isp1-ipv6-example BGP peer remote IPv6
  s10-pre-configured         # LINK
  s10-learn-by-doing         # LINK
  s10-e-bgp                  # LINK
  s10-v-net                  # LINK
  s10-nat                    # LINK 
  s10-acl                    # LINK
  s10-l3lb                   # LINK 
  s10-k8s                    # LINK
  s10-topology               # LINK

Sandbox10
=========
**Contents**: 

.. toctree::
   :maxdepth: 2

   sandbox-info
   configurations
   creating-services
   onprem-k8s
