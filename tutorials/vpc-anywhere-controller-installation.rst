.. meta::
    :description: Installing a Netris Controller

==============================
Installing a Netris Controller
==============================

You can install the Netris controller almost on any 64-bit Linux host. Netris Controller may or may not be on the same network as the managed network nodes are. In fact if there are multiple Netris managed deployments there’s no need for an individual controller for each deployment.

It doesn’t matter where to host the Netris controller. What matters is that the Netris controller needs to be accessible over the Internet. 1) So you can access the web console. 2) Nodes that are going to be managed by Netris need to have access to the Netris controller through their management network interface. 

Linux Host requirements

* RAM: 8 GB
* CPU: 4 Cores
* Disk: 50GB
* OS: Linux 64-bit

In this example my host has got a public IP address 54.219.211.71. While it is OK for users and nodes to refer to the Netris Controller through an IP address, I like using a DNS record (this way it will be easier to potentially move Netris Controller somewhere with a different IP address). 

I’m using Cloudflare to create this “example-netris-controller.netris.dev” DNS record to point to the public IP address of my host : 54.219.211.71. 

.. image:: images/cloudflare-dns-record.png
    :align: center

Ensure that newly created domain name indeed resolves into the right IP address of the machine that you are going to install the Netris Controller.

To install Netris Controller on a freshly installed Linux you only need to run below one-liner command. Netris Controller installer will stand up a K3S cluster and then will deploy Netris Controller on top of it using Helm Chart.  The “--ctl-ssl-issuer” will instruct the installer to generate a Let’s Encrypt SSL certificate and the "--ctl-hostname" will hint for what domain name the certificate must be generated. That’s why it is important to create the DNS record before this step. For more details, get familiar with the controller installation `doc <https://www.netris.ai/docs/en/stable/controller-k3s-installation.html>`_.

.. code-block:: shell-session

  curl -sfL https://get.netris.ai | sh -s -- --ctl-hostname netris.example.com --ctl-ssl-issuer letsencrypt
  
Once installation process is finished you will be able to access your newly installed Netris Controller web console using netris/newNet0ps credentials.

Please immediately change the default password to something strong in Setting → My Account → Change Password. 
You can also use Settings → Login whitelist to restrict web console access to the controller. 
