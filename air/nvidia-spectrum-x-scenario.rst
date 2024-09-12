======================================================================
Scenario: GPU-as-a-Service network with NVIDIA Spectrum-X architecture
======================================================================

Initialize the Netris controller
================================

Start with a blank Netris Controller. SSH to the Netris controller server and ``cd /home/ubuntu/netris-init/netris-spectrum-x-init``.

Optionally Edit ``terraform.tfvars`` file to set cluster scale parameters.

Below, we describe the role of a few parameters that directly define the scale. The description of the rest of the parameters is available in the ``terraform.tfvars`` file itself. For the purpose of this try & learn scenario, there is no need to change the other parameters.

The east-west switch fabric is responsible for high performance data transmission between GPU servers. It rail-optimized design allows to non-blocking max-rate data transmission between any GPUs on the network. You only need to define the number of GPU servers in the ``terraform.tfvars`` file. When you execute the initialization module, it will automatically calculate the proper number of links and will generate the rail-optimized blueprint in the Netris controller according to the NVIDIA Spectrum-X guidelines.
* Define GPU (HGX/DGX) servers count by setting ``gpu-server-count`` to increments of 32 (1 SU = 32 servers, 2 SUs = 64 servers, etc.)

The north-south switch fabric is responsible for everything else - for connectivity from the outside, to manage the GPU nodes and run workloads. OOB management switches are responsible for out-of-band management of the network switches and GPU servers. OOB management is also used in production for PXE booting the GPU servers. In this simulation scenario, GPU servers will be booted by means of the Netris infrastructure simulation platform for your conveninece of teasting and learning.

* Define ``leaf-count`` - the rule of thumb is that at least 1/4th of the number of SUs - so 4 leaf switches can handle up to 4 SUs
* Define ``oob-leaf-count`` - Should be equal to the number of SUs.
* Define ``spine-count`` - Typically 2, although other values are welcome.

Save the changes and exit.

Execute ``tofu-apply`` or ``tofu-destroy`` to insert/clean up relevant declarations into the Netris controller.

Navigate to the Netris controller in your web browser to see the results.

Start a simulation
==================

Check ``Inventory``, ``IPAM``, and ``Topology`` sections under ``Network`` menu in the Netris controller web console. (In the topology section, you may need to select the right site to see a diagram)

Go back to the SSH session and cd to ``/home/ubuntu/netris-air``

Execute pulumi up or pulumi destroy to start/stop a simulation of what’s described in the Netris Controller.

Once simulation creation is done, go back to the Netris web console and wait up to 5 minutes for the infrastructure to come up. You can monitor the status of the network either from the dashboard (click on the Netris icon in the top left corner) or from the Topology section.
