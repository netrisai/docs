.. meta::
    :description: Upgrading Netris from 3.0.9 to 3.0.10

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

e
