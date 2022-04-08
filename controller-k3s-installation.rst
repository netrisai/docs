
.. meta::
  :description: Controller Generic Linux Host

##################
Generic Linux Host
##################

Netris offers a simplified deployment model for users who want to install the Netris Controller on the standalone Linux server.

The installation script does the following:

* Installs `k3s <https://k3s.io/>`_
* Installs the `Cert-Manager Helm chart <https://cert-manager.io/docs/installation/helm/>`_
* Installs the `Netris Controller Helm chart <https://www.netris.ai/docs/en/stable/controller-k8s-installation.html>`_

Requirements
============

* RAM: 4GB Minimum (we recommend at least 8GB)
* CPU: 2 Minimum (we recommend at least 4)
* Disk: 50GB
* OS: Linux 64-bit

.. note:: 

  K3s is expected to work on most modern Linux systems.

  Some OSs have specific requirements:

  * If you are using Raspbian Buster, follow `these steps <https://rancher.com/docs/k3s/latest/en/advanced/#enabling-legacy-iptables-on-raspbian-buster>`_ to switch to legacy iptables.
  * If you are using Alpine Linux, follow `these steps <https://rancher.com/docs/k3s/latest/en/advanced/#additional-preparation-for-alpine-linux-setup>`_ for additional setup.
  * If you are using (Red Hat/CentOS) Enterprise Linux, follow `these steps <https://rancher.com/docs/k3s/latest/en/advanced/#additional-preparation-for-red-hat-centos-enterprise-linux>`_ for additional setup.


Installation
============

The following command will install the Netris Controller on your Linux server:

.. code-block:: shell-session

  curl -sfL https://get.netris.ai | sh -

Once installed, you will be able to log in to Netris Controller using your host's IP address.

Installation with the specific host name
------------------------------------------

In order to set the specific ingress host name to the Netris Controller, use the ``--ctl-hostname`` installation argument:

.. code-block:: shell-session

  curl -sfL https://get.netris.ai | sh -s -- --ctl-hostname netris.example.com

A self-signed SSL certificate will be generated from that host name.

Installation with the Let's Encrypt SSL
---------------------------------------

The installation script supports Let's Encrypt SSL generation out-of-box. To instruct the installation script to do that use ``--ctl-ssl-issuer`` argument.

The argument ``--ctl-ssl-issuer`` is passing ``cert-manager.io/cluster-issuer`` value to the ingress resource of the Netris Controller. The installation script creates 2 resources type of ClusterIssuer: ``selfsigned`` and ``letsencrypt``,
where ``selfsigned`` is just `Cert-Manager self-signed <https://cert-manager.io/docs/configuration/selfsigned/>`_ SSL and the ``letsencrypt`` is the ACME Issuer with `HTTP01 challenge validation <https://cert-manager.io/docs/configuration/acme/http01/>`_.
When ``--ctl-ssl-issuer`` isn't set installation script is proceeding with ``selfsigned`` ClusterIssuer.


Run the following command to install Netris Controller and use ``letsencrypt`` ClusterIssuer for SSL generation:

.. code-block:: shell-session

  curl -sfL https://get.netris.ai | sh -s -- --ctl-hostname netris.example.com --ctl-ssl-issuer letsencrypt

.. note:: 

  To successfully validate and complete Let's Encrypt SSL generation, a valid A/CNAME record for the domain/subdomain name should exist prior, and that name must be accessible from the Internet.


Installation with the Custom SSL Issuer
---------------------------------------

The HTTP01 challenge validation is the simplest way of issuing the Let's Encrypt SSL, but it doesn't work when the host behind the FQDN isn't accessible from the public internet.
The common approach of validating and completing Let's Encrypt SSL generation for private deployments is `DNS01 challenge validation <https://cert-manager.io/docs/configuration/acme/dns01/>`_.
If the ``DNS01`` doesn’t work for you either, Cert-Manager supports a number of certificate issuers, get familiar with all types of issuers `here <https://cert-manager.io/docs/configuration/>`_.

In order to install Netris Controller with the custom SSL issuer, you need to run installation script with the specified host name:

.. code-block:: shell-session

  curl -sfL https://get.netris.ai | sh -s -- --ctl-hostname netris.example.com

Once the installation has finished, create a yaml file with the ``ClusterIssuer`` resource, suitable for your requirements, and apply it:

.. code-block:: shell-session

  kubectl apply -f my-cluster-issuer.yaml

Then rerun the installation script with the ``--ctl-ssl-issuer`` argument:

.. code-block:: shell-session

  curl -sfL https://get.netris.ai | sh -s -- --ctl-ssl-issuer <Your ClusterIssuer resource name>


Upgrading
=========

To upgrade the Netris Controller simply run the script:

.. code-block:: shell-session

  curl -sfL https://get.netris.ai | sh -

If a new version of Netris Controller is available, it'll be updated in a few minutes.


Uninstalling
============

To uninstall Netris Controller and K3s from a server node, run:

.. code-block:: shell-session

  /usr/local/bin/k3s-uninstall.sh


Backup and Restore
==================

Netris Controller stores all critical data in MariaDB. It's highly recommended to create a cronjob with ``mysqldump``.


Backup
------

To take database snapshot run the following command:

.. code-block:: shell-session

  kubectl -n netris-controller exec -it netris-controller-mariadb-0 -- bash -c 'mysqldump -u $MARIADB_USER -p${MARIADB_PASSWORD} $MARIADB_DATABASE' > db-snapshot-$(date +%Y-%m-%d-%H-%M-%S).sql

After command execution, you can find ``db-snapshot-YYYY-MM-DD-HH-MM-SS.sql`` file in the current working directory.


Restore
-------

In order to restore DB from a snapshot, follow these steps:

*In this example the snapshot file name is db-snapshot.sql and it's located in the current working directory*

1. Copy snapshot file to the MariaDB container:

.. code-block:: shell-session

  kubectl -n netris-controller cp db-snapshot.sql netris-controller-mariadb-0:/opt/db-snapshot.sql

2. Run the restore command:

.. code-block:: shell-session

  kubectl -n netris-controller exec -it netris-controller-mariadb-0 -- bash -c 'mysql -u root -p${MARIADB_ROOT_PASSWORD} $MARIADB_DATABASE < /opt/db-snapshot.sql'

