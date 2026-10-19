.. meta::
  :description: Netris Controller Maintenance and Backups

Netris Controller Maintenance and Backups
=========================================

.. contents:: Table of Contents
   :local:
   :depth: 4

This page covers day-2 operation of an HA Netris Controller: taking nodes down for maintenance safely, and locating, verifying, and restoring MariaDB backups. To install a new controller, see :doc:`Installing HA Netris Controller in Air-Gapped Environments <controller-k3s-air-gap-ha>`. To upgrade an existing one, see :doc:`Upgrading the HA Netris Controller <controller-ha-upgrade>`.

Maintenance Procedures
----------------------

Proper maintenance procedures are critical for ensuring the continued stability and availability of your Netris Controller HA deployment. Improper shutdown or maintenance sequences can lead to database cluster inconsistencies, particularly with MariaDB, potentially resulting in service disruptions or data corruption.

Node Maintenance Best Practices
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Individual Node Maintenance (Recommended Approach)
""""""""""""""""""""""""""""""""""""""""""""""""""

The safest approach is to perform maintenance on one node at a time, keeping the cluster operational throughout the process:

1. **Identify the primary MariaDB node before starting maintenance**:

   .. code-block:: bash

      kubectl -nnetris-controller get maxscale netris-controller-ha-mariadb

   Note the PRIMARY column output (e.g., ``netris-controller-ha-mariadb-ha-0``)

2. **Find which physical node is hosting the primary MariaDB**:

   .. code-block:: bash

      kubectl -nnetris-controller get pod netris-controller-ha-mariadb-ha-0 -o wide

   Note the NODE column (e.g., ``ctl-ha-node1``)

3. **Plan your maintenance order**:

   - Start with nodes NOT hosting the primary MariaDB
   - Leave the node hosting the primary MariaDB for last

4. **For each non-primary node**:

   a. **Cordon the node** to prevent new pods from being scheduled:

      .. code-block:: bash

         kubectl cordon <node-name>

   b. **Drain the node** safely to relocate all running pods:

      .. code-block:: bash

         kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data

   c. **Verify pods have been relocated**:

      .. code-block:: bash

         kubectl get pods -A -o wide | grep <node-name>

   d. **Perform maintenance** on the node (updates, reboots, etc.)

   e. **Bring the node back online.**

   f. **Verify the node is ready**:

      .. code-block:: bash

         kubectl get nodes

   g. **Uncordon the node**:

      .. code-block:: bash

         kubectl uncordon <node-name>

   h. **Verify cluster health before proceeding to the next node**:

      .. code-block:: bash

         kubectl get pods -n netris-controller
         kubectl -nnetris-controller get maxscale netris-controller-ha-mariadb

5. **For the node hosting the primary MariaDB**:

   a. **Double-check it's still hosting the primary** (as failover might have occurred):

      .. code-block:: bash

         kubectl -nnetris-controller get maxscale netris-controller-ha-mariadb
         kubectl -nnetris-controller get pod <primary-pod-name> -o wide

   b. Follow the same cordon, drain, maintenance, and uncordon steps as above

Full Cluster Maintenance (When All Nodes Need Simultaneous Maintenance)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

If you need to shut down multiple nodes simultaneously:

1. **Identify the primary MariaDB node**:

   .. code-block:: bash

      kubectl -nnetris-controller get maxscale netris-controller-ha-mariadb

   Note the PRIMARY column output (e.g., ``netris-controller-ha-mariadb-ha-0``)

2. **Find which physical nodes are hosting each MariaDB instance**:

   .. code-block:: bash

      kubectl -nnetris-controller get pod -l app.kubernetes.io/name=mariadb -o wide

3. **Safe node shutdown sequence**:

   a. **Shutdown secondary/replica nodes first**:

      .. code-block:: bash

         # For each non-primary node
         kubectl cordon <non-primary-node>
         kubectl drain <non-primary-node> --ignore-daemonsets --delete-emptydir-data
         # Wait at least 1 minute before shutting down or proceeding to next node
         sudo shutdown -h now  # Only on the drained node

   b. **Shutdown the primary node last**:

      .. code-block:: bash

         kubectl cordon <primary-node>
         kubectl drain <primary-node> --ignore-daemonsets --delete-emptydir-data
         sudo shutdown -h now  # Only on the primary node

4. **Safe node startup sequence**:

   a. **Start the node that was hosting the primary MariaDB first**

   b. **Wait until it's fully online** (check with ``kubectl get nodes``)

   c. **Start the remaining nodes** one by one, with at least 2 minutes between each

   d. **Uncordon each node after it's online**:

      .. code-block:: bash

         kubectl uncordon <node-name>

5. **Verify cluster health**:

   .. code-block:: bash

      kubectl get nodes
      kubectl -n netris-controller get pods
      kubectl -nnetris-controller get maxscale netris-controller-ha-mariadb


6. **Rebalance pods across all nodes**:

   After all nodes are back online and uncordoned, restart all deployments to ensure even pod distribution:

   .. code-block:: bash

      # This will restart all deployments in netris-controller namespace
      kubectl -nnetris-controller rollout restart deployment

   Wait for all pods to restart and reach Running state:

   .. code-block:: bash

      kubectl -nnetris-controller get pods

   Verify that pods are now distributed evenly across all nodes:

   .. code-block:: bash

      kubectl -nnetris-controller get pods -o wide

Verifying MariaDB Cluster Health
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After maintenance, verify the MariaDB cluster is healthy:

1. **Check MaxScale status**:

   .. code-block:: bash

      kubectl -nnetris-controller get maxscale netris-controller-ha-mariadb

   The STATUS should show ``Running``, and a PRIMARY should be identified

2. **Verify all MariaDB pods are running**:

   .. code-block:: bash

      kubectl -n netris-controller get pods -l app.kubernetes.io/name=mariadb

3. **If issues are detected**, check the operator logs:

   .. code-block:: bash

      kubectl -n netris-controller logs -l app.kubernetes.io/name=mariadb-operator

Maintenance Best Practices
^^^^^^^^^^^^^^^^^^^^^^^^^^

1. **Always perform one-node-at-a-time maintenance** when possible
2. **Never power off nodes** without properly cordoning and draining
3. **Always shut down secondary/replica database nodes before the primary**
4. **Always start the primary node first** when bringing the system back online
5. **Verify cluster health after each node** completes maintenance
6. **Rebalance your workloads** by restarting deployments after all maintenance is complete
7. **Schedule maintenance during low-usage periods**
8. **Create a backup before maintenance**
9. **Document all maintenance activities** in a maintenance log

MariaDB automatic backups: locate, verify, and restore
------------------------------------------------------

The Netris Controller automatically creates MariaDB backups every 12 hours.

These backups are stored locally on each controller node.

.. warning::

   Because backups are stored on local disks, copy them to an external and secure location such as object storage, NFS, or a backup server for disaster recovery.

Locate the backup directory on each controller node
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Each controller node stores a MariaDB backup locally.

Run the following command locally on each controller node. It detects and exports the backup directory path for the current node only:

.. code-block:: bash

   export BACKUP_PATH=$(kubectl get pv -o jsonpath='{range .items[*]}{.metadata.name}{"|"}{.spec.nodeAffinity.required.nodeSelectorTerms[0].matchExpressions[0].values[0]}{"|"}{.spec.local.path}{"\n"}{end}' \
   | grep netris-controller-ha-mariadb-backup \
   | grep "|$(hostname | tr '[:upper:]' '[:lower:]')|" \
   | cut -d'|' -f3)

Example:

.. code-block:: bash

   ubuntu@ctl-ha-node1:~$ sudo ls -al $BACKUP_PATH
   total 296
   drwxrwsrwx 2 root  999   4096 Feb  3 07:40 .
   drwx------ 9 root root   4096 Feb  3 07:40 ..
   -rw-r--r-- 1 lxd   999     39 Feb  3 07:40 0-backup-target.txt
   -rw-r--r-- 1 lxd   999 289736 Feb  3 07:40 backup.2026-02-03T07:40:03Z.sql

Copy the backup file to your home directory
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Choose the required backup file and copy it to your home directory:

.. code-block:: bash

   sudo cp $BACKUP_PATH/backup.2026-02-03T07:40:03Z.sql ~/backup.sql

Verify the backup file integrity
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Before restoring a backup, verify that the dump completed successfully.

The last line of the dump file must contain:

.. code-block:: text

   -- Dump completed on <date>

Check the last line by running:

.. code-block:: bash

   tail ~/backup.sql

Example output:

.. code-block:: bash

   -- Dump completed on 2026-02-03  7:40:03

.. caution::

   If this line is missing, do not restore from this backup.

Verify MariaDB cluster readiness before restore
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Before restoring, confirm that the MariaDB cluster is in the ``READY`` state:

.. code-block:: bash

   kubectl -n netris-controller get maxscale netris-controller-ha-mariadb

Expected output:

.. code-block:: bash

   NAME                           READY   STATUS    PRIMARY                             AGE
   netris-controller-ha-mariadb   True    Running   netris-controller-ha-mariadb-ha-0   66m

Proceed only if ``READY`` is ``True``.

Copy the backup file into a MariaDB pod
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Copy the backup file into one of the MariaDB pods:

.. code-block:: bash

   kubectl -n netris-controller cp ~/backup.sql \
     netris-controller-ha-mariadb-ha-0:/tmp/backup.sql

No output is expected.

Restore the backup
^^^^^^^^^^^^^^^^^^

Run the restore command inside the MariaDB pod:

.. code-block:: bash

   kubectl -n netris-controller exec -it netris-controller-ha-mariadb-ha-0 -- \
     bash -c 'mysql -h netris-controller-ha-mariadb -u netris -pchangeme netris < /tmp/backup.sql'

No output is expected if the restore completes successfully.

Take a manual backup
^^^^^^^^^^^^^^^^^^^^

To create a MariaDB backup manually at any time, run:

.. code-block:: bash

   kubectl -n netris-controller exec -it netris-controller-ha-mariadb-ha-0 -- \
     bash -c 'mysqldump -h netris-controller-ha-mariadb -u netris -pchangeme netris' \
     > db-snapshot-$(date +%Y-%m-%d-%H-%M-%S).sql

Summary
^^^^^^^

* MariaDB backups are created automatically every 12 hours.
* Backups are stored locally on each controller node.
* Copy backups to external storage for disaster recovery.
* Verify backup integrity before restoring.
* Restore only when the MariaDB cluster is in the ``READY`` state.

**For serious database issues**, contact Netris support with:

- Output of ``kubectl -nnetris-controller get maxscale netris-controller-ha-mariadb -o yaml``
- Logs from MariaDB pods and operator


By following these maintenance procedures, you can significantly reduce the risk of database inconsistencies and service disruptions during and after maintenance operations.
