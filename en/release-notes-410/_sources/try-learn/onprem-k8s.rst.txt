.. _s1-k8s:

***************************************
Learn Netris Operations with Kubernetes
***************************************

.. contents::
   :local:

Intro
=====
The Sandbox environment offers a pre-existing 3 node Kubernetes cluster deployed through K3S in `HA Mode <https://docs.k3s.io/datastore/ha-embedded>`_. To enable user access to the Kubernetes API, a dedicated Netris L4LB service has been created in the Sandbox Controller. Furthermore, this L4LB address serves as ``K3S_URL`` environment variable for all nodes within the cluster.

.. image:: /images/sandbox-l4lb-kubeapi.png
    :align: center
    :alt: Sandbox L4LB KubeAPI
    :target: ../../_images/sandbox-l4lb-kubeapi.png

To access the built-in Kubernetes cluster, put the "Kubeconfig" file which you received via the introductory email into your ``~/.kube/config`` or set "KUBECONFIG" environment variable using ``export KUBECONFIG=~/Downloads/config`` on your local machine. Afterwards, try to connect to the k8s cluster:

.. code-block:: shell-session

  kubectl cluster-info

If your output matches the one below, that means you've successfully connected to the Sandbox cluster:

.. code-block:: shell-session

  Kubernetes control plane is running at https://api.k8s-sandbox1.netris.io:6443
  CoreDNS is running at https://api.k8s-sandbox1.netris.io:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
  Metrics-server is running at https://api.k8s-sandbox1.netris.io:6443/api/v1/namespaces/kube-system/services/https:metrics-server:https/proxy

  To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

Install Netris Operator
=======================

The first step to integrate the Netris Controller with the Kubernetes API is to install the Netris Operator. Installation can be accomplished by installing a regular manifests or a `helm chart <https://github.com/netrisai/netris-operator/tree/master/deploy/charts/netris-operator>`_.  For this example we will use the Kubernetes regular manifests:

1. Install the latest Netris Operator:

.. code-block:: shell-session

  kubectl apply -f https://github.com/netrisai/netris-operator/releases/latest/download/netris-operator.yaml

2. Create credentials secret for Netris Operator:

.. code-block:: shell-session

  kubectl -nnetris-operator create secret generic netris-creds \
  --from-literal=host='https://sandbox1.netris.io' \
  --from-literal=login='demo' --from-literal=password='Your Demo user pass'

3. Inspect the pod logs and make sure the operator is connected to Netris Controller:

.. code-block:: shell-session

  kubectl -nnetris-operator logs -l netris-operator=controller-manager --all-containers -f

Example output demonstrating the successful operation of Netris Operator:

.. code-block:: shell-session

  {"level":"info","ts":1629994653.6441543,"logger":"controller","msg":"Starting workers","reconcilerGroup":"k8s.netris.ai","reconcilerKind":"L4LB","controller":"l4lb","worker count":1}

.. note::

  After installing the Netris Operator, your Kubernetes cluster and physical network control planes are connected.

Deploy an Application with an On-Demand Netris Load Balancer
============================================================

In this scenario we will be installing a simple application that requires a network load balancer:

Install the application `"Podinfo" <https://github.com/stefanprodan/podinfo>`_:

.. code-block:: shell-session

  kubectl apply -k github.com/stefanprodan/podinfo/kustomize

Get the list of pods and services in the default namespace:

.. code-block:: shell-session

  kubectl get po,svc

As you can see, the service type is "ClusterIP":

.. code-block:: shell-session

  NAME                           READY   STATUS    RESTARTS   AGE
  pod/podinfo-7cf557d9d7-6gfwx   1/1     Running   0          34s
  pod/podinfo-7cf557d9d7-nb2t7   1/1     Running   0          18s

  NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)             AGE
  service/kubernetes   ClusterIP   10.43.0.1      <none>        443/TCP             33m
  service/podinfo      ClusterIP   10.43.68.103   <none>        9898/TCP,9999/TCP   35s

In order to request access from outside, change the type to "LoadBalancer":

.. code-block:: shell-session

  kubectl patch svc podinfo -p '{"spec":{"type":"LoadBalancer"}}'

Check the services again:

.. code-block:: shell-session

  kubectl get svc

Now we can see that the service type has changed to LoadBalancer, and "EXTERNAL-IP" switched to pending state:

.. code-block:: shell-session

  NAME         TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                         AGE
  kubernetes   ClusterIP      10.43.0.1      <none>          443/TCP                         37m
  podinfo      LoadBalancer   10.43.68.103   <pending>       9898:32486/TCP,9999:30455/TCP   3m45s

Going into the Netris Controller web interface, navigate to **Services → L4 Load Balancer**, and you may see L4LBs provisioning in real-time. If you do not see the provisioning process it is likely because it already completed. Look for the service with the name **"podinfo-xxxxxxxx"**

.. image:: /images/sandbox-podinfo-prov.png
    :align: center
    :alt: Sandbox PodInfo Provisioning
    :target: ../../_images/sandbox-podinfo-prov.png

After provisioning has finished, let's one more time look at service in k8s:

.. code-block:: shell-session

  kubectl get svc

You can see that "EXTERNAL-IP" has been injected into Kubernetes:

.. code-block:: shell-session

  NAME         TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                         AGE
  kubernetes   ClusterIP      10.43.0.1      <none>          443/TCP                         29m
  podinfo      LoadBalancer   10.43.42.190   45.38.161.13   9898:30771/TCP,9999:30510/TCP   5m14s

Let's try to curl it (remember to replace the IP below with the IP that has been assigned in the previous command):

.. code-block:: shell-session

  curl 45.38.161.13:9898

The application is now accessible directly on the internet:

.. code-block:: json

  {
    "hostname": "podinfo-7cf557d9d7-6gfwx",
    "version": "6.6.0",
    "revision": "357009a86331a987811fefc11be1350058da33fc",
    "color": "#34577c",
    "logo": "https://raw.githubusercontent.com/stefanprodan/podinfo/gh-pages/cuddle_clap.gif",
    "message": "greetings from podinfo v6.6.0",
    "goos": "linux",
    "goarch": "amd64",
    "runtime": "go1.21.7",
    "num_goroutine": "8",
    "num_cpu": "2"
  }

As seen, "PodInfo" developers decided to expose 9898 port for HTTP, let's switch it to 80:

.. code-block:: shell-session

  kubectl patch svc podinfo --type='json' -p='[{"op": "replace", "path": "/spec/ports/0/port", "value":80}]'

Wait a few seconds, you can see the provisioning process on the controller:

.. image:: /images/sandbox-podinfo-ready.png
    :align: center
    :alt: Sandbox PodInfo Ready
    :target: ../../_images/sandbox-podinfo-ready.png

Curl again, without specifying a port:

.. code-block:: shell-session

  curl 45.38.161.13

The output is similar to this:

.. code-block:: json

  {
    "hostname": "podinfo-7cf557d9d7-6gfwx",
    "version": "6.6.0",
    "revision": "357009a86331a987811fefc11be1350058da33fc",
    "color": "#34577c",
    "logo": "https://raw.githubusercontent.com/stefanprodan/podinfo/gh-pages/cuddle_clap.gif",
    "message": "greetings from podinfo v6.6.0",
    "goos": "linux",
    "goarch": "amd64",
    "runtime": "go1.21.7",
    "num_goroutine": "8",
    "num_cpu": "2"
  }

You can also verify the application is reachable by putting this IP address directly into your browser.

.. topic:: Milestone 1

  Congratulations!  You successfully deployed a network load balancer and exposed an application from your cloud to the internet.  Time to get yourself an iced coffee.


Using Netris Custom Resources
=============================

Introduction to Netris Custom Resources
---------------------------------------

In addition to provisioning on-demand network load balancers, Netris Operator can also provide automatic creation of network services based on Kubernetes CRD objects. Let's take a look at a few common examples:

L4LB Custom Resource
--------------------

In the previous section, when we changed the service type from "ClusterIP" to "LoadBalancer", Netris Operator detected a new request for a network load balancer, then it created L4LB custom resources. Let's see them:

.. code-block:: shell-session

  kubectl get l4lb

As you can see, there are two L4LB resources, one for each podinfo's service port:

.. code-block:: shell-session

  NAME                                                            STATE    FRONTEND        PORT       SITE     TENANT   STATUS   AGE
  podinfo-default-5bdf0a53-027d-449f-8896-547e06028c6b-tcp-80     active   45.38.161.13   80/TCP     US/NYC   Admin    OK       7m21s
  podinfo-default-5bdf0a53-027d-449f-8896-547e06028c6b-tcp-9999   active   45.38.161.13   9999/TCP   US/NYC   Admin    OK       15m

You can't edit/delete them, because Netris Operator will recreate them based on what was originally deployed in the service specifications.

Instead, let's create a new load balancer using the CRD method.  This method allows us to create L4 load balancers for services outside of what is being created natively with the Kubernetes service schema.  Our new L4LB's backends will be "srv04-nyc" & "srv05-nyc" on TCP port 80. These servers are already running the Nginx web server, with the hostname present in the index.html file.

Create a yaml file:

.. code-block:: shell-session

  cat << EOF > srv04-5-nyc-http.yaml
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
     - 192.168.45.64:80
     - 192.168.46.65:80
   check:
     type: tcp
     timeout: 3000
  EOF

And apply it:

.. code-block:: shell-session

  kubectl apply -f srv04-5-nyc-http.yaml

Inspect the new L4LB resources via kubectl:

.. code-block:: shell-session

  kubectl get l4lb

As you can see, provisioning started:

.. code-block:: shell-session

  NAME                                                            STATE    FRONTEND        PORT       SITE     TENANT   STATUS         AGE
  podinfo-default-5bdf0a53-027d-449f-8896-547e06028c6b-tcp-80     active   45.38.161.13   80/TCP     US/NYC   Admin    OK             9m56s
  podinfo-default-5bdf0a53-027d-449f-8896-547e06028c6b-tcp-9999   active   45.38.161.13   9999/TCP   US/NYC   Admin    OK             17m
  srv04-5-nyc-http                                                active   45.38.161.14   80/TCP     US/NYC   Admin    Provisioning   5s

When provisioning is finished, you should be able to connect to L4LB. Try to curl, using the L4LB frontend address displayed in the above command output:

.. code-block:: shell-session

  curl 45.38.161.14

You will see the servers' hostname in curl output:

.. code-block:: shell-session

  SRV04-NYC

You can also inspect the L4LB in the Netris Controller web interface:

.. image:: /images/sandbox-l4lbs.png
    :align: center
    :alt: Sandbox L4LBs
    :target: ../../_images/sandbox-l4lbs.png

Importing Existing Resources from Netris Controller to Kubernetes
-----------------------------------------------------------------

 You can import any custom resources already created from the Netris Controller to k8s by adding the following annotation:

.. code-block:: yaml

  resource.k8s.netris.ai/import: "true"

Otherwise, if try to apply them without the "import" annotation, the Netris Operator will complain that the resource with such name or specs already exists.

After importing resources to k8s, they will belong to the Netris Operator, and you won't be able to edit/delete them directly from the Netris Controller web interface, because the Netris Operator will put everything back, as declared in the custom resources.

Reclaim Policy
--------------

There is also one useful annotation. So suppose you want to remove some custom resource from k8s, and want to prevent its deletion from the Netris Controller, for that you can use "reclaimPolicy" annotation:

.. code-block:: yaml

  resource.k8s.netris.ai/reclaimPolicy: "retain"

Just add this annotation in any custom resource while creating it. Or if the custom resource has already been created, change the ``"delete"`` value to ``"retain"`` for key ``resource.k8s.netris.ai/reclaimPolicy`` in the resource annotation. After that, you'll be able to delete any Netris Custom Resource from Kubernetes, and it won't be deleted from the Netris Controller.

.. seealso::

  See all options and examples for Netris Custom Resources `here <https://github.com/netrisai/netris-operator/tree/master/samples>`_.

.. topic:: Milestone 2

  Congratulations on completing Milestone 2!
