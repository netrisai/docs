.. meta::
    :description: Netris Healthchecks

################################################################
Netris Healthchecks
################################################################

Netris includes built-in healthchecks to monitor the status of various network services and applications. These healthchecks help ensure that your network infrastructure is functioning optimally by providing real-time insights into service availability and performance.

There are three main categories of healthchecks in Netris:

* **Node Health**: Node-level health checks that validate whether a node is functioning properly.
* **Fabric Health**: Control-plane and protocol-level checks that validate the network fabric as a whole is functioning properly.
* **Switch Port Health**: Port-level checks that validate whether a specific switch port is functioning properly.

.. list-table:: Healthchecks
   :header-rows: 1
   :widths: 9 9 13 20 15 13

   * - Check type
     - Check name
     - Description
     - Trigger Logic
     - Message example
     - Comments
   * - Node Health
     - check_disk
     - Storage % used
     -
       - OK - below Warning threshold
       - WARNING - above Warning threshold
       - CRITICAL - above Critical threshold
     - 53% / Used from 5.4G
     -
       - Warning threshold default 70
       - Critical threshold default 80
   * - Node Health
     - check_fan
     - Fan status
     -
       - OK - OK
       - CRITICAL - ABSENT, FAILED and etc.
     - Fan Tray 1, Fan 1(OK), Fan Tray 2, Fan 2(OK)
     -
   * - Node Health
     - check_load
     - Load average
     -
       - OK - below Warning threshold
       - WARNING - above Warning threshold
       - CRITICAL - above Critical threshold
     - Load average 0.39, 0.50, 0.66
     -
       - Warning threshold default 3
       - Critical threshold default 4
   * - Node Health
     - check_memory
     - RAM % used
     -
       - OK - below Warning threshold
       - WARNING - above Warning threshold
       - CRITICAL - above Critical threshold
     - 89% Used of 1709 MB
     -
       - Warning threshold default 80
       - Critical threshold default 90
   * - Node Health
     - check_psu
     - Power Supply status
     -
       - OK - OK
       - CRITICAL - BAD, FAILED and etc.
     - PSU1(OK), PSU2(OK)
     -
   * - Node Health
     - check_ratio
     - Detects unusually frequent configuration changes that may indicate abnormal or unstable behavior
     -
       - OK - below Warning threshold
       - WARNING - above Warning threshold
       - CRITICAL - above Critical threshold
     - vxpd - 0%
     - Critical threshold default 60
   * - Node Health
     - check_temp
     - Temperature sensors status
     -
       - OK - OK
       - CRITICAL - ABSENT, FAILED and etc.
     - PSU1 Temp Sensor(OK), PSU2 Temp Sensor(OK)
     -
   * - Node Health
     - health_monitoring
     - Checks that Netris self monitoring is active
     -
       - OK - Active
       - CRITICAL - Inactive
     - Monitoring Active
     -
   * - Node Health
     - sys_service
     - Critical services status. Monitored services: rsyslog, collectd, switchd, frr, vxrd,  netris-portinfo-server, netris-swlb
     -
       - OK - all active (vxrd inactive)
       - CRITICAL - one or more is inactive or vxrd active
     - rsyslog - active, collectd@mgmt - active, switchd - active, frr - active, vxrd - inactive, netris-portinfo-server - active, netris-swlb.service - active
     -
   * - Node Health
     - xc_service
     - Netris agent services healthcheck: vxpd-nvue, ifstats
     -
       - OK - OK
       - CRITICAL - any service is down.
     - vxpd-nvue - OK, ifstats - OK
     -
   * - Node Health
     - xc_timesync
     - NTP sync status
     -
       - OK - NTP is syncronized
       - CRITICAL - NTP is not syncronized
     - Time is synchronized
     -
   * - Fabric Health
     - check_bgp_underlay
     - Checks that switch loopbacks are properly learned from other switches
     -
       - OK - all loopbacks are learned from other switches
       - CRITICAL - not all all loopbacks are learned from other switches
     - - All loopback routes present in routing table
       - Missing loopback routes: Host `ns-leaf-0` - 10.2.0.1 is not reachable
     -
   * - Fabric Health
     - check_bgp
     - Checks BGP session status on the port towards connected neighboring switch
     -
       - OK - State is Established, at least 1 prefix is learned
       - WARNING - State is Established, 0 prefixes learned
       - CRITICAL - State is other than Established
     - swp57s0 IPv4(State: Established, Prefix: 4, Uptime: 02:31:46)
     -
   * - Fabric Health
     - check_topology
     - Checks that LLDP information from the port is consistent with Netris Topology. Switch hostname and port from the Netris Topology must match with LLDP.
     -
       - OK - Wiring is consistent with the Topology
       - CRITICAL - LLDP information is not consistent with the Topology
     - OK - Wiring is consistent with the Topology
     -
   * - Switch Port Health
     - check_port
     - Checks port status, % of RX/TX bandwidth utilization, laser signal level threshold breach, transceiver temperature, transceiver presence, Bit Error Rate (BER)
     -
       - OK - port is UP, and RX/TX utilization is below Warning threshold, Laser Signal Levels are below Warning threshold, pluggable is present or the port is fixed, temperature below threshold, BER below threshold
       - WARNING - port is UP and (RX/TX utilization is above Warning threshold or Laser Signal Levels are above Warning threshold), or temperature above Warning threshold
       - CRITICAL - port is DOWN, or RX/TX utilization is above Critical threshold, or Laser Signal Levels are above Critical threshold, or pluggable is absent, ore temperature above Critical threshold, or BER above Critical threshold
     - swp57s0 port is UP, 0% RX Utilized of 1 Gbps, 0% TX Utilized of 1 Gbps
     -
       - TX/RX Warning threshold default 70
       - TX/RX Critical threshold default 90
       - Laser signal levels thresholds are taken from the transceiver