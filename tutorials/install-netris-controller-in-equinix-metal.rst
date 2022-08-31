.. meta::
    :description: Installing a Netris Controller in Equinix Metal

================================================================
Installing a Netris Controller on Equinix Metal on-demand server
================================================================

Installation Steps
------------------

You can install the Netris controller almost on any 64-bit Linux host. You can use a single Netris controller for operating multiple sites (regions).

**Request a server**

The smallest flavor, c3.small.x86, is enough for most users. 

.. image:: images/equinix-request-c3-small-server.png
  :align: center

if you decide to use a VM, please see below the minimal VM requirements. 

* RAM: 8 GB
* CPU: 4 Cores
* Disk: 50GB
* OS: Linux 64-bit

**DNS record**

In my example my host got a public IP address 139.178.89.255. While it is OK for users and nodes to refer to the Netris Controller through an IP address, we recommend using a DNS record (this way it will be easier to potentially move Netris Controller somewhere with a different IP address). 

Below is example using Cloudflare DNS service. (same idea with any DNS software or service)

.. image:: images/dns-cloudflare-equinix-ip.png
    :align: center

Ensure that newly created domain name indeed resolves into the right IP address of the machine that you are going to install the Netris Controller.

.. code-block:: shell-session

   host netrisctl.netris.dev
   netrisctl.netris.dev has address 139.178.89.255

**Install Netris Controller software and dependencies**

.. code-block:: shell-session

  curl -sfL https://get.netris.ai | sh -s -- --ctl-hostname netris.example.com --ctl-ssl-issuer letsencrypt
  
.. note::
  Netris Controller installer will stand up a K3S cluster and then will deploy Netris Controller on top of it using Helm Chart.  The “--ctl-ssl-issuer” will instruct the installer to generate a Let’s Encrypt SSL certificate and the "--ctl-hostname" will hint for what domain name the certificate must be generated. That’s why it is important to create the DNS record before this step. Detailed info here: `doc <https://www.netris.ai/docs/en/stable/controller-k3s-installation.html>`_.

.. image:: images/netris-controller-installed.png
    :align: center


Once installation process is finished you will be able to access your newly installed Netris Controller web console using netris/newNet0ps credentials.


Security Matters
----------------

**Change the default password**

Setting → My Account → Change Password

.. image:: images/change-password.png
    :align: center
    
**Add new admin user**

Accounts → Users → +Add

.. image:: images/create-new-admin-user.png
    :align: center
    
