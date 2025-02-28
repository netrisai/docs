=======================
NVIDIA NetQ Integration
=======================

NVIDIA NetQ is a real-time network monitoring, visibility, and analytics solution designed for data centers running NVIDIA Cumulus Linux. It helps network administrators and operators gain deep insights into their network infrastructure, ensuring optimal performance, rapid troubleshooting, and proactive issue resolution.

Although Netris has built-in automatic monitoring and observability functionalities, integration with NVIDIA NetQ allows our NVIDIA customers to gain additional real-time monitoring, deeper visibility, and smarter analytics. Critical for AI Infrastructure. 

Topology Blueprint Activation
###############################

NVIDIA NetQ requires the topology blueprint described in a .dot filw format. Netris is aware of the Netris-managed network topology and has built-in functionality for exporting .dot file in NVIDIA NetQ format.

In the Netris controller, navigate to Network->Topology, select the appropriate site (datacenter), click Export and select NVIDIA NetQ - the web browser will download a .dot file.

.. image:: netq-0.png
  :align: center


Upload the newly generated .dot file into the NVIDIA NetQ. Navigate to Validation, Create a validation, Run on all switches, Topology, and click Upload Blueprint file. 

.. image:: netq-1.png
  :align: center

.. image:: netq-2.png
  :align: center

.. image:: netq-3.png
  :align: center

.. image:: netq-4.png
  :align: center

When you see the Blueprint successfully activated, your NVIDIA NetQ is aligned with the Netris topology and ready for further operation.
