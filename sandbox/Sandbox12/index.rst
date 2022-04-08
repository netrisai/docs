
..
  #################
  Sandbox Variables
  #################
  ------------------------------------------------------------------------------------------------
  values                     | description
  ------------------------------------------------------------------------------------------------ 
  Sandbox12                  # Sandbox name Uppercase(case sensitive)
  sandbox12                  # Sandbox name Lowercase
  50.117.27.83               # Hypervisor PUBLIC IP
  10.254.45.0/24             # *STATIC NO NEED TO REPLACE* MANAGEMENT Allocation/Subnet
  10.254.46.0/24             # *STATIC NO NEED TO REPLACE* LOOPBACK Allocation/Subnet
  192.168.44.0/24            # *STATIC NO NEED TO REPLACE* ROH Allocation/Subnet
  192.168.45.64              # *STATIC NO NEED TO REPLACE* srv04 IP Address
  192.168.45.1               # *STATIC NO NEED TO REPLACE* vnet-example IP4v GW
  192.168.46.65              # *STATIC NO NEED TO REPLACE* srv05 IP Address
  192.168.46.1               # *STATIC NO NEED TO REPLACE* vnet-customer IPv4 GW
  192.168.110.0/24           # *STATIC NO NEED TO REPLACE* k8s subnet
  65007                      # *STATIC NO NEED TO REPLACE* Iris AS number bgp peer
  1121                       # Iris 1st peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  1122                       # Iris 2nd peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  45.38.161.128/28           # PUBLIC IPv4 Allocation
  45.38.161.128/30           # PUBLIC LOOPBACK subnet
  45.38.161.129              # PUBLIC Loopback IPv4 of SoftGate2
  45.38.161.132/30           # PUBLIC IPv4 NAT Subnet
  45.38.161.132/32           # CUSTOMER V-NET SNAT IP
  45.38.161.136/30           # L3LB Subnet
  45.38.161.136/32           # L3lB IP
  45.38.161.140/30           # L4LB Subnet
  45.38.161.141              # Second usable ip address in load-balancer subnet
  45.38.161.142              # Third usable ip address in load-balancer subnet
  45.38.161.122/30           # isp1-ipv4-example BGP peer local IPv4
  45.38.161.121/30           # isp1-ipv4-example BGP peer remote IPv4
  45.38.161.126/30           # isp2-ipv4-customer BGP peer local IPv4
  45.38.161.125/30           # isp2-ipv4-customer BGP peer remote IPv4
  2607:f358:11:ffcc::/64     # public IPv6 subnet
  2607:f358:11:ffcc::1       # vnet-example IP6v gateway
  2607:f358:11:ffc0::19/127  # isp1-ipv6-example BGP peer local IPv6
  2607:f358:11:ffc0::18/127  # isp1-ipv6-example BGP peer remote IPv6
  s12-pre-configured         # LINK
  s12-learn-by-doing         # LINK
  s12-e-bgp                  # LINK
  s12-v-net                  # LINK
  s12-nat                    # LINK 
  s12-acl                    # LINK
  s12-l3lb                   # LINK 
  s12-k8s                    # LINK
  s12-topology               # LINK
  
Sandbox12
=========
**Contents**: 

.. toctree::
   :maxdepth: 2

   sandbox-info
   configurations
   creating-services
   onprem-k8s
