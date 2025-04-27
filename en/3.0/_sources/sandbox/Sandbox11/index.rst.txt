..
  #################
  Sandbox Variables
  #################
  ------------------------------------------------------------------------------------------------
  values                     | description
  ------------------------------------------------------------------------------------------------ 
  Sandbox11                  # Sandbox name Uppercase(case sensitive)
  sandbox11                  # Sandbox name Lowercase
  50.117.27.82               # Hypervisor PUBLIC IP
  10.254.45.0/24             # *STATIC NO NEED TO REPLACE* MANAGEMENT Allocation/Subnet
  10.254.46.0/24             # *STATIC NO NEED TO REPLACE* LOOPBACK Allocation/Subnet
  192.168.44.0/24            # *STATIC NO NEED TO REPLACE* ROH Allocation/Subnet
  192.168.45.64              # *STATIC NO NEED TO REPLACE* srv04 IP Address
  192.168.45.1               # *STATIC NO NEED TO REPLACE* vnet-example IP4v GW
  192.168.46.65              # *STATIC NO NEED TO REPLACE* srv05 IP Address
  192.168.46.1               # *STATIC NO NEED TO REPLACE* vnet-customer IPv4 GW
  192.168.110.0/24           # *STATIC NO NEED TO REPLACE* k8s subnet
  65007                      # *STATIC NO NEED TO REPLACE* Iris AS number bgp peer
  1111                       # Iris 1st peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  1112                       # Iris 2nd peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  45.38.161.96/28            # PUBLIC IPv4 Allocation
  45.38.161.96/30            # PUBLIC LOOPBACK subnet
  45.38.161.97               # PUBLIC Loopback IPv4 of SoftGate2
  45.38.161.100/30           # PUBLIC IPv4 NAT Subnet
  45.38.161.100/32           # CUSTOMER V-NET SNAT IP
  45.38.161.104/30           # L3LB Subnet
  45.38.161.104/32           # L3LB  IP
  45.38.161.108/30           # L4LB Subnet
  45.38.161.109              # Second usable ip address in load-balancer subnet
  45.38.161.110              # Third usable ip address in load-balancer subnet
  45.38.161.114/30           # isp1-ipv4-example BGP peer local IPv4
  45.38.161.113/30           # isp1-ipv4-example BGP peer remote IPv4
  45.38.161.118/30           # isp2-ipv4-customer BGP peer local IPv4
  45.38.161.117/30           # isp2-ipv4-customer BGP peer remote IPv4
  2607:f358:11:ffcb::/64     # public IPv6 subnet
  2607:f358:11:ffcb::1       # vnet-example IP6v gateway
  2607:f358:11:ffc0::17/127  # isp1-ipv6-example BGP peer local IPv6
  2607:f358:11:ffc0::16/127  # isp1-ipv6-example BGP peer remote IPv6
  s11-pre-configured         # LINK
  s11-learn-by-doing         # LINK
  s11-e-bgp                  # LINK
  s11-v-net                  # LINK
  s11-nat                    # LINK 
  s11-acl                    # LINK
  s11-l3lb                   # LINK 
  s11-k8s                    # LINK
  s11-topology               # LINK

Sandbox11
=========
**Contents**: 

.. toctree::
   :maxdepth: 2

   sandbox-info
   configurations
   creating-services
   onprem-k8s
