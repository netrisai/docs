..
  #################
  Sandbox Variables
  #################
  ------------------------------------------------------------------------------------------------
  values                     | description
  ------------------------------------------------------------------------------------------------ 
  Sandbox2                   # Sandbox name Uppercase(case sensitive)
  sandbox2                   # Sandbox name Lowercase
  166.88.17.190              # Hypervisor PUBLIC IP
  10.254.45.0/24             # *STATIC NO NEED TO REPLACE* MANAGEMENT Allocation/Subnet
  10.254.46.0/24             # *STATIC NO NEED TO REPLACE* LOOPBACK Allocation/Subnet
  192.168.44.0/24            # *STATIC NO NEED TO REPLACE* ROH Allocation/Subnet
  192.168.45.64              # *STATIC NO NEED TO REPLACE* srv04 IP Address
  192.168.45.1               # *STATIC NO NEED TO REPLACE* vnet-example IP4v GW
  192.168.46.65              # *STATIC NO NEED TO REPLACE* srv05 IP Address
  192.168.46.1               # *STATIC NO NEED TO REPLACE* vnet-customer IPv4 GW
  192.168.110.0/24           # *STATIC NO NEED TO REPLACE* k8s subnet
  65007                      # *STATIC NO NEED TO REPLACE* Iris AS number bgp peer
  1021                       # Iris 1st peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  1022                       # Iris 2nd peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  45.38.161.32/28            # PUBLIC IPv4 Allocation
  45.38.161.32/30            # PUBLIC LOOPBACK subnet
  45.38.161.33               # PUBLIC Loopback IPv4 of SoftGate2
  45.38.161.36/30            # PUBLIC IPv4 NAT Subnet
  45.38.161.36/32            # CUSTOMER V-NET SNAT IP
  45.38.161.40/30            # L3LB Subnet 
  45.38.161.40/32            # L3LB IP
  45.38.161.44/30            # L4LB Subnet
  45.38.161.45               # Second usable ip address in load-balancer subnet
  45.38.161.46               # Third usable ip address in load-balancer subnet
  45.38.161.26/30            # isp1-ipv4-example BGP peer local IPv4
  45.38.161.25/30            # isp1-ipv4-example BGP peer remote IPv4
  45.38.161.30/30            # isp2-ipv4-customer BGP peer local IPv4
  45.38.161.29/30            # isp2-ipv4-customer BGP peer remote IPv4
  2607:f358:11:ffc2::/64     # public IPv6 subnet
  2607:f358:11:ffc2::1       # vnet-example IP6v gateway
  2607:f358:11:ffc0::5/127   # isp1-ipv6-example BGP peer local IPv6
  2607:f358:11:ffc0::4/127   # isp1-ipv6-example BGP peer remote IPv6
  s2-pre-configured          # LINK
  s2-learn-by-doing          # LINK
  s2-e-bgp                   # LINK
  s2-v-net                   # LINK
  s2-nat                     # LINK 
  s2-acl                     # LINK
  s2-l3lb                    # LINK 
  s2-k8s                     # LINK
  s2-topology                # LINK

Sandbox2
=========
**Contents**: 

.. toctree::
   :maxdepth: 2

   sandbox-info
   configurations
   creating-services
   onprem-k8s
