.. _s8-k8s:

**************************************************************
Run an On-Prem Kubernetes Cluster with Netris Automatic NetOps
**************************************************************


Intro
=====
This sandbox environment provides an existing Kubernetes cluster that has been deployed via `Kubespray <https://github.com/kubernetes-sigs/kubespray>`_. For this scenario, we will be using the `external LB <https://github.com/kubernetes-sigs/kubespray/blob/master/docs/ha-mode.md>`_ option in Kubespray. A dedicated Netris L4LB service has been created in each sandbox to access the k8s apiservers from users and non-master nodes sides.

.. image:: /images/sandbox8-l4lb-kubeapi.png
    :align: center

To access the built-in Kubernetes cluster, put "Kubeconfig" file which you received by the introductory email into your ``~/.kube/config`` or set "KUBECONFIG" environment variable ``export KUBECONFIG=~/Downloads/config`` on your local machine. After that try to connect to the k8s cluster:

.. code-block:: shell-session

  $ kubectl cluster-info

The output below means you’ve successfully connected to the sandbox cluster:

.. code-block:: shell-session

    Kubernetes master is running at https://api.k8s-sandbox8.netris.ai:6443

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
  --from-literal=host='https://sandbox8.netris.ai/' \
  --from-literal=login='demo' --from-literal=password='Your Demo user pass'

3. Inspect the pod logs and make sure the operator is connected to netris-controller:

.. code-block:: shell-session

  $ kubectl -nnetris-operator logs -l netris-operator=controller-manager --all-containers -f

Example output demonstrating the successful operation of netris-operator:

.. code-block:: shell-session

  {"level":"info","ts":1629994653.6441543,"logger":"controller","msg":"Starting workers","reconcilerGroup":"k8s.netris.ai","reconcilerKind":"L4LB","controller":"l4lb","worker count":1}

.. note::
  
  After installing the netris-operator, your Kubernetes cluster and physical network control planes are connected. 

Deploy an Application with an On-Demand Netris Load Balancer
============================================================

In this scenario we will be installing a simple application that requires a network load balancer: 

Install the application `"Podinfo" <https://github.com/stefanprodan/podinfo>`_:

.. code-block:: shell-session

  $ kubectl apply -k github.com/stefanprodan/podinfo/kustomize

Get the list of pods and services in the default namespace:

.. code-block:: shell-session

  $ kubectl get po,svc

As you can see, the service type is ‘ClusterIP’:

.. code-block:: shell-session

  NAME                           READY   STATUS    RESTARTS   AGE
  pod/podinfo-576d5bf6bd-7z9jl   1/1     Running   0          49s
  pod/podinfo-576d5bf6bd-nhlmh   1/1     Running   0          33s
  
  NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
  service/podinfo      ClusterIP   172.21.65.106   <none>        9898/TCP,9999/TCP   50s

In order to request access from outside, change the type to ‘LoadBalancer’:

.. code-block:: shell-session

  $ kubectl patch svc podinfo -p '{"spec":{"type":"LoadBalancer"}}'

Check the services again:

.. code-block:: shell-session

  $ kubectl get svc

Now we can see that the service type changed to LoadBalancer, and “EXTERNAL-IP” switched to pending state:

.. code-block:: shell-session

   NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                         AGE
   podinfo      LoadBalancer   172.21.65.106   <pending>     9898:32584/TCP,9999:30365/TCP   8m57s

Going into the netris-controller web interface, navigate to **Services / L4 Load Balancer**, and you may see L4LBs provisioning in real-time. If you do not see the provisioning process it is likely because it already completed. Look for the service with the name **“podinfo-xxxxxxxx”**

.. image:: /images/sandbox8-podinfo-prov.png
    :align: center

After provisioning has finished, let’s one more time look at service in k8s:

.. code-block:: shell-session

  $ kubectl get svc

You can see that “EXTERNAL-IP” has been injected into Kubernetes:

.. code-block:: shell-session
  
  NAME         TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)                         AGE
  podinfo      LoadBalancer   172.21.65.106   50.117.59.202   9898:32584/TCP,9999:30365/TCP   9m17s

Let’s try to curl it (remember to replace the IP below with the IP that has been assigned in the previous command):

.. code-block:: shell-session

  $ curl 50.117.59.202:9898

The application is now accessible directly on the internet:

.. code-block:: json
  
  {
   "hostname": "podinfo-576d5bf6bd-nhlmh",
   "version": "6.0.0",
   "revision": "",
   "color": "#34577c",
   "logo": "https://raw.githubusercontent.com/stefanprodan/podinfo/gh-pages/cuddle_clap.gif",
   "message": "greetings from podinfo v6.0.0",
   "goos": "linux",
   "goarch": "amd64",
   "runtime": "go1.16.5",
   "num_goroutine": "8",
   "num_cpu": "4"
  }

As seen, "PodInfo" developers decided to expose 9898 port for HTTP, let’s switch it to 80:

.. code-block:: shell-session

  $ kubectl patch svc podinfo --type='json' -p='[{"op": "replace", "path": "/spec/ports/0/port", "value":80}]'

Wait a few seconds, you can see the provisioning process on the controller:

.. image:: /images/sandbox8-podinfo-ready.png
    :align: center

Curl again, without specifying a port:

.. code-block:: shell-session

  $ curl 50.117.59.202

The output is similar to this:

.. code-block:: json
  
  {
   "hostname": "podinfo-576d5bf6bd-nhlmh",
   "version": "6.0.0",
   "revision": "",
   "color": "#34577c",
   "logo": "https://raw.githubusercontent.com/stefanprodan/podinfo/gh-pages/cuddle_clap.gif",
   "message": "greetings from podinfo v6.0.0",
   "goos": "linux",
   "goarch": "amd64",
   "runtime": "go1.16.5",
   "num_goroutine": "8",
   "num_cpu": "4"
  }

You can also verify the application is reachable by putting this IP address directly into your browser.

.. topic:: Milestone 1

  Congratulations!  You successfully deployed a network load balancer and exposed an application from your cloud to the internet.  Time to get yourself an iced coffee.


Using Netris Custom Resources
=============================

Introduction to Netris Custom Resources
---------------------------------------

In addition to provisioning on-demand network load balancers, Netris-Operator can also provide automatic creation of network services based on Kubernetes CRD objects. Let’s take a look at a few common examples:

L4LB Custom Resource
--------------------

In the previous section, when we changed the service type from “ClusterIP” to “LoadBalancer”, Netris-Operator detected a new request for a network load balancer, then it created L4LB custom resources. Let’s see them:

.. code-block:: shell-session

  $ kubectl get l4lb

As you can see, there are two L4LB resources, one for each podinfo’s service port:

.. code-block:: shell-session

  NAME                                                            STATE    FRONTEND        PORT       SITE     TENANT   STATUS   AGE
  podinfo-default-66d44feb-0278-412a-a32d-73afe011f2c6-tcp-80     active   50.117.59.202   80/TCP     US/NYC   Admin    OK       33m
  podinfo-default-66d44feb-0278-412a-a32d-73afe011f2c6-tcp-9999   active   50.117.59.202   9999/TCP   US/NYC   Admin    OK       32m

You can’t edit/delete them, because Netris-Operator will recreate them based on what was originally deployed in the service specifications.
Instead, let’s create a new load balancer using the CRD method.
Our new L4LB’s backends will be “srv04-nyc” & “srv05-nyc” on TCP port 80. These servers are already running the Nginx web server, with the hostname present in the index.html file.
Create a yaml file:

.. code-block:: shell-session

  $ cat << EOF > srv04-5-nyc-http.yaml
  apiVersion: k8s.netris.ai/v1alpha1
  kind: L4LB
  metadata:
   name: srv04-5-nyc-http
  spec:
   ownerTenant: Admin
   site: US/NYC
   state: active
   protocol: tcp
   frontend:
     port: 80
   backend:
     - 192.168.41.64:80
     - 192.168.42.65:80
   check:
     type: tcp
     timeout: 3000
  EOF

And apply it:

.. code-block:: shell-session

  $ kubectl apply -f srv04-5-nyc-http.yaml

Inspect the new L4LB resources via kubectl:

.. code-block:: shell-session

  $ kubectl get l4lb

As you can see, provisioning started:

.. code-block:: shell-session

  NAME                                                            STATE    FRONTEND        PORT       SITE     TENANT   STATUS         AGE
  podinfo-default-d07acd0f-51ea-429a-89dd-8e4c1d6d0a86-tcp-80     active   50.117.59.202   80/TCP     US/NYC   Admin    OK             2m17s
  podinfo-default-d07acd0f-51ea-429a-89dd-8e4c1d6d0a86-tcp-9999   active   50.117.59.202   9999/TCP   US/NYC   Admin    OK             3m47s
  srv04-5-nyc-http                                                active   50.117.59.203   80/TCP     US/NYC   Admin    Provisioning   6s

When provisioning is finished, you should be able to connect to L4LB. Try to curl, using the L4LB frontend address displayed in the above command output:

.. code-block:: shell-session

  $ curl 50.117.59.203

You will see the servers’ hostname in curl output:

.. code-block:: shell-session

  SRV04-NYC

You can also inspect the L4LB in the Netris controller web interface:

.. image:: /images/sandbox8-l4lbs.png
    :align: center

VNET Custom Resource
--------------------

If you see the same as shown in the previous screenshot, it means you didn’t create "vnet-customer" VNet as stated in the :ref:`"Learn by Creating Services"<s8-v-net>` manual. If so, let’s create it from Kubernetes using the VNet custom resource.

Let’s create our vnet manifest:

.. code-block:: shell-session

  $ cat << EOF > vnet-customer.yaml
  apiVersion: k8s.netris.ai/v1alpha1
  kind: VNet
  metadata:
   name: vnet-customer
  spec:
   ownerTenant: Admin
   guestTenants: []
   sites:
     - name: US/NYC
       gateways:
         - 192.168.42.1/24
       switchPorts:
         - name: swp2@sw22-nyc
  EOF

And apply it:

.. code-block:: shell-session

  $ kubectl apply -f vnet-customer.yaml

Let’s check our vnet resources in Kubernetes:

.. code-block:: shell-session

  $ kubectl get vnet

As you can see, provisioning for our new VNet has started:

.. code-block:: shell-session

  NAME            STATE    GATEWAYS          SITES    OWNER   STATUS         AGE
  vnet-customer   active   192.168.42.1/24   US/NYC   Admin   Provisioning   7s

After provisioning has completed, the L4LB’s checks should work for both backend servers, and incoming requests should be balanced between them. 

Let’s curl several times to see that:

.. code-block:: shell-session

  $ curl 50.117.59.203

As we can see, the curl request shows the behavior of ‘round robin’ between the backends:

.. code-block:: shell-session

  SRV05-NYC
  ❯ curl 50.117.59.203
  
  SRV05-NYC
  ❯ curl 50.117.59.203
  
  SRV05-NYC
  ❯ curl 50.117.59.203
  
  SRV04-NYC

.. seealso::

  *If intermittently the result of the curl command is "Connection timed out", it is likely that the request went to the srv05-nyc backend, and the “Default ACL Policy” is set to “Deny“. To remedy this configure an ACL entry that will allow the srv05-nyc server to communicate with the world. For step-by-step instruction review the* :ref:`ACL documentation<s8-v-net>`.

BTW, if you already created "vnet-customer" Vnet as stated in the :ref:`"Learn by Creating Services"<s8-v-net>`, you may import that to k8s, by adding ``resource.k8s.netris.ai/import: "true"`` annotation in vnet manifest, the manifest should look like this:

.. code-block:: shell-session

  $ cat << EOF > vnet-customer.yaml
  apiVersion: k8s.netris.ai/v1alpha1
  kind: VNet
  metadata:
   name: vnet-customer
   annotations:
     resource.k8s.netris.ai/import: "true"
  spec:
   ownerTenant: Admin
   guestTenants: []
   sites:
     - name: US/NYC
       gateways:
         - 192.168.42.1/24
       switchPorts:
         - name: swp2@sw22-nyc
  EOF

After applying the manifest containing "import" annotation, the vnet, created from the netris-controller web interface, will appear in k8s and you will be able to manage it from Kubernetes.

BGP Custom Resource
-------------------
