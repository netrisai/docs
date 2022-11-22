..
  ##################
  values for replace
  ##################
  ------------------------------------------------------------------------------------------------
  values                   | description
  ------------------------------------------------------------------------------------------------ 
  sandbox6                  # sandbox name
  166.88.17.186             # hypervisor public ip
  300                       # *STATIC NO NEED TO REPLACE* ssh NAT port *SHORT QUERY BE CAREFUL WHILE REPLACING*
  10.254.45.0/24            # *STATIC NO NEED TO REPLACE* management subnet
  10.254.46.0/24            # *STATIC NO NEED TO REPLACE* loopback subnet
  192.168.45.64             # *STATIC NO NEED TO REPLACE* srv4 ip address
  192.168.46.65             # *STATIC NO NEED TO REPLACE* srv5 ip address
  192.168.46.1              # *STATIC NO NEED TO REPLACE* vnet-customer gateway
  192.168.110.              # *STATIC NO NEED TO REPLACE* k8s subnet
  65007                     # *STATIC NO NEED TO REPLACE* Iris AS number bgp peer, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  1061                      # Iris 1nd peer vlanid, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  1062                      # Iris 2nd peer vlanid, *SHORT QUERY BE CAREFUL WHILE REPLACING*
  50.117.59.144/28          # customer public subnet
  50.117.59.154             # second usable ip address in load-balancer subnet
  50.117.59.155             # third usable ip address in load-balancer subnet
  50.117.59.90/30           # isp1-customer bgp peer local ip
  50.117.59.89/30           # isp1-customer bgp peer remote ip
  50.117.59.94/30           # isp2-customer bgp peer local ip
  50.117.59.93/30           # isp2-customer bgp peer remote ip
  50.117.59.150/32          # customer v-net nat ip
  s6-pre-configured         # LINKS
  s6-learn-by-doing         # LINKS
  s6-e-bgp                  # LINKS
  s6-v-net                  # LINKS
  s6-nat                    # LINKS 
  s6-acl                    # LINKS
  s6-k8s                    # LINKS

Sandbox6
=========
**Contents**: 

.. toctree::
   :maxdepth: 2

   sandbox-info
   configurations
   creating-services
   onprem-k8s
