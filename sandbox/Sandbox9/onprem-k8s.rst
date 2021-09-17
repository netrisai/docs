.. _k8s:

**************************************************************
Run an On-Prem Kubernetes Cluster with Netris Automatic NetOps
**************************************************************


Intro
=====
This sandbox environment provides an existing Kubernetes cluster that has been deployed via `Kubespray <https://github.com/kubernetes-sigs/kubespray>`_. For this scenario, we will be using the `external LB <https://github.com/kubernetes-sigs/kubespray/blob/master/docs/ha-mode.md>`_ option in Kubespray. A dedicated Netris L4LB service has been created in each sandbox to access the k8s apiservers from users and non-master nodes sides.

.. image:: /images/sandbox9-l4lb-kubeapi.png
    :align: center

To access the built-in Kubernetes cluster, put "Kubeconfig" file which you received by the introductory email into your ``~/.kube/config`` or set "KUBECONFIG" environment variable ``export KUBECONFIG=~/Downloads/config`` on your local machine. After that try to connect to the k8s cluster:

.. code-block:: shell-session

  $ kubectl cluster-info

The output below means you’ve successfully connected to the sandbox cluster:

.. code-block:: shell-session

    Kubernetes master is running at https://api.k8s-sandbox9.netris.ai:6443

    To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

Install Netris-Operator
=======================

The first step to integrate the Netris controller with the Kubernetes API is to install the "netris-operator". Installation can be accomplished by installing regular manifests or a `helm chart <https://github.com/netrisai/netris-operator/tree/master/deploy/charts/netris-operator>`_.  For this example we will use the Kubernetes regular manifests:

1. Install the latest netris-operator:

.. code-block:: shell-session

  $ kubectl apply -f https://github.com/netrisai/netris-operator/releases/latest/download/netris-operator.yaml

2. Create credentials secret for netris-operator:

.. code-block:: shell-session

  $ kubectl -nnetris-operator create secret generic netris-creds \
  --from-literal=host='https://sandbox9.netris.ai/' \
  --from-literal=login='demo' --from-literal=password='Your Demo user pass'

3. Inspect the pod logs and make sure the operator is connected to netris-controller:

.. code-block:: shell-session

  $ kubectl -nnetris-operator logs -l netris-operator=controller-manager --all-containers -f

Example output demonstrating the successful operation of netris-operator:

.. code-block:: shell-session

  {"level":"info","ts":1629994653.6441543,"logger":"controller","msg":"Starting workers","reconcilerGroup":"k8s.netris.ai","reconcilerKind":"L4LB","controller":"l4lb","worker count":1}

.. note::
  
  After installing the netris-operator, your Kubernetes cluster and physical network control planes are connected. 
