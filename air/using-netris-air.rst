==================================================
Netris Test Controller & Infrastructure Simulation
==================================================

This document provides general tips and tricks for using Netris in Netris' infrastructure simulation platform.

Once your Try & Learn through Netris Air platform is approved you will receive credentials for accessing a Netris controller with a trial license hosted in Netris Air.

Controller FQDN: example-ctl.netris.dev
Password: NetrisProvidedPassword


Web Console
===========

Navigate your browser to the Controller FQDN then use 
username: netris
password: <NetrisProvidedPassword>

SSH
===

Controller initialization modules and simulation control packages are installed on the Netris controller server.

Connect to the controller server using ssh. Username: ubuntu Password: <NetrisProvidedPassword>

.. code-block:: shell-session

ssh ubuntu@<Controller FQDN>


Netris Init Modules
===================

Netris init modules are designed to generate Inventory, IPAM, and Topology data based on simple arguments. Most init modules are written using Terraform/HCL. 

Netris test environment may come with a module that is relevant to your use case. If you can't find the right module for your use case, please contact your SA (Solutions Architect) 

Init modules are stored in the /home/ubuntu/netris-init/ directory.

Each module is stored in its own subdirectory. To use a module 'cd' to the appropriate subdirectory, review 'terraform.tfvars' file, make changes to the arguments if needed and save.

execute tofu-apply or tofu-destroy in the init module subdirectory to apply/destroy the Netris controller configuration.

Start/Stop a Simulation
=======================



