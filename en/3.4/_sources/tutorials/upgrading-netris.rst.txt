.. meta::
    :description: Upgrading Netris

.. raw:: html

    <style> .green {color:#2fa84f} </style>
    <style> .red {color:red} </style>
  
.. role:: green

.. role:: red

**************************************
Netris Upgrade and Rollback Procedures
**************************************

Upgrade Procedure
=================

Due to potential database structural changes between Netris versions, it's highly recommended to take a backup of the database before upgrading. The backup will be used in the unlikely event of the need to perform a rollback.

1. To create a database backup, run the following command by first SSHing the Controller:

.. code-block:: shell-session

  kubectl -n netris-controller exec -it netris-controller-mariadb-0 -- bash -c 'mysqldump -u $MARIADB_USER -p${MARIADB_PASSWORD} $MARIADB_DATABASE' > db-snapshot.sql

Ensure that SQL file ``db-snapshot.sql`` is generated and present in the current directory.

.. note::
  
  An SQL dump is enough for this scenario, but that's not Netris-Controller's entire backup procedure. Get familiar with the Backup/Restore documentation :ref:`here<ctl-backup-restore>`.

2. Stop all Netris agents on devices managed by the controller (switch & SoftGate).

For the switch agent, first SSH to the switch and run the following command:

.. code-block:: shell-session

  sudo systemctl stop netris-sw

For the SoftGate agent, first SSH to the SoftGate and run the following command:

.. code-block:: shell-session

  sudo systemctl stop netris-sg

Ensure that all devices in the *Net → Inventory* section are ":red:`red`" with the "**check_agent**" status being "**Agent is unavailable**".

.. note::
  
  A stopped Netris agent has no impact on production traffic through the device.

.. _upgrade 3:

3. Before upgrading the Netris Controller, take a note of the "*Netris Version*" by navigating to *Setting → General* in the Controller web interface. This version number will be used in case of the need to perform a rollback procedure.

.. image:: /tutorials/images/netris_version_example.png
    :align: center
    :alt: Netris Version Example

4. Start the upgrade of the Netris Controller using the one-liner after SSHing to the Controller.

.. code-block:: shell-session

  curl -sfL https://get.netris.io | sh -

.. note::
  
  This process can take up to 5 minutes


Afterwards, make sure that all pods have either "*Running*" or "*Completed*" status by executing the following command:

.. code-block:: shell-session

  kubectl -n netris-controller get pods


The output is similar to this:

.. code-block:: shell-session

   NAME                                                      READY   STATUS      RESTARTS    AGE
   svclb-netris-controller-haproxy-6tkgj                     4/4     Running     0           38d
   netris-controller-haproxy-bcb944b7c-qcbf8                 1/1     Running     0           13d
   netris-controller-squid-7f6fdc6cf9-7fdx8                  1/1     Running     0           38d
   svclb-netris-controller-squid-58rnp                       1/1     Running     0           38d
   netris-controller-graphite-0                              1/1     Running     0           38d
   netris-controller-mongodb-0                               1/1     Running     0           38d
   netris-controller-redis-master-0                          1/1     Running     0           38d
   netris-controller-smtp-76778cf85f-lw5v5                   1/1     Running     0           10d
   netris-controller-mariadb-0                               1/1     Running     0           10d
   netris-controller-web-session-generator-8b9dbbcd8-8snhd   1/1     Running     0           10d
   netris-controller-telescope-notifier-647975848f-fs5dn     1/1     Running     0           10d
   netris-controller-app-b9b8d8f8d-4ssqb                     1/1     Running     0           10d
   netris-controller-grpc-987669fb9-jjskp                    1/1     Running     0           10d
   netris-controller-telescope-777c98c5d9-mqwl6              1/1     Running     0           10d
   helm-install-netris-controller-lqmq7                      0/1     Completed   0           20h


.. warning::
  
  If, after 5 minutes, you see pods with a status other than "*Running*" or "*Completed*", please reach out to us via `Slack <https://netris.slack.com/join/shared_invite/zt-1993b09c6-dWvgWusaeysToNHn7lIGTA#/shared-invite/email>`__.

Then verify that the "*Netris Version*" reflects the version change by navigating to *Setting → General* in the Controller web interface.

5. Once you have verified that the Netris controller is up-to-date, it is time to update the switch and SoftGate agents.

Upgrade the switch & SoftGate agents by copying the one-liner from the "*Install Agent*" option of the device's 3-dot menu found under the *Net → Inventory* section and pasting it after SSHing to the corresponding device.

.. image:: /tutorials/images/install_agent.gif
    :align: center
    :alt: Install Agent

After all the agents have finished the upgrade process, make sure all devices in the *Net → Inventory* section have a ":green:`green`" status and the *Netris version* for each device reflects the version change.

In the event the "**check_agent**" status is "**Agent is unavailable**" after the agent upgrade has finished, perform agent restart on the affected device(s).

For the switch agent, first SSH to the switch and run the following command:

.. code-block:: shell-session

  sudo systemctl restart netris-sw

For the SoftGate agent, first SSH to the SoftGate and run the following command:

.. code-block:: shell-session

  sudo systemctl restart netris-sg

Rollback Procedure
==================

A rollback procedure can be executed in the event the upgrade introduced any adverse impact on the production traffic.

1. Stop all Netris agents on the devices managed by the controller (switch & SoftGate).

For the switch agent, first SSH to the switch and run the following command:

.. code-block:: shell-session

  sudo systemctl stop netris-sw

For the SoftGate agent, first SSH to the SoftGate and run the following command:

.. code-block:: shell-session

  sudo systemctl stop netris-sg

2. Restore the database from the previously taken snapshot.

Drop the current database and create a new one by running the following command after SSHing to the Controller:

.. code-block:: shell-session

  kubectl -n netris-controller exec -it netris-controller-mariadb-0 -- bash -c 'mysql -u root -p${MARIADB_ROOT_PASSWORD} -e "DROP DATABASE $MARIADB_DATABASE"'
  kubectl -n netris-controller exec -it netris-controller-mariadb-0 -- bash -c 'mysql -u root -p${MARIADB_ROOT_PASSWORD} -e "CREATE DATABASE $MARIADB_DATABASE"'

While still connected to the Controller, copy the backup file from the controller host system to the MariaDB container and restore the database:

.. code-block:: shell-session

  kubectl -n netris-controller cp db-snapshot.sql netris-controller-mariadb-0:/opt/db-snapshot.sql
  kubectl -n netris-controller exec -it netris-controller-mariadb-0 -- bash -c 'mysql -u root -p${MARIADB_ROOT_PASSWORD} $MARIADB_DATABASE < /opt/db-snapshot.sql'

3. Downgrade Netris Controller application with the following command.

.. note::
  
  For the version number, use the number collected from :ref:`step #3<upgrade 3>` during the upgrade procedure.

Example:

.. code-block:: shell-session

  curl -sfL https://get.netris.io | sh -s -- --ctl-version 3.0.10-031

Afterwards, verify that the version of the "*Netris Version*" reflects the downgraded version by navigating to *Setting → General* in the Netris Controller.

4. Once you have verified that the Netris controller has been downgraded to the correct version, it is time to downgrade the switch and SoftGate agents. 

Install the correct and appropriate versions of the switch & SoftGate agents simply by copying the one-liner from the "*Install Agent*" option of the device's 3-dot menu found under the *Net → Inventory* section and pasting it after SSHing to the corresponding device.

After all the switches and SoftGates have been successfully downgraded, make sure all the devices in the *Net → Inventory* section have a ":green:`green`" status and the *Netris version* for each device reflects the version downgrade.

In case the "**check_agent**" status is "**Agent is unavailable**" after agent downgrade, perform agent restart.

For the switch agent, first SSH to the switch and run the following command:

.. code-block:: shell-session

  sudo systemctl restart netris-sw

For the SoftGate agent, first SSH to the SoftGate and run the following command:

.. code-block:: shell-session

  sudo systemctl restart netris-sg
