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
   :widths: 9 9 13 20 15 15

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
     - Checks whether the node is monitored by Netris
     -
       - OK - Active
       - CRITICAL - Inactive
     - 
       - Monitoring Active
       - Monitoring Unavailable
     - If this check is CRITICAL, other healthchecks for the same nodes are marked Unknown, as the node monitoring if not functioning properly.
   * - Node Health
     - sys_service
     - Monitors service status:

       - rsyslog
       - collectd
       - switchd
       - frr
       - vxrd
       - netris-portinfo-server
       - netris-swlb
     -
       - OK - all active and vxrd inactive
       - CRITICAL - one or more is inactive or vxrd active
     - rsyslog - active, collectd@mgmt - active, switchd - active, frr - active, vxrd - inactive, netris-portinfo-server - active, netris-swlb.service - active
     -
   * - Node Health
     - xc_service
     - Netris agent healthcheck:
     
       - vxpd-nvue
       - ifstats
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
     - Switch loopbacks reachability
     -
       - OK - all loopbacks are learned from other switches
       - CRITICAL - not all loopbacks are learned from other switches
     - 
       - All loopback routes present in routing table
       - Missing loopback routes: Host `ns-leaf-0` - 10.2.0.1 is not reachable
     -
   * - Fabric Health
     - check_bgp
     - BGP session status on port towards connected neighbor switch
     -
       - OK - State is Established, at least 1 prefix is learned
       - WARNING - State is Established, 0 prefixes learned
       - CRITICAL - State is other than Established
     - swp57s0 IPv4(State: Established, Prefix: 4, Uptime: 02:31:46)
     -
   * - Fabric Health
     - check_topology
     - Compares LLDP information with declared Netris Topology.
     -
       - OK - Wiring is consistent with the Topology
       - CRITICAL - LLDP information is not consistent with the Topology
     - 
       - Wiring is consistent with the Topology
       - swp33s1 is wired to **swp1s1@spine-0-pod00** instead of **swp1s0@spine-0-pod00**
     -
   * - Switch Port Health
     - check_port
     - Checks:

       - port status
       - % of RX/TX bandwidth utilization
       - threshold breach

         - RX/TX drops
         - RX/TX errors
       - laser signal level
       - transceiver temperature
       - transceiver presence
       - Bit Error Rate (BER)
     -
       - OK - port is UP, and all metrics are below the Warning threshold, pluggable is present or the port is fixed
       - WARNING - port is UP and any one or more metrics are above Warning threshold, but below Critical threshold
       - CRITICAL - port is DOWN, or any one or more metrics are above Critical threshold, or pluggable is absent
     -
       - swp57s0 port is UP, 0% RX Utilized of 1 Gbps, 0% TX Utilized of 1 Gbps
       - swp9s1 in-drops:critical(>=0.1%),out-drops:ok,in-errors:ok,out-errors:ok, port is UP, 0% RX Utilized of 200 Gbps, 0% TX Utilized of 200 Gbps, Signal | Levels(dBm) per lane = N/A, Temperature: N/A, Bit Error Rate: N/A
       - in-drops Increase percentage is 0.03%.
     -
       - TX/RX bandwidth utilization Warning threshold default 70
       - TX/RX bandwidth utilization Critical threshold default 90
       - Laser signal levels thresholds are taken from the transceiver
       - TX/RX drops: Warning threshold percentage ≥ 0.01% AND Δdrops/errors > 50; Critical threshold percentage ≥ 0.1% AND Δdrops/errors > 50

RX/TX drops and errors threshold calculation method
=====================================================

.. tip::
   You can verify the counter values on a Cumulus switch by running the following command:

   .. code-block:: bash

      nv show interface --view counters -o json

.. tip::
   Only physical interfaces are evaluated.

**Calculation**:

For each of the four drop/error counters (``in-drops``, ``out-drops``, ``in-errors``, ``out-errors``), the check performs the following steps:

#. Read the counter value from the previous check run. If no previous value exists, return OK and store the current value.
#. Read the current counter value.
#. Read the corresponding packet counter (``in-pkts`` for ``in-drops`` / ``in-errors``; ``out-pkts`` for ``out-drops`` / ``out-errors``) from the previous check run. If no previous value exists, return OK and store the current value.
#. Read the current packet counter value.
#. Calculate the drop/error percentage using the Δ (Δ = current value − previous value).

.. code-block:: text

   in_drop_percentage  = 100 * Δin_drops  / (Δin_packets  + Δin_drops)
   out_drop_percentage = 100 * Δout_drops / (Δout_packets + Δout_drops)
   in_error_percentage  = 100 * Δin_errors  / (Δin_packets  + Δin_errors)
   out_error_percentage = 100 * Δout_errors / (Δout_packets + Δout_errors)