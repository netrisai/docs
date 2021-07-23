
.. meta::
  :description: Netris Controller Installation on Kubernetes

Netris Controller Helm Chart
============================


* Installs the automatic NetOps platform `Netris Controller <https://www.netris.ai/overview/>`_

Prerequisites
-------------


* Kubernetes 1.12+
* Helm 3.1+
* PV provisioner support in the underlying infrastructure

Get Repo Info
-------------

Add the Netris Helm repository:

.. code-block::

   helm repo add netrisai https://netrisai.github.io/charts
   helm repo update

Installing the Chart
--------------------

In order to install the Helm chart, you must follow these steps:

Create the namespace for netris-controller:

.. code-block::

   kubectl create namespace netris-controller

Generate strong auth key

.. code-block::

   export mystrongauthkey=$(date |base64 | md5sum | base64 | head -c 32)

Install helm chart with netris-controller

.. code-block::

   helm install netris-controller netrisai/netris-controller \
     --namespace netris-controller \
     --set app.ingress.hosts={my.domain.com} \
     --set netris.authKey=$mystrongauthkey

Uninstalling the Chart
----------------------

To uninstall/delete the ``netris-controller`` helm release:

.. code-block::

   helm uninstall netris-controller

Configuration
-------------

The following table lists the configurable parameters of the netris-controller chart and their default values.

Common parameters
^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - ``nameOverride``
     - String to partially override common.names.fullname template with a string (will prepend the release name)
     - ``nil``
   * - ``fullnameOverride``
     - String to fully override common.names.fullname template with a string
     - ``nil``
   * - ``serviceAccount.create``
     - Create a serviceAccount for the deployment
     - ``true``
   * - ``serviceAccount.name``
     - Use the serviceAccount with the specified name
     - ``""``
   * - ``serviceAccount.annotations``
     - Annotations to add to the service account
     - ``{}``
   * - ``podAnnotations``
     - Pod annotations
     - ``{}``
   * - ``podSecurityContext``
     - Pod Security Context
     - ``{}``
   * - ``securityContext``
     - Containers security context
     - ``{}``
   * - ``resources``
     - CPU/memory resource requests/limits
     - ``{}``
   * - ``nodeSelector``
     - Node labels for pod assignment
     - ``{}``
   * - ``tolerations``
     - Node tolerations for pod assignment
     - ``[]``
   * - ``affinity``
     - Node affinity for pod assignment
     - ``{}``


Netris-Controller common parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - ``netris.webLogin``
     - Netris Controller GUI default login
     - ``netris``
   * - ``netris.webPassword``
     - Netris Controller GUI default password
     - ``newNet0ps``
   * - ``netris.authKey``
     - Netris Controller agents authentication key
     - ``mystrongkey``


Netris-Controller app parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - ``app.replicaCount``
     - Number of replicas in app deployment
     - ``1``
   * - ``app.image.repository``
     - Image repository
     - ``netrisai/xcaas-xcaas-web``
   * - ``app.image.tag``
     - Image tag. Overrides the image tag whose default is the chart appVersion
     - ``""``
   * - ``app.image.pullPolicy``
     - Image pull policy
     - ``IfNotPresent``
   * - ``app.imagePullSecrets``
     - Reference to one or more secrets to be used when pulling images
     - ``[]``
   * - ``app.service.type``
     - Kubernetes service type
     - ``ClusterIP``
   * - ``app.service.port``
     - Kubernetes port where service is expose
     - ``80``
   * - ``app.service.portName``
     - Name of the port on the service
     - ``http``
   * - ``app.ingress.enabled``
     - Enables Ingress
     - ``true``
   * - ``app.ingress.annotations``
     - Ingress annotations (values are templated)
     - ``{ kubernetes.io/ingress.class: nginx }``
   * - ``app.ingress.labels``
     - Custom labels
     - ``{}``
   * - ``app.ingress.path``
     - Ingress accepted path
     - ``/``
   * - ``app.ingress.pathType``
     - Ingress type of path
     - ``Prefix``
   * - ``app.ingress.hosts``
     - Ingress accepted hostnames
     - ``["chart-example.local"]``
   * - ``app.ingress.tls``
     - Ingress TLS configuration
     - ``[]``
   * - ``app.autoscaling.enabled``
     - Option to turn autoscaling on for app and specify params for HPA. Autoscaling needs metrics-server to access cpu metrics
     - ``false``
   * - ``app.autoscaling.minReplicas``
     - Default min replicas for autoscaling
     - ``1``
   * - ``app.autoscaling.maxReplicas``
     - Default max replicas for autoscaling
     - ``100``
   * - ``app.autoscaling.targetCPUUtilizationPercentage``
     - The desired target CPU utilization for autoscaling
     - ``80``


Netris-Controller grpc parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - ``grpc.replicaCount``
     - Number of replicas in grpc deployment
     - ``1``
   * - ``grpc.image.repository``
     - Image repository
     - ``netrisai/xcaas-agent-api-server``
   * - ``grpc.image.tag``
     - Image tag. Overrides the image tag whose default is the chart appVersion
     - ``""``
   * - ``grpc.image.pullPolicy``
     - Image pull policy
     - ``IfNotPresent``
   * - ``grpc.imagePullSecrets``
     - Reference to one or more secrets to be used when pulling images
     - ``[]``
   * - ``grpc.service.type``
     - Kubernetes service type
     - ``ClusterIP``
   * - ``grpc.service.port``
     - Kubernetes port where service is expose
     - ``443``
   * - ``grpc.service.portName``
     - Name of the port on the service
     - ``grpc``
   * - ``grpc.autoscaling.enabled``
     - Option to turn autoscaling on for app and specify params for HPA. Autoscaling needs metrics-server to access cpu metrics
     - ``false``
   * - ``grpc.autoscaling.minReplicas``
     - Default min replicas for autoscaling
     - ``1``
   * - ``grpc.autoscaling.maxReplicas``
     - Default max replicas for autoscaling
     - ``100``
   * - ``grpc.autoscaling.targetCPUUtilizationPercentage``
     - The desired target CPU utilization for autoscaling
     - ``80``


Netris-Controller telescope parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - ``telescope.replicaCount``
     - Number of replicas in telescope deployment
     - ``1``
   * - ``telescope.image.repository``
     - Image repository
     - ``netrisai/xcaas-telescope-go``
   * - ``telescope.image.tag``
     - Image tag. Overrides the image tag whose default is the chart appVersion
     - ``""``
   * - ``telescope.image.pullPolicy``
     - Image pull policy
     - ``IfNotPresent``
   * - ``telescope.imagePullSecrets``
     - Reference to one or more secrets to be used when pulling images
     - ``[]``
   * - ``telescope.service.type``
     - Kubernetes service type
     - ``ClusterIP``
   * - ``telescope.service.port``
     - Kubernetes port where service is expose
     - ``80``
   * - ``telescope.service.portName``
     - Name of the port on the service
     - ``ws``
   * - ``telescope.service.securePort``
     - Kubernetes secure port where service is expose
     - ``443``
   * - ``telescope.service.securePortName``
     - Name of the secure port on the service
     - ``wss``
   * - ``telescope.autoscaling.enabled``
     - Option to turn autoscaling on for app and specify params for HPA. Autoscaling needs metrics-server to access cpu metrics
     - ``false``
   * - ``telescope.autoscaling.minReplicas``
     - Default min replicas for autoscaling
     - ``1``
   * - ``telescope.autoscaling.maxReplicas``
     - Default max replicas for autoscaling
     - ``100``
   * - ``telescope.autoscaling.targetCPUUtilizationPercentage``
     - The desired target CPU utilization for autoscaling
     - ``80``


Netris-Controller k8s-watcher parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - ``k8s-watcher.replicaCount``
     - Number of replicas in k8s-watcher deployment
     - ``1``
   * - ``k8s-watcher.image.repository``
     - Image repository
     - ``netrisai/xcaas-kuberis-k8-api-agent``
   * - ``k8s-watcher.image.tag``
     - Image tag. Overrides the image tag whose default is the chart appVersion
     - ``""``
   * - ``k8s-watcher.image.pullPolicy``
     - Image pull policy
     - ``IfNotPresent``
   * - ``k8s-watcher.imagePullSecrets``
     - Reference to one or more secrets to be used when pulling images
     - ``[]``
   * - ``k8s-watcher.autoscaling.enabled``
     - Option to turn autoscaling on for app and specify params for HPA. Autoscaling needs metrics-server to access cpu metrics
     - ``false``
   * - ``k8s-watcher.autoscaling.minReplicas``
     - Default min replicas for autoscaling
     - ``1``
   * - ``k8s-watcher.autoscaling.maxReplicas``
     - Default max replicas for autoscaling
     - ``100``
   * - ``k8s-watcher.autoscaling.targetCPUUtilizationPercentage``
     - The desired target CPU utilization for autoscaling
     - ``80``


Netris-Controller telescope-notifier parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - ``telescope-notifier.replicaCount``
     - Number of replicas in telescope-notifier deployment
     - ``1``
   * - ``telescope-notifier.image.repository``
     - Image repository
     - ``netrisai/xcaas-xcaas-notifier``
   * - ``telescope-notifier.image.tag``
     - Image tag. Overrides the image tag whose default is the chart appVersion
     - ``""``
   * - ``telescope-notifier.image.pullPolicy``
     - Image pull policy
     - ``IfNotPresent``
   * - ``telescope-notifier.imagePullSecrets``
     - Reference to one or more secrets to be used when pulling images
     - ``[]``
   * - ``telescope-notifier.autoscaling.enabled``
     - Option to turn autoscaling on for app and specify params for HPA. Autoscaling needs metrics-server to access cpu metrics
     - ``false``
   * - ``telescope-notifier.autoscaling.minReplicas``
     - Default min replicas for autoscaling
     - ``1``
   * - ``telescope-notifier.autoscaling.maxReplicas``
     - Default max replicas for autoscaling
     - ``100``
   * - ``telescope-notifier.autoscaling.targetCPUUtilizationPercentage``
     - The desired target CPU utilization for autoscaling
     - ``80``


Mariadb parameters
^^^^^^^^^^^^^^^^^^

*Using default values* `from <https://github.com/bitnami/charts/tree/master/bitnami/mariadb/values.yaml>`_

.. list-table::
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - ``mariadb.image.repository``
     - MariaDB image name. We extended bitnami's mariadb image with own plugin
     - ``netrisai/netris-mariadb``
   * - ``mariadb.image.tag``
     - MariaDB image tag. (only 10.1 is supported)
     - ``10.1``
   * - ``mariadb.initdbScriptsConfigMap``
     - ConfigMap with the initdb scripts.
     - ``netris-controller-initdb``
   * - ``mariadb.auth.database``
     - Name for a database to create
     - ``netris``
   * - ``mariadb.auth.username``
     - Name for a user to create
     - ``netris``
   * - ``mariadb.auth.password``
     - Password for the new user
     - ``changeme``
   * - ``mariadb.auth.rootPassword``
     - Password for the root user
     - ``changeme``


*Auth from existing secret not supported at the momment*

Mongodb parameters
^^^^^^^^^^^^^^^^^^

*Using default values* `from <https://github.com/bitnami/charts/tree/master/bitnami/mongodb/values.yaml>`_

.. list-table::
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - ``mongodb.useStatefulSet``
     - Use StatefulSet instead of Deployment when deploying standalone
     - ``true``
   * - ``mongodb.initdbScriptsConfigMap``
     - ConfigMap with the initdb scripts.
     - ``netris-controller-initdb-mongodb``
   * - ``mongodb.auth.database``
     - Name for a database to create
     - ``netris``
   * - ``mongodb.auth.username``
     - Name for a user to create
     - ``netris``
   * - ``mongodb.auth.password``
     - Password for the new user
     - ``changeme``
   * - ``mongodb.auth.rootPassword``
     - Password for the root user
     - ``changeme``


*Auth from existing secret not supported at the momment*

Redis parameters
^^^^^^^^^^^^^^^^

*Using default values* `from <https://github.com/bitnami/charts/tree/master/bitnami/redis/values.yaml>`_

.. list-table::
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - ``redis.cluster.enabled``
     - Use master-slave topology
     - ``false``
   * - ``redis.usePassword``
     - Use password
     - ``false``


*Auth not supported at the momment*

Smtp parameters
^^^^^^^^^^^^^^^

*Using default values* `from <https://github.com/ntppool/charts/tree/main/charts/smtp/values.yaml>`_

.. list-table::
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - ``smtp.config.DISABLE_IPV6``
     - Disable IPv6
     - ``1``
   * - ``smtp.config.RELAY_NETWORKS``
     - Relay networks. Change if your CNI use other subnets
     - ``:172.16.0.0/12:10.0.0.0/8:192.168.0.0/16``


HAproxy parameters
^^^^^^^^^^^^^^^^^^

*Using default values* `from <https://github.com/haproxytech/helm-charts/tree/master/haproxy/values.yaml>`_

.. list-table::
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - ``haproxy.enabled``
     - Enable HAProxy. Used for exposing netris agents ports from single loadbalancer ip. Disable if you can't have type:LoadBalancer service in cluster
     - ``true`` 
   * - ``haproxy.service.type``
     - Kubernetes service type
     - ``LoadBalancer``


Graphite parameters
^^^^^^^^^^^^^^^^^^^

*Using default values* `from <https://github.com/kiwigrid/helm-charts/tree/master/charts/graphite/values.yaml>`_

.. list-table::
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - ``graphite.configMaps``
     - Netris-Controller supported graphite's config files
     - ``see in values.yaml``
   * - ``graphite.service.type``
     - Kubernetes service type
     - ``ClusterIP``


Usage
-----

Specify each parameter using the --set key=value[,key=value] argument to helm install. For example,

.. code-block::

   helm install netris-controller netrisai/netris-controller \
     --namespace netris-controller \
     --set app.ingress.hosts={my.domain.com} \
     --set netris.authKey=$mystrongauthkey \
     --set mariadb.auth.rootPassword=my-root-password \
     --set mariadb.auth.password=my-password \
     --set mongodb.auth.rootPassword=my-root-password \
     --set mongodb.auth.password=my-password

The above command sets netris-controller application ingress host to ``my.domain.com`` and sets generated netris.authKey. Additionally, it sets MariaDB and MongoDB root account password to ``my-root-password`` and user account password to ``my-password``.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

.. code-block::

   helm install netris-controller netrisai/netris-controller --namespace netris-controller -f values.yaml

After installation use ``EXTERNAL-IP`` of haproxy service as ``--controller`` parameter in `netris-setup <https://www.netris.ai/docs/en/stable/switch-agent-installation.html#install-the-netris-agent>`_

.. code-block::

   kubectl get svc -nnetris-controller |grep haproxy

and ``$mystrongauthkey`` as ``--auth`` parameter in `netris-setup <https://www.netris.ai/docs/en/stable/switch-agent-installation.html#install-the-netris-agent>`_

.. code-block::

   echo $mystrongauthkey

Also you can see overrides values from helm get values 

.. code-block::

   helm get values netris-controller
