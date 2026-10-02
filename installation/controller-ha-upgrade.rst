.. meta::
  :description: Upgrading the HA Netris Controller

.. _k3s-ha-upgrade:

Upgrading the HA Netris Controller
==================================

.. contents:: Table of Contents
   :local:
   :depth: 3

This page covers upgrading an existing HA Netris Controller deployment. To install a new controller, see :doc:`Installing HA Netris Controller in Air-Gapped Environments <controller-k3s-air-gap-ha>`. For day-2 maintenance and database backups, see :doc:`Netris Controller Maintenance and Backups <controller-maintenance-backups>`.

Obtain the Upgrade File
-----------------------

Contact `Netris <https://www.netris.io/demo/>`_ to acquire the air-gapped upgrade package, named **netris-controller-ha-v4.x.x.tar.gz**. This package contains everything you need for an HA deployment of Netris Controller on K3S, without internet connectivity.



1. Preparing Each Node
----------------------

1.1 Transfer the File to the Servers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use a secure copy method (e.g., SCP, USB drive) to move the netris-controller-ha-v4.x.x.tar.gz file to all three of your nodes.


1.2 Extract the Tarball
^^^^^^^^^^^^^^^^^^^^^^^

Once the file is on the servers, extract its contents:

.. code-block:: shell

  tar -xzvf netris-controller-ha-v4.x.x.tar.gz

This will create a folder containing all necessary scripts, binaries, images, Helm charts, CRDs, and manifests.


1.3 Navigate to the Installation Directory
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

On **all three nodes,** change the directory to the extracted folder. For example:

.. code-block:: shell

  cd netris-controller-ha-v4.x.x

All subsequent steps in this guide assume you're working from within this netris-controller-ha-v4.x.x/ directory.



2. Steps to Upgrade Controller
------------------------------

*If you're only upgrading the Local Netris Repository, you can skip this section and go directly to* :ref:`Section 3<local-repo-k3s-ha-upgrade>`

2.1 Import Necessary Container Images
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

On **all three nodes**, import container images:


1. Decompress the images archive:

.. code-block:: shell

  gunzip -f images.tar.gz


2. Import them:

.. code-block:: shell

  sudo ctr images import images.tar

2.2 Add Helm Chart Package Upgrades to K3S
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Copy your Helm charts to the K3S static files directory on **all three nodes**:

.. code-block:: shell

  sudo cp files/charts/* /var/lib/rancher/k3s/server/static/charts/


2.3 Database backup
^^^^^^^^^^^^^^^^^^^

To take a database snapshot, run the following command on the **first node**:

.. code-block:: shell

  kubectl -n netris-controller exec -it netris-controller-ha-mariadb-ha-0 -- bash -c 'mysqldump -h netris-controller-ha-mariadb -u netris -pchangeme netris' > db-snapshot-$(date +%Y-%m-%d-%H-%M-%S).sql


2.4 Upgrade Netris Controller
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

On the **first node** only:

.. warning::
   **Upgrading to v4.6.1?** Do not follow the manual steps below. Instead, use the automated upgrade script included in the package, which handles MariaDB cluster re-creation, database backup/restore, and MongoDB data migration automatically:

   .. code-block:: shell

      ./update-v4.6.1.sh

   The script will verify versions, prompt for confirmation, and guide you through the full upgrade. Once it completes successfully, proceed to step 3 to verify the result.

1. Upgrade the **Helm chart** manifest:

.. code-block:: shell

  ./netris upgrade


2. Wait 2-4 minutes for all pods to be upgraded.

3. Check:

.. code-block:: shell

  kubectl get pods -n netris-controller

Look for multiple pods in Running and Completed states.


.. _local-repo-k3s-ha-upgrade:

3. Steps to Upgrade the Local Netris Repository
-----------------------------------------------

On **all three nodes**, copy the repository files into the Persistent Volume:

.. code-block:: shell

  export PVC_PATH=$(kubectl get pv $(kubectl get pvc staticsite-$(kubectl -nnetris-controller get pod -l app.kubernetes.io/instance=netris-local-repo --field-selector spec.nodeName=$(hostname | tr '[:upper:]' '[:lower:]') --no-headers -o custom-columns=":metadata.name") -n netris-controller -o jsonpath="{.spec.volumeName}") -o jsonpath="{.spec.local.path}")

  sudo cp -r files/repo ${PVC_PATH}



**Congratulations!** You have successfully upgraded your **highly available, air-gapped** Netris Controller.
