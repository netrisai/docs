.. meta::
  :description: Installing HA Netris Controller in Air-Gapped Environments
 
Installing HA Netris Controller in Air-Gapped Environments
===========================================================

Why Air-Gapped Installation?
----------------------------
In many production or regulated environments, network connectivity is tightly restricted for security or compliance reasons. An **air-gapped** environment prevents unauthorized external access and ensures no reliance on external artifact repositories. All required components—binaries, container images, and Helm charts—are transferred manually (e.g., via USB, secure copy) and installed entirely offline. This approach:

- **Enhances Security** by limiting the potential attack surface.
- **Ensures Consistency** of the software stack across multiple deployments.
-	**Complies** with strict regulatory standards where internet access may be disallowed.


Why a High Availability (HA) Cluster?
-------------------------------------

Running **Netris Controller** on a **high availability (HA)** cluster provides resilience against hardware or software failures. By deploying multiple control-plane nodes, each with redundant services, the cluster can tolerate node downtime without losing critical functionality. Benefits include:

- **Redundancy**: No single point of failure in the control plane or the critical components of Netris Controller.
- **Scalability**: Workloads can be spread across multiple nodes, easing resource constraints.
- **Reliability**: Uninterrupted operation even during maintenance or unexpected issues on one of the nodes.



Prerequisites
-------------

1. **Three Servers** in the same private network, each meeting the minimum `hardware requirements <https://www.netris.io/docs/en/latest/supported-switch-hardware.html>`_ for K3s and Netris Controller.
2. **Two Virtual IP Addresses (VIPs)** available on that network:
   
  - **KubeAPI VIP** (e.g., 192.168.0.40/32)
  - **Netris Controller VIP** (e.g., 192.168.0.50/32)
  

**Example IP Assignments**
  - Node addresses:
  
    - 192.168.0.1/24 – node1
    - 192.168.0.2/24 – node2
    - 192.168.0.3/24 – node3
  
  - KubeAPI VIP: 192.168.0.40/32
  - Netris Controller VIP: 192.168.0.50/32
  


3. **Default Gateway** configured on each server. If no default route exists, add a dummy route or black-hole route to satisfy K3s requirements.
4. **Air-Gapped Artifacts**. You have the complete set of binaries, container images, Helm charts, CRDs, and manifests in the ``netris-controller-ha/`` folder.
5. **Firewall Rules:** The following ports **must be open between all three nodes** to ensure proper K3s cluster functionality:

  +----------+------------+--------------------------------------------------+
  | Protocol | Port       | Description                                      |
  +==========+============+==================================================+
  | TCP      | 2379-2380  | Required only for HA with embedded etcd          |
  +----------+------------+--------------------------------------------------+
  | TCP      | 6443       | K3s supervisor and Kubernetes API Server         |
  +----------+------------+--------------------------------------------------+
  | UDP      | 8472       | Required only for Flannel VXLAN                  |
  +----------+------------+--------------------------------------------------+
  | TCP      | 10250      | Kubelet metrics                                  |
  +----------+------------+--------------------------------------------------+

.. warning::
   **CPU AVX Instruction Support Required:** MongoDB requires CPUs with AVX instruction set support. This is commonly missing in virtualized environments (KVM/Proxmox/VMware VMs). Check AVX support before installation:
   
   .. code-block:: bash
   
      cat /proc/cpuinfo | grep avx
   
   If no output is returned, enable AVX support before proceeding.



Obtain the Installation File
----------------------------

Contact `Netris <https://www.netris.io/demo/>`_ to acquire the air-gapped installation package, named **netris-controller-ha-v4.x.x.tar.gz**. This package contains everything you need for an HA deployment of Netris Controller on K3s, without internet connectivity.



Steps to Install
----------------


1. Preparing Each Node
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1.1 Transfer the File to the Servers
""""""""""""""""""""""""""""""""""""

Use a secure copy method (e.g., SCP, USB drive) to move the netris-controller-ha-v4.x.x.tar.gz file to all your **three** targets Ubuntu 24.04 (or supported Linux) nodes.


1.2 Extract the Tarball
""""""""""""""""""""""""""""""""""

Once the file is on the servers, extract its contents:

.. code-block:: shell

  tar -xzvf netris-controller-ha-v4.x.x.tar.gz

This will create a folder containing all necessary scripts, binaries, images, Helm charts, CRDs, and manifests.


1.3 Navigate to the Installation Directory
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

On **all three nodes** change the directory to the extracted folder. For example:

.. code-block:: shell

  cd netris-controller-ha-v4.x.x

All subsequent steps in this guide assume you’re working from within this netris-controller-ha-v4.x.x/ directory.


2. Install K3s on All Nodes
^^^^^^^^^^^^^^^^^^^^^^^^^^^

2.1 Load K3s Binaries and Images
""""""""""""""""""""""""""""""""""""

On **all three nodes**, run the following commands to prepare a local K3s installation:


.. code-block:: shell

  sudo mkdir -p /var/lib/rancher/k3s/agent/images/

  # Copy air-gapped images
  sudo cp files/k3s/k3s-airgap-images-amd64.tar.zst /var/lib/rancher/k3s/agent/images/k3s-airgap-images-amd64.tar.zst

  # Copy K3s, Helm, and k9s executables
  sudo cp files/k3s/k3s /usr/local/bin/k3s && sudo chmod +x /usr/local/bin/k3s
  sudo cp files/k3s/helm /usr/local/bin/helm && sudo chmod +x /usr/local/bin/helm
  sudo cp files/k3s/k9s /usr/local/bin/k9s && sudo chmod +x /usr/local/bin/k9s

  # Make the installation script executable
  sudo chmod +x install-k3s.sh


2.2 Initialize the First Node
""""""""""""""""""""""""""""""""""""

On the **first node**:

1. Replace 192.168.0.40 with your Kubernetes API VIP.
2. Specify a secure token for K3S_TOKEN=SECRET:

.. code-block:: shell

  K3S_TOKEN=SECRET \
  INSTALL_K3S_VERSION=v1.31.5+k3s1 \
  INSTALL_K3S_SKIP_DOWNLOAD=true \
  K3S_KUBECONFIG_MODE="644" \
  INSTALL_K3S_EXEC='server --cluster-init --tls-san 192.168.0.40 --disable=traefik --disable=servicelb' \
  ./install-k3s.sh


3. Wait approximately a minute, then check the system pods:

.. code-block:: shell

  kubectl -n kube-system get pods


All pods should be in a Running or Completed state.



2.3 Join the Second and Third Nodes
""""""""""""""""""""""""""""""""""""

On the **second** and **third nodes**, update the IPs to match your environment:

.. code-block:: shell

  K3S_TOKEN=SECRET \
  INSTALL_K3S_VERSION=v1.31.5+k3s1 \
  INSTALL_K3S_SKIP_DOWNLOAD=true \
  K3S_KUBECONFIG_MODE="644" \
  INSTALL_K3S_EXEC='server --server https://192.168.0.1:6443 --tls-san 192.168.0.40 --disable=traefik --disable=servicelb' \
  ./install-k3s.sh


- Replace 192.168.0.1:6443 with the first node’s IP and port.
- Keep 192.168.0.40 as your KubeAPI VIP.


Confirm on the first node that all three nodes have joined:

.. code-block:: shell

  kubectl get node



3. Import Necessary Container Images
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

On **all three nodes**, import container images:


1. Decompress the images archive:

.. code-block:: shell

  gunzip -f images.tar.gz


2. Import them:

.. code-block:: shell

  sudo ctr images import images.tar

4. Configure North-South kube-vip for KubeAPI High Availability
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. On the **first node only**, open manifests/kube-vip-ns.yaml:

.. code-block:: shell

  vim manifests/kube-vip-ns.yaml

2. Find ``vip_interface`` and replace it with your north-south NIC name (e.g., bond1).

3. Apply the file

.. code-block:: shell

  kubectl apply -f manifests/kube-vip-ns.yaml

3. On the **first node only**, open manifests/kube-vip-ns-cloud-controller.yaml

.. code-block:: shell

  vim manifests/kube-vip-ns-cloud-controller.yaml

4. Find ``cidr-global`` and replace it with your North-South VIP address.

5. Apply the file

.. code-block:: shell

  kubectl apply -f manifests/kube-vip-ns-cloud-controller.yaml

6. Apply the North-South Traefik service manifest

.. code-block:: shell

  kubectl apply -f manifests/traefik-ns-svc.yaml

5. Configure HA kube-vip for KubeAPI High Availability
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. On the **first node only**, open kube-vip.yaml:

.. code-block:: shell

  vim kube-vip.yaml


2. Scroll to the bottom, you will see the ``address`` and ``vip_interface`` variables. Edit them:
  
  - ``address``: replace ``192.168.0.40`` with your KubeAPI VIP.
  - ``vip_interface``: specify your network interface where 192.168.0.1 is located. (e.g., ``bond0``).


3. Apply the file:

.. code-block:: shell

  kubectl apply -f kube-vip.yaml


4. Ensure three kube-vip pods are running:

.. code-block:: shell

  kubectl -n kube-system get pods -l app.kubernetes.io/name=kube-vip-ds


5. Check VIP reachability (ping from all nodes):

.. code-block:: shell

  ping 192.168.0.40


6. Add Helm Chart Packages to K3s
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


Copy your Helm charts to the K3s static files directory on **all three nodes**:

.. code-block:: shell

  sudo cp files/charts/* /var/lib/rancher/k3s/server/static/charts/


You can now perform kubectl or helm commands from any node or a remote machine (after adjusting kubeconfig to point to the VIP).


7. Verify and Scale Core K3s Components
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Check the pods in the cluster:

.. code-block:: shell

  kubectl get pods -A


Scale key default components to three replicas for redundancy:


.. code-block:: shell

  kubectl -n kube-system scale deploy/local-path-provisioner --replicas=3
  kubectl -n kube-system scale deploy/coredns --replicas=3
  kubectl -n kube-system scale deploy/metrics-server --replicas=3


Confirm they have scaled:


.. code-block:: shell

  kubectl get pods -A


8. Deploy Kube-VIP Cloud Controller
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We need a second VIP for the Netris Controller load balancer.


1. On the **first node only**, open manifests/kube-vip-cloud-controller.yaml:

.. code-block:: shell

  vim manifests/kube-vip-cloud-controller.yaml


2. Locate the ConfigMap and change cidr-global from 192.168.0.50/32 to your planned controller VIP.
3. Apply:

.. code-block:: shell

  kubectl apply -f manifests/kube-vip-cloud-controller.yaml


4. Verify three pods are running:

.. code-block:: shell

  kubectl -n kube-system get pods -l component=kube-vip-cloud-provider



9. Install Traefik Proxy
^^^^^^^^^^^^^^^^^^^^^^^^

1. Apply the Traefik manifest:

.. code-block:: shell

  kubectl apply -f manifests/traefik.yaml


2. Check pods:

.. code-block:: shell

  kubectl -n kube-system get pods -l app.kubernetes.io/instance=traefik-kube-system


3. Verify Traefik has the external IP:

.. code-block:: shell

  kubectl -n kube-system get svc traefik


It should show EXTERNAL-IP as 192.168.0.50.


10. Deploy the Netris Controller
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


10.1 Install the MariaDB Operator
""""""""""""""""""""""""""""""""""

1. CRDs:

.. code-block:: shell

  kubectl apply -f manifests/netris-controller/mariadb-operator-crds.yaml


2. Namespace:

.. code-block:: shell

  kubectl apply -f manifests/netris-controller/ns.yaml


3. Operator:

.. code-block:: shell

  kubectl apply -f manifests/netris-controller/mariadb-operator-hc.yaml


4. Check status:

.. code-block:: shell

  kubectl get pods -n netris-controller

Expected output:

.. code-block:: shell

  NAME                                                              READY   STATUS      RESTARTS   AGE
  helm-install-netris-controller-ha-mariadb-operator-sgcn9          0/1     Completed   0          90s
  netris-controller-ha-mariadb-operator-6d49f86bd6-dlf6j            1/1     Running     0          88s
  netris-controller-ha-mariadb-operator-6d49f86bd6-gqz45            1/1     Running     0          88s
  netris-controller-ha-mariadb-operator-6d49f86bd6-lqjhx            1/1     Running     0          89s
  netris-controller-ha-mariadb-operator-cert-controller-79c42dcqh   1/1     Running     0          87s
  netris-controller-ha-mariadb-operator-cert-controller-79c44v4tv   1/1     Running     0          89s
  netris-controller-ha-mariadb-operator-cert-controller-79c4q9l2g   1/1     Running     0          87s
  netris-controller-ha-mariadb-operator-webhook-9b6dcd979-2jtr6     1/1     Running     0          88s
  netris-controller-ha-mariadb-operator-webhook-9b6dcd979-56pxp     1/1     Running     0          89s
  netris-controller-ha-mariadb-operator-webhook-9b6dcd979-cz5cs     1/1     Running     0          88s


Wait until all pods are ready and in a running or completed state.


10.2 Install Netris Controller
""""""""""""""""""""""""""""""

1. **HelmChart** manifest:

.. code-block:: shell

  kubectl apply -f manifests/netris-controller/hc.yaml


2. Wait 5–10 minutes for all pods to initialize.

3. Check:

.. code-block:: shell

  kubectl get pods -n netris-controller

Look for multiple pods in Running and Completed states (e.g., mariadb, mongodb, redis, web-service, “initdb” jobs, etc.).


Expected output:

.. code-block:: shell

  NAME                                                              READY   STATUS      RESTARTS   AGE
  helm-install-netris-controller-ha-mariadb-operator-sgcn9          0/1     Completed   0          4m45s
  helm-install-netris-controller-ha-r7brz                           0/1     Completed   0          116s
  netris-controller-ha-equinix-metal-agent-74fc8647b5-6wcck         1/1     Running     0          110s
  netris-controller-ha-graphite-0                                   1/1     Running     0          112s
  netris-controller-ha-graphite-1                                   1/1     Running     0          99s
  netris-controller-ha-graphite-2                                   1/1     Running     0          85s
  netris-controller-ha-grpc-5f88c9649b-b6csb                        1/1     Running     0          106s
  netris-controller-ha-grpc-5f88c9649b-jrvbl                        1/1     Running     0          108s
  netris-controller-ha-grpc-5f88c9649b-pdzdw                        1/1     Running     0          106s
  netris-controller-ha-mariadb-0                                    1/1     Running     0          82s
  netris-controller-ha-mariadb-1                                    1/1     Running     0          82s
  netris-controller-ha-mariadb-2                                    1/1     Running     0          82s
  netris-controller-ha-mariadb-ha-0                                 1/1     Running     0          111s
  netris-controller-ha-mariadb-ha-1                                 1/1     Running     0          109s
  netris-controller-ha-mariadb-ha-2                                 1/1     Running     0          109s
  netris-controller-ha-mariadb-operator-6d49f86bd6-dlf6j            1/1     Running     0          4m43s
  netris-controller-ha-mariadb-operator-6d49f86bd6-gqz45            1/1     Running     0          4m43s
  netris-controller-ha-mariadb-operator-6d49f86bd6-lqjhx            1/1     Running     0          4m44s
  netris-controller-ha-mariadb-operator-cert-controller-79c42dcqh   1/1     Running     0          4m42s
  netris-controller-ha-mariadb-operator-cert-controller-79c44v4tv   1/1     Running     0          4m44s
  netris-controller-ha-mariadb-operator-cert-controller-79c4q9l2g   1/1     Running     0          4m42s
  netris-controller-ha-mariadb-operator-webhook-9b6dcd979-2jtr6     1/1     Running     0          4m43s
  netris-controller-ha-mariadb-operator-webhook-9b6dcd979-56pxp     1/1     Running     0          4m44s
  netris-controller-ha-mariadb-operator-webhook-9b6dcd979-cz5cs     1/1     Running     0          4m43s
  netris-controller-ha-mongodb-0                                    1/1     Running     0          112s
  netris-controller-ha-mongodb-1                                    1/1     Running     0          96s
  netris-controller-ha-mongodb-2                                    1/1     Running     0          81s
  netris-controller-ha-phoenixnap-bmc-agent-64c75f8598-hjvzj        1/1     Running     0          113s
  netris-controller-ha-redis-node-0                                 2/2     Running     0          112s
  netris-controller-ha-redis-node-1                                 2/2     Running     0          86s
  netris-controller-ha-redis-node-2                                 2/2     Running     0          57s
  netris-controller-ha-smtp-5f789dbb58-xr4cx                        1/1     Running     0          111s
  netris-controller-ha-telescope-7696d94694-qrszj                   1/1     Running     0          112s
  netris-controller-ha-telescope-notifier-7b59777b8-wp89p           1/1     Running     0          107s
  netris-controller-ha-web-service-backend-67999c5699-bdcp8         1/1     Running     0          111s
  netris-controller-ha-web-service-backend-67999c5699-gbwr4         1/1     Running     0          107s
  netris-controller-ha-web-service-backend-67999c5699-h5hgb         1/1     Running     0          107s
  netris-controller-ha-web-service-frontend-74d978fd67-9ptvj        1/1     Running     0          108s
  netris-controller-ha-web-service-frontend-74d978fd67-dtbpn        1/1     Running     0          105s
  netris-controller-ha-web-service-frontend-74d978fd67-jnbqr        1/1     Running     0          105s
  netris-controller-ha-web-session-generator-fc4c64597-dlssj        1/1     Running     0          108s
  netris-controller-ha-web-session-generator-fc4c64597-g2ghs        1/1     Running     0          113s
  netris-controller-ha-web-session-generator-fc4c64597-rbf2s        1/1     Running     0          109s
  netris-controller-initdb-00-xcaas-ssbtq                           0/1     Completed   0          78s
  netris-controller-initdb-01-tenants-crjzg                         0/1     Completed   0          73s
  netris-controller-initdb-01-users-79phr                           0/1     Completed   0          68s
  netris-controller-initdb-02-permissions-sxhj4                     0/1     Completed   0          63s
  netris-controller-initdb-02-port-5m9kg                            0/1     Completed   0          63s
  netris-controller-initdb-02-vpc-j65lp                             0/1     Completed   0          63s
  netris-controller-initdb-03-global-settings-2d5lk                 0/1     Completed   0          63s
  netris-controller-initdb-04-currency-srpwl                        0/1     Completed   0          63s
  netris-controller-initdb-04-whitelist-mmtsj                       0/1     Completed   0          63s
  netris-controller-initdb-05-auth-schemes-fqrxf                    0/1     Completed   0          63s
  netris-controller-initdb-05-supported-platforms-wfht4             0/1     Completed   0          63s
  netris-controller-initdb-06-mon-thresholds-z4pw8                  0/1     Completed   0          63s
  netris-controller-initdb-06-nos-list-cdhwj                        0/1     Completed   0          63s
  netris-controller-initdb-06-roh-profiles-ctgms                    0/1     Completed   0          63s
  netris-controller-initdb-07-inventory-profiles-9hkgp              0/1     Completed   0          63s
  netris-controller-initdb-07-vpn-scores-sgv6n                      0/1     Completed   0          63s
  netris-controller-initdb-09-dhcp-option-set-jq7wl                 0/1     Completed   0          58s




11. (Optional) Enable SSL with cert-manager
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you intend to secure the Controller via an FQDN and Let’s Encrypt (or another ACME issuer) please also install cert-manager:

1. Install cert-manager:

.. code-block:: shell

  kubectl apply -f manifests/netris-controller/cert-manager.yaml


2. Verify pods:


.. code-block:: shell

  kubectl get pods -n cert-manager


3. Apply cert-manager resources (ClusterIssuers, etc.):

.. code-block:: shell

  kubectl apply -f manifests/netris-controller/cert-manager-resources.yaml




12. Set Up the Local Netris Repository
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The Netris Local Repository is essential for environments where switches, softgates, or other infrastructure devices do not have direct access to the internet. By setting up a local repository, you ensure that these devices can still download necessary packages and updates through a local APT repository

1. Deploy local repo manifests:

.. code-block:: shell

  kubectl apply -f manifests/netris-controller/local-repo.yaml


2. Confirm the pods are running:

.. code-block:: shell

  kubectl -n netris-controller get pods -l app.kubernetes.io/instance=netris-local-repo


3. On **all three nodes**, copy the repository files into the Persistent Volume:

.. code-block:: shell

  export PVC_PATH=$(kubectl get pv $(kubectl get pvc staticsite-$(kubectl -nnetris-controller get pod -l app.kubernetes.io/instance=netris-local-repo --field-selector spec.nodeName=$(hostname) --no-headers -o custom-columns=":metadata.name") -n netris-controller -o jsonpath="{.spec.volumeName}") -o jsonpath="{.spec.local.path}")

  sudo cp -r files/repo ${PVC_PATH}



13. Validate Your Deployment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Access the Netris Controller** via https://192.168.0.50 (or your assigned FQDN).
- **Confirm all services** (web service, GRPC, Redis, DBs) are Running:

.. code-block:: shell

  kubectl -n netris-controller get pods


- **Check cluster health**:

.. code-block:: shell

  kubectl get pods -A
  kubectl get nodes


All nodes should be Ready; all pods should be Running or Completed.


**Congratulations!** You have successfully deployed a **highly available, air-gapped** Netris Controller on a three-node K3s cluster.


After Installation
------------------

The air-gapped Netris Controller also includes a local repository/registry. This repository provides all the necessary packages and images for installing various types of Netris agents.

Enable the Local repository in the Netris Controller Web UI under **Settings** section (as shown in the screenshots below).

.. image:: ../images/global-setting-local-repo.png
    :align: center

.. image:: ../images/global-setting-local-repo-save.png
    :align: center


How to consume local repository
-------------------------------

Once the local repository function is enabled in the Netris Controller Settings, the Netris agent installation oneliner will automatically point to the local repository (as shown in the screenshots below).


.. image:: ../images/one-liner-with-local-repo.png
    :align: center


---

For any issues or additional assistance, please contact Netris Support.


.. _k3s-ha-upgrade:

Upgrading HA Netris Controller in Air-Gapped Environments
=========================================================

Obtain the Upgrade File
----------------------------

Contact `Netris <https://www.netris.io/demo/>`_ to acquire the air-gapped upgrade package, named **netris-controller-ha-v4.x.x.tar.gz**. This package contains everything you need for an HA deployment of Netris Controller on K3s, without internet connectivity.



1. Preparing Each Node
---------------------------

1.1 Transfer the File to the Servers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use a secure copy method (e.g., SCP, USB drive) to move the netris-controller-ha-v4.x.x.tar.gz file to all your **three** nodes.


1.2 Extract the Tarball
^^^^^^^^^^^^^^^^^^^^^^^^^

Once the file is on the servers, extract its contents:

.. code-block:: shell

  tar -xzvf netris-controller-ha-v4.x.x.tar.gz

This will create a folder containing all necessary scripts, binaries, images, Helm charts, CRDs, and manifests.


1.3 Navigate to the Installation Directory
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

On **all three nodes** change the directory to the extracted folder. For example:

.. code-block:: shell

  cd netris-controller-ha-v4.x.x

All subsequent steps in this guide assume you’re working from within this netris-controller-ha-v4.x.x/ directory.



2. Steps to Upgrade Controller
-------------------------------

*If you’re only upgrading the Local Netris Repository, you can skip this section and go directly to* :ref:`Section 3<local-repo-k3s-ha-upgrade>`

2.1 Import Necessary Container Images
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

On **all three nodes**, import container images:


1. Decompress the images archive:

.. code-block:: shell

  gunzip -f images.tar.gz


2. Import them:

.. code-block:: shell

  sudo ctr images import images.tar

2.2 Add Helm Chart Packages Upgrades to K3s
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Copy your Helm charts to the K3s static files directory on **all three nodes**:

.. code-block:: shell

  sudo cp files/charts/* /var/lib/rancher/k3s/server/static/charts/


2.3 Database backup
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To take database snapshot run the following command on the **first node**:

.. code-block:: shell

  kubectl -n netris-controller exec -it netris-controller-ha-mariadb-ha-0 -- bash -c 'mysqldump -h netris-controller-ha-mariadb -u netris -pchangeme netris' > db-snapshot-$(date +%Y-%m-%d-%H-%M-%S).sql


2.4 Upgrade Netris Controller
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

On the **first node** only:


1. Upgrade the **HelmChart** manifest:

.. code-block:: shell

  kubectl apply -f manifests/netris-controller/hc.yaml


2. Wait 2-4 minutes for all pods to upgraded.

3. Check:

.. code-block:: shell

  kubectl get pods -n netris-controller

Look for multiple pods in Running and Completed states.


.. _local-repo-k3s-ha-upgrade:

3. Steps to Upgrade the Local Netris Repository
-----------------------------------------------

On **all three nodes**, copy the repository files into the Persistent Volume:

.. code-block:: shell

  export PVC_PATH=$(kubectl get pv $(kubectl get pvc staticsite-$(kubectl -nnetris-controller get pod -l app.kubernetes.io/instance=netris-local-repo --field-selector spec.nodeName=$(hostname) --no-headers -o custom-columns=":metadata.name") -n netris-controller -o jsonpath="{.spec.volumeName}") -o jsonpath="{.spec.local.path}")

  sudo cp -r files/repo ${PVC_PATH}



**Congratulations!** You have successfully upgraded your **highly available, air-gapped** Netris Controller.


Maintenance Procedures
=======================

Proper maintenance procedures are critical for ensuring the continued stability and availability of your Netris Controller HA deployment. Improper shutdown or maintenance sequences can lead to database cluster inconsistencies, particularly with MariaDB, potentially resulting in service disruptions or data corruption.

Node Maintenance Best Practices
--------------------------------

Individual Node Maintenance (Recommended Approach)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The safest approach is to perform maintenance on one node at a time, keeping the cluster operational throughout the process:

1. **Identify the primary MariaDB node before starting maintenance**:

   .. code-block:: bash

      kubectl -nnetris-controller get maxscale netris-controller-ha-mariadb

   Note the PRIMARY column output (e.g., ``netris-controller-ha-mariadb-ha-0``)

2. **Find which physical node is hosting the primary MariaDB**:

   .. code-block:: bash

      kubectl -nnetris-controller get pod netris-controller-ha-mariadb-ha-0 -o wide

   Note the NODE column (e.g., ``ctl-ha-node1``)

3. **Plan your maintenance order**:

   - Start with nodes NOT hosting the primary MariaDB
   - Leave the node hosting the primary MariaDB for last

4. **For each non-primary node**:

   a. **Cordon the node** to prevent new pods from being scheduled:

      .. code-block:: bash

         kubectl cordon <node-name>

   b. **Drain the node** safely to relocate all running pods:

      .. code-block:: bash

         kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data

   c. **Verify pods have been relocated**:

      .. code-block:: bash

         kubectl get pods -A -o wide | grep <node-name>
   
   d. **Perform maintenance** on the node (updates, reboots, etc.)
   
   e. **Bring the node back online**
   
   f. **Verify node is ready**:

      .. code-block:: bash

         kubectl get nodes
   
   g. **Uncordon the node**:

      .. code-block:: bash

         kubectl uncordon <node-name>
   
   h. **Verify cluster health before proceeding to the next node**:

      .. code-block:: bash

         kubectl get pods -n netris-controller
         kubectl -nnetris-controller get maxscale netris-controller-ha-mariadb

5. **For the node hosting the primary MariaDB**:
   
   a. **Double-check it's still hosting the primary** (as failover might have occurred):

      .. code-block:: bash

         kubectl -nnetris-controller get maxscale netris-controller-ha-mariadb
         kubectl -nnetris-controller get pod <primary-pod-name> -o wide
   
   b. Follow the same cordon, drain, maintenance, and uncordon steps as above

Full Cluster Maintenance (When All Nodes Need Simultaneous Maintenance)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you need to shut down multiple nodes simultaneously:

1. **Identify the primary MariaDB node**:

   .. code-block:: bash

      kubectl -nnetris-controller get maxscale netris-controller-ha-mariadb

   Note the PRIMARY column output (e.g., ``netris-controller-ha-mariadb-ha-0``)

2. **Find which physical nodes are hosting each MariaDB instance**:

   .. code-block:: bash

      kubectl -nnetris-controller get pod -l app.kubernetes.io/name=mariadb -o wide

3. **Safe node shutdown sequence**:

   a. **Shutdown secondary/replica nodes first**:

      .. code-block:: bash

         # For each non-primary node
         kubectl cordon <non-primary-node>
         kubectl drain <non-primary-node> --ignore-daemonsets --delete-emptydir-data
         # Wait at least 1 minute before shutting down or proceeding to next node
         sudo shutdown -h now  # Only on the drained node

   b. **Shutdown the primary node last**:

      .. code-block:: bash

         kubectl cordon <primary-node>
         kubectl drain <primary-node> --ignore-daemonsets --delete-emptydir-data
         sudo shutdown -h now  # Only on the primary node

4. **Safe node startup sequence**:

   a. **Start the node that was hosting the primary MariaDB first**
   
   b. **Wait until it's fully online** (check with ``kubectl get nodes``)
   
   c. **Start the remaining nodes** one by one with at least 2 minutes between each
   
   d. **Uncordon each node after it's online**:

      .. code-block:: bash

         kubectl uncordon <node-name>

5. **Verify cluster health**:

   .. code-block:: bash

      kubectl get nodes
      kubectl -n netris-controller get pods
      kubectl -nnetris-controller get maxscale netris-controller-ha-mariadb


6. **Rebalance pods across all nodes**:

   After all nodes are back online and uncordoned, restart all deployments to ensure even pod distribution:

   .. code-block:: bash
      
      # This will restart all deployments in netris-controller namespace
      kubectl -nnetris-controller rollout restart deployment

   Wait for all pods to restart and reach Running state:

   .. code-block:: bash
   
      kubectl -nnetris-controller get pods

   Verify that pods are now distributed evenly across all nodes:

   .. code-block:: bash
   
      kubectl -nnetris-controller get pods -o wide

Verifying MariaDB Cluster Health
----------------------------------

After maintenance, verify the MariaDB cluster is healthy:

1. **Check MaxScale status**:

   .. code-block:: bash

      kubectl -nnetris-controller get maxscale netris-controller-ha-mariadb

   The STATUS should show ``Running`` and a PRIMARY should be identified

2. **Verify all MariaDB pods are running**:

   .. code-block:: bash

      kubectl -n netris-controller get pods -l app.kubernetes.io/name=mariadb

3. **If issues are detected**, check the operator logs:

   .. code-block:: bash

      kubectl -n netris-controller logs -l app.kubernetes.io/name=mariadb-operator

Maintenance Best Practices
----------------------------

1. **Always perform one-node-at-a-time maintenance** when possible
2. **Never simply power off nodes** without properly cordoning and draining
3. **Always shut down secondary/replica database nodes before the primary**
4. **Always start the primary node first** when bringing the system back online
5. **Verify cluster health after each node** completes maintenance
6. **Rebalance your workloads** by restarting deployments after all maintenance is complete
7. **Schedule maintenance during low-usage periods**
8. **Create a backup before maintenance**
9. **Document all maintenance activities** in a maintenance log


**For serious database issues**, contact Netris support with:

- Output of ``kubectl -nnetris-controller get maxscale netris-controller-ha-mariadb -o yaml``
- Logs from MariaDB pods and operator


By following these maintenance procedures, you can significantly reduce the risk of database inconsistencies and service disruptions during and after maintenance operations.
