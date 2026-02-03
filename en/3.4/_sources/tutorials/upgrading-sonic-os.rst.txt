.. meta::
    :description: Upgrading SONiC OS

.. raw:: html

    <style> .green {color:#2fa84f} </style>
    <style> .red {color:red} </style>
  
.. role:: green

.. role:: red

**************************************
Upgrading SONiC Operating System
**************************************

Upgrade Procedure
=================

The SONiC OS image is being distributed by the Vendor of the switch, you need to obtain one via the support page of the vendor.
The image should be placed on a web server to which switch(es) have access.
In this example we will use a server with an IP address of *10.0.0.36*, the image is located in the */var/www/html/* folder, which is the root of the web server.

.. image:: /tutorials/images/upgrading_sonic_folder_listing.png
  :align: center

.. hint:: To make sure that the image is available as expected, please try to download the image with browser.

The upgrade process consists of the following steps:

1. Login to the switch and execute
   
.. code-block:: shell-session
   
  sudo sonic-installer install -y http://10.0.0.36/Edgecore-SONiC_20220929_052156_ec202012_420.bin

The process will take some time, after installation complete, reboot is mandatory.

.. warning:: 
  
  The installation will wipe all the data on the switch, including the admin user password, the authorized keys and ssh identity. After the reboot, a new ssh identity is generated. Because of that, you will be prompted with an identity mismatch message on the first login attempt. Please use your OS-specific procedure to remove the old key.

2. Login to the switch and verify that the OS version is updated

.. code-block:: shell-session
  
  admin@switch15:~$ show version

  SONiC Software Version: SONiC.Edgecore-SONiC_20220929_052156_ec202012_420
  Distribution: Debian 10.13
  Kernel: 4.19.0-12-2-amd64
  Build commit: 895d178f6
  Build date: Thu Sep 29 05:49:16 UTC 2022
  Built by: ubuntu@ip-10-5-1-225

  Platform: x86_64-accton_as7326_56x-r0
  HwSKU: Accton-AS7326-56X
  ASIC: broadcom
  ASIC Count: 1
  Serial Number: REDACTED
  Uptime: 00:06:00,  1 user,  load average: 1.39, 2.08, 2.29

3. Perform netris agent installation steps 2 to 4 from :ref:`"Install the Netris Agent"<switch-agent-installation-install-the-netris-agent>` tutorial.
