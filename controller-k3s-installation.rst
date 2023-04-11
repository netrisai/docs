.. meta::
  :description: Controller Generic Linux Host

.. _ctl-k3s-def:

######################################################
Netris Controller installation on a generic Linux host
######################################################

Linux Host requirements
=======================

* RAM: 8 GB
* CPU: 4 Cores
* Disk: 50GB
* OS: Linux 64-bit

.. note:: 

  K3s is expected to work on most modern Linux systems.

  Some OSs have specific requirements:

  * If you are using Raspbian Buster, follow `these steps <https://rancher.com/docs/k3s/latest/en/advanced/#enabling-legacy-iptables-on-raspbian-buster>`__ to switch to legacy iptables.
  * If you are using Alpine Linux, follow `these steps <https://rancher.com/docs/k3s/latest/en/advanced/#additional-preparation-for-alpine-linux-setup>`__ for additional setup.
  * If you are using (Red Hat/CentOS) Enterprise Linux, follow `these steps <https://rancher.com/docs/k3s/latest/en/advanced/#additional-preparation-for-red-hat-centos-enterprise-linux>`__ for additional setup.


Installation
============

The following command will install the Netris Controller on your Linux server:

.. code-block:: shell-session

  curl -sfL https://get.netris.io | sh -

Once installed, you will be able to log in to Netris Controller using your host's IP address.


.. note:: 
  The installation script does the following:
  
  * Installs `k3s <https://k3s.io/>`_
  * Installs the `Cert-Manager Helm chart <https://cert-manager.io/docs/installation/helm/>`_
  * Installs the `Netris Controller Helm chart <https://www.netris.io/docs/en/stable/controller-k8s-installation.html>`_



Installation with the specific host name
----------------------------------------

In order to set the specific ingress host name to the Netris Controller, use the ``--ctl-hostname`` installation argument:

.. code-block:: shell-session

  curl -sfL https://get.netris.io | sh -s -- --ctl-hostname netris.example.com

A self-signed SSL certificate will be generated from that host name.

Installation with the Let's Encrypt SSL
---------------------------------------

The installation script supports Let's Encrypt SSL generation out-of-box. To instruct the installation script to do that use ``--ctl-ssl-issuer`` argument.

.. note:: 
  | The argument ``--ctl-ssl-issuer`` is passing ``cert-manager.io/cluster-issuer`` value to the ingress resource of the Netris Controller. The installation script can create two types of ClusterIssuer resource: ``selfsigned`` or ``letsencrypt``, where ``selfsigned`` is just `Cert-Manager self-signed <https://cert-manager.io/docs/configuration/selfsigned/>`_ SSL and the ``letsencrypt`` is the ACME issuer with `HTTP01 challenge validation <https://cert-manager.io/docs/configuration/acme/http01/>`_.
  | If the ``--ctl-ssl-issuer`` argument is not set, the installation script will proceed with ``selfsigned`` ClusterIssuer type.


Run the following command to install Netris Controller and use ``letsencrypt`` ClusterIssuer for SSL generation:

.. code-block:: shell-session

  curl -sfL https://get.netris.io | sh -s -- --ctl-hostname netris.example.com --ctl-ssl-issuer letsencrypt

.. note:: 

  To successfully validate and complete Let's Encrypt SSL generation, a valid A/CNAME record for the domain/subdomain name should exist prior, and that name must be accessible from the Internet.


Installation with the Custom SSL Issuer
---------------------------------------

The HTTP01 challenge validation is the simplest way of issuing the Let's Encrypt SSL, but it does not work when the host behind the FQDN is not accessible from the public internet.
The common approach of validating and completing Let's Encrypt SSL generation for private deployments is `DNS01 challenge validation <https://cert-manager.io/docs/configuration/acme/dns01/>`_.
If the ``DNS01`` does not work for you either, Cert-Manager supports a number of certificate issuers, get familiar with all types of issuers `here <https://cert-manager.io/docs/configuration/>`_.

In order to install Netris Controller with the custom SSL issuer, you need to run installation script with the specified host name:

.. code-block:: shell-session

  curl -sfL https://get.netris.io | sh -s -- --ctl-hostname netris.example.com

Once the installation is complete, create a yaml file with the ``ClusterIssuer`` resource, suitable for your requirements, and apply it:

.. code-block:: shell-session

  kubectl apply -f my-cluster-issuer.yaml

Then rerun the installation script with the ``--ctl-ssl-issuer`` argument:

.. code-block:: shell-session

  curl -sfL https://get.netris.io | sh -s -- --ctl-ssl-issuer <Your ClusterIssuer resource name>


Upgrading
=========

To upgrade the Netris Controller to the latest version simply run the script:

.. code-block:: shell-session

  curl -sfL https://get.netris.io | sh -

If a newer version of Netris Controller is available, it will be updated in a few minutes.


Uninstalling
============

To uninstall Netris Controller and K3s from a server node, run:

.. code-block:: shell-session

  /usr/local/bin/k3s-uninstall.sh


.. _ctl-backup-restore:

Backup and Restore
==================

Netris Controller stores all critical data in MariaDB. It's highly recommended to create a cronjob with ``mysqldump``.


Backup
------

To take database snapshot run the following command:

.. code-block:: shell-session

  kubectl -n netris-controller exec -it netris-controller-mariadb-0 -- bash -c 'mysqldump -u $MARIADB_USER -p${MARIADB_PASSWORD} $MARIADB_DATABASE' > db-snapshot-$(date +%Y-%m-%d-%H-%M-%S).sql

After command execution, you can find ``db-snapshot-YYYY-MM-DD-HH-MM-SS.sql`` file in the current working directory.

.. _ctl-secret-key-backup:



Backup the Secret Key
~~~~~~~~~~~~~~~~~~~~~

Netris Controller generates a unique secret key at the first installation. If you're moving or reinstalling your controller, it makes sense to take note of the secret key for restoring purpose in the future. Overwise, you have to reinitiate all devices connected to the controller.

.. code-block:: shell-session

  kubectl -n netris-controller get secret netris-controller-grpc-secret -o jsonpath='{.data.secret-key}{"\n"}'


Restore
-------

In order to restore DB from a database snapshot, follow these steps:

1. Drop the current database by running the following command:

.. code-block:: shell-session

  kubectl -n netris-controller exec -it netris-controller-mariadb-0 -- bash -c 'mysql -u root -p${MARIADB_ROOT_PASSWORD} -e "DROP DATABASE $MARIADB_DATABASE"'

2. Create a new database:

.. code-block:: shell-session

  kubectl -n netris-controller exec -it netris-controller-mariadb-0 -- bash -c 'mysql -u root -p${MARIADB_ROOT_PASSWORD} -e "CREATE DATABASE $MARIADB_DATABASE"'

3. Copy snapshot file to the MariaDB container:

.. code-block:: shell-session

  kubectl -n netris-controller cp db-snapshot.sql netris-controller-mariadb-0:/opt/db-snapshot.sql

4. Run the restore command:

.. code-block:: shell-session

  kubectl -n netris-controller exec -it netris-controller-mariadb-0 -- bash -c 'mysql -u root -p${MARIADB_ROOT_PASSWORD} $MARIADB_DATABASE < /opt/db-snapshot.sql'

.. note:: 

  In this example the snapshot file name is db-snapshot.sql and it's located in the current working directory


Restore the Secret Key
~~~~~~~~~~~~~~~~~~~~~~

If you want to restore the controller secret key too (you might want to do that if you're reinstalling or moving the controller to the other place), follow these steps:

1. Set ``OLD_SECRET`` environment variable (the secret key taken from :ref:`the old controller<ctl-secret-key-backup>`):

.. code-block:: shell-session
  
  export OLD_SECRET=<Your old secret key>

example: ``export OLD_SECRET=VUdodFFSakJCU2lFVVA4T1c0cnpuUmdiMkQxem85Y2dnS3pkajlNSg==``

2. Update the secret key of the new controller:

.. code-block:: shell-session
  
  kubectl -n netris-controller patch secret netris-controller-grpc-secret --type='json' -p='[{"op" : "replace" ,"path" : "/data/secret-key" ,"value" : "'$OLD_SECRET'"}]'

3. Restart Netris Controller's all microservices

.. code-block:: shell-session

  kubectl -n netris-controller rollout restart deployments
