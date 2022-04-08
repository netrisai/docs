..
  #################
  Sandbox Variables
  #################
  ------------------------------------------------------------------------------------------------
  values                     | description
  ------------------------------------------------------------------------------------------------ 
  Sandbox3                   # Sandbox name Uppercase(case sensitive)
  sandbox3                   # Sandbox name Lowercase
  166.88.17.189              # Hypervisor PUBLIC IP
  10.254.45.0/24             # *STATIC NO NEED TO REPLACE* MANAGEMENT Allocation/Subnet
  10.254.46.0/24             # *STATIC NO NEED TO REPLACE* LOOPBACK Allocation/Subnet
  192.168.44.0/24            # *STATIC NO NEED TO REPLACE* ROH Allocation/Subnet
  192.168.45.64              # *STATIC NO NEED TO REPLACE* srv04 IP Address
  192.168.45.1               # *STATIC NO NEED TO REPLACE* vnet-example IP4v GW
  192.168.46.65              # *STATIC NO NEED TO REPLACE* srv05 IP Address
  192.168.46.1               # *STATIC NO NEED TO REPLACE* vnet-customer IPv4 GW
  192.168.110.0/24           # *STATIC NO NEED TO REPLACE* k8s subnet
  65007                      # *STATIC NO NEED TO REPLACE* Iris AS number bgp peer
  1031                       # Iris 1st peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  1032                       # Iris 2nd peer VLAN ID, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  45.38.161.48/28            # PUBLIC IPv4 Allocation
  45.38.161.48/30            # PUBLIC LOOPBACK subnet
  45.38.161.49               # PUBLIC Loopback IPv4 of SoftGate2
  45.38.161.52/30            # PUBLIC IPv4 NAT Subnet
  45.38.161.52/32            # CUSTOMER V-NET SNAT IP
  45.38.161.56/30            # L3LB Subnet 
  45.38.161.56/32            # L3LB IP
  45.38.161.60/30            # L4LB Subnet
  45.38.161.61               # Second usable ip address in load-balancer subnet
  45.38.161.62               # Third usable ip address in load-balancer subnet
  45.38.161.66/30            # isp1-ipv4-example BGP peer local IPv4
  45.38.161.65/30            # isp1-ipv4-example BGP peer remote IPv4
  45.38.161.70/30            # isp2-ipv4-customer BGP peer local IPv4
  45.38.161.69/30            # isp2-ipv4-customer BGP peer remote IPv4
  2607:f358:11:ffc3::/64     # public IPv6 subnet
  2607:f358:11:ffc3::1       # vnet-example IP6v gateway
  2607:f358:11:ffc0::7/127   # isp1-ipv6-example BGP peer local IPv6
  2607:f358:11:ffc0::6/127   # isp1-ipv6-example BGP peer remote IPv6
  s3-pre-configured          # LINK
  s3-learn-by-doing          # LINK
  s3-e-bgp                   # LINK
  s3-v-net                   # LINK
  s3-nat                     # LINK 
  s3-acl                     # LINK
  s3-l3lb                    # LINK 
  s3-k8s                     # LINK
  s3-topology                # LINK

Sandbox3
=========
**Contents**: 

.. toctree::
   :maxdepth: 2

   sandbox-info
   configurations
   creating-services
   onprem-k8s
