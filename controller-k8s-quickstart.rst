.. meta::
  :description: Controller Quickstart

***********************
Quickstart Installation
***********************

Netris offers a simplified deployment model for users who want to quickly install the Netris Controller in the shortest amount of time.

**This installation process is streamlined for Linux servers that do not already have Kubernetes running.**  The install does the following:

* Installs `k3s <https://k3s.io/>`_
* Installs the `Netris Controller Helm chart <https://www.netris.ai/docs/en/stable/controller-k8s-installation.html>`_

If you wish to install the controller on an existing Kubernetes cluster, follow `these instructions <https://www.netris.ai/docs/en/stable/controller-k8s-installation.html>`_ instead of this Quickstart.

Quickstart Process
------------------

1. Install the Netris Controller w/ k3s by running the following command on your Linux server:

.. code-block:: shell-session

    curl -sfL https://get.netris.ai | sh -

2. When the installation completes, you will be provided with the login for the web UI.  Login with the provided credentials.

3. Navigate in the UI to  Net→IPAM and add a new subnet that contains the desired management IP addresses you wish to use for your SoftGates and switches.

   For example, if you are planning on using 192.168.1.100 as the IP address of your Ubuntu server, then create a subnet in Netris UI for 192.168.1.0/24.

   Detailed configuration documentation is available here: `Netris IPAM <https://www.netris.ai/docs/en/stable/ipam.html>`_.

4. Navigate in the UI to **Topology**
5. Click the **Add** in the upper right
6. Fill out the fields for the SoftGate you wish to add
7. Select the proper **Management IP address** from the subnet selector
8. Once the SoftGate is created in the Topology, **right-click** on the SoftGate and select the **Install Agent** option
9. Copy the agent install command to your clipboard and run the command on the Ubuntu server you are using as your SoftGate
10. Congratulations.  The SoftGate should now be connected to your controller.

