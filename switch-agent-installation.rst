.. _Network-Switch-initial-setup:
.. meta::
  :description: Network Switch initial setup

############################
Network Switch initial setup
############################

.. toctree::
   :maxdepth: 2

   Nvidia-Cumulus-v5-Switch-initial-setup
   Ubuntu-SwitchDev-Switch-initial-setup
   EdgeCore-SONiC-Switch-initial-setup
   Nvidia-Cumulus-v3.7-Switch-initial-setup


.. _switch-agent-installation-install-the-netris-agent:

************************
Install the Netris Agent 
************************

1. Add the Switch in the controller **Inventory**. Detailed configuration documentation is available here: :ref:`"Adding Switches"<topology-management-adding-switches>`
2. Once the Switch is created in the **Inventory**, click on **three vertical dots (⋮)** on the right side on the Switch and select the **Install Agent** option
3. Copy the agent install command to your clipboard and run the command on the Switch
4. Reboot the Switch when the installation completes

.. code-block:: shell-session

 sudo reboot

Once the switch boots up you should see its heartbeat going from Critical to OK in Net→Inventory, Telescope→Dashboard, and switch color will reflect its health in Net→Topology

Screenshot: Net→Inventory

.. image:: images/inventory_heartbeat.png
   :align: center
