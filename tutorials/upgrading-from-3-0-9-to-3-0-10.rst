.. meta::
    :description: Upgrading Netris from 3.0.9 to 3.0.10

.. raw:: html

    <style> .green {color:#2fa84f} </style>
    <style> .red {color:red} </style>
  
.. role:: green

.. role:: red

*************************************
Upgrading Netris from 3.0.9 to 3.0.10
*************************************

Upgrade Procedure
=================

Due to major changes, including database structural changes, it's highly recommended to take a backup of the database before upgrading. It will be used in the unlikely event of necessity to perform a rollback.

1. To create a database backup, run the following command on the Controller:

.. code-block:: shell-session

  kubectl -n netris-controller exec -it netris-controller-mariadb-0 -- bash -c 'mysqldump -u $MARIADB_USER -p${MARIADB_PASSWORD} $MARIADB_DATABASE' > db-snapshot-3.0.9.sql

Ensure that SQL ``db-snapshot-3.0.9.sql`` file is generated in the current directory.

2. Stop all Netris agents on devices managed by the controller (switch & SoftGate).

For the switch agent:

.. code-block:: shell-session

  systemctl stop netris-sw

For the SoftGate agent:

.. code-block:: shell-session

  systemctl stop netris-sg

Ensure that all devices in the *Net → Inventory* section are ":red:`red`" with the "**check_agent**" status being "**Agent is unavailable**".

`*` *Stopped Netris agents don't affect production traffic through devices.*

3. Upgrade controller using one-liner.

`*` *This process can take up to 5 minutes*

.. code-block:: shell-session

  curl -sfL https://get.netris.ai | sh -

Afterwards, verify that the version of the "*Netris Dashboard Version*" reflects the upgraded version 3.0.10-X by navigating to *Setting → General* in the Netris Controller.

4. Once you have verified that the Netris controller is up-to-date, upgrade the switch & SoftGate agents using the one-liner from the "*Install Agent*" option of the corresponding device's 3-dot menu found under the *Net → Inventory* section of the Controller.

.. image:: /images/install_agent.gif
    :align: center
    :alt: Install Agent

Ensure that after the agent upgrade, all devices in the *Net → Inventory* section have a ":green:`green`" status and the Netris version for each device is 3.0.10-X.

In case the "**check_agent**" status is "**Agent is unavailable**" after agent upgrade, perform agent restart.

For the switch agent:

.. code-block:: shell-session

  systemctl restart netris-sw

For the SoftGate agent:

.. code-block:: shell-session

  systemctl restart netris-sg

Rollback Procedure
==================

A rollback procedure can be applied in case of any negative impact on the production after the Netris upgrade.

1. Stop all Netris agents on devices managed by the controller (switch & SoftGate) if already upgraded 3.0.10-X.

For the switch agent:

.. code-block:: shell-session

  systemctl stop netris-sw

For the SoftGate agent:

.. code-block:: shell-session

  systemctl stop netris-sg

2. Restore the database from the previously taken snapshot.

Copy the backup file from the controller host system to the MariaDB container:

.. code-block:: shell-session

  kubectl -n netris-controller cp db-snapshot-3.0.9.sql netris-controller-mariadb-0:/opt/db-snapshot-3.0.9.sql

Restore the database:

.. code-block:: shell-session

  kubectl -n netris-controller exec -it netris-controller-mariadb-0 -- bash -c 'mysql -u root -p${MARIADB_ROOT_PASSWORD} $MARIADB_DATABASE < /opt/db-snapshot-3.0.9.sql'

3. Downgrade Netris controller application:

.. code-block:: shell-session

  curl -sfL https://get.netris.ai | sh -s -- --ctl-version 3.0.9

4. Downgrade switch and SoftGate agents.

For the switch agent:

.. code-block:: shell-session

  apt-get update && apt-get install netris-sw=3.0.9.003

For the SoftGate agent:

.. code-block:: shell-session

  apt-get update && apt-get install netris-sg=3.0.9.002

Afterwards, verify that the version of the "*Netris Dashboard Version*" reflects the downgraded version 3.0.9-X by navigating to *Setting → General* in the Netris Controller.

Ensure that after the agent downgrade, all the devices in the *Net → Inventory* section have a ":green:`green`" status and the Netris version for each device is 3.0.9-X.

In case the "**check_agent**" status is "**Agent is unavailable**" after agent downgrade, perform agent restart.

For the switch agent:

.. code-block:: shell-session

  systemctl restart netris-sw

For the SoftGate agent:

.. code-block:: shell-session

  systemctl restart netris-sg
