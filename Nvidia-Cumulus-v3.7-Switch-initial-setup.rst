============================
Nvidia Cumulus v3.7 Switch Initial Setup
============================
Requirements:
* Fresh install of Cumulus Linux v3.7.(x)

Configure the OOB Management IP address
***************************************
Configure internet connectivity via management port.

.. code-block:: shell-session

    sudo vim /etc/network/interfaces

.. code-block:: shell-session

 # The loopback network interface
 auto lo
 iface lo inet loopback
 
 # The primary network interface
 auto eth0
 iface eth0 inet static
         address <management IP address/prefix length>
         gateway <gateway of management network>
         dns-nameserver <dns server>
 
 source /etc/network/interfaces.d/*

.. code-block:: shell-session

 sudo ifreload -a

Configure Nvidia Cumulus Linux License
**************************************

.. code-block:: shell-session

 sudo cl-license -i

Copy/paste the Cumulus Linux license string then press ctrl-d.

Continue to :ref:`"Install the Netris Agent"<switch-agent-installation-install-the-netris-agent>` section.
