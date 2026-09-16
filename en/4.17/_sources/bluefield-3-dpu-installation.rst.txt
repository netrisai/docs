.. meta::
    :description: Installing BlueField-3 DPUs

=============================
Installing BlueField-3 DPUs
=============================

.. contents:: Table of Contents
    :local:
    :depth: 3

.. note::
   **New to BlueField-3 DPUs?** Read the Overview and "What Is a DPU" sections on
   :doc:`bluefield-3-dpus` first for background on what a DPU is and how Netris uses one. This
   page assumes that context and focuses only on installing the agent.

Concepts
========

A few terms this guide relies on that aren't covered on the Integration page:

**NVIDIA DPF (DOCA Platform Framework)** is NVIDIA's tool for automating the DPU lifecycle — provisioning, OS installation, mode switching, and ongoing configuration of BlueField DPUs. Netris relies on DPF to manage all of that, and this guide assumes it is already installed. See NVIDIA's `reference guide <https://networking-docs.nvidia.com/sol/rdg-for-dpf-zero-trust-dpf-zt>`_ if it isn't yet.

**Zero-Trust mode** is a DPF deployment mode. In this mode, the host server is treated as untrusted: the DPU sits as a hard boundary between the host and the network, and the host can only see the DPU as an ordinary NIC — it has no access to the DPU's own management plane. Netris's DPU support assumes DPUs are running in Zero-Trust mode.

**The DPF management cluster** is the Kubernetes cluster where the DPF Operator runs. It is a single cluster: a few master nodes run the control plane, and the bare-metal servers that physically hold your BlueField-3 DPUs join it as worker nodes. All the ``kubectl`` commands in this guide are run from a machine with ``kubectl`` access to that cluster.

**BlueField Bootstream (BFB)** is the DPU's bootable OS image. DPF's ``BFB`` custom resource (see below) tells DPF which BFB image to install on each DPU.

**Custom Resource Definition (CRD)** is a `Kubernetes <https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/>`_ mechanism that lets a tool like DPF define its own object types — such as ``BFB``, ``DPUFlavor``, and ``DPUDeployment`` below — that you manage with ordinary ``kubectl`` commands.

**DOCA Host-Based Networking (HBN)** is NVIDIA's data-plane service that runs on the DPU and speaks BGP EVPN / VXLAN — it's what actually forwards and tags traffic on the DPU's behalf.

Prerequisites
=============

Before you start, confirm:

- **NVIDIA DPF is installed and running in Zero-Trust mode.** If it isn't, follow NVIDIA's `reference guide <https://networking-docs.nvidia.com/sol/rdg-for-dpf-zero-trust-dpf-zt>`_ first — this page picks up where that guide leaves off.
- **Your BlueField-3 DPUs are discoverable by the DPF Operator.** Their BMC/OOB (Baseboard Management Controller / Out-of-Band) interfaces are reachable, and NVIDIA's node-feature-discovery component — installed as part of DPF — has labeled the bare-metal servers containing your DPUs with ``feature.node.kubernetes.io/dpu-enabled: "true"``. This is how the DPF Operator knows which cluster worker nodes to provision DPUs on.
- **You have** ``kubectl`` **access to the DPF management cluster** — the cluster where the DPF Operator is installed. All commands below run there.

The DPF Operator installs the CRDs used in this guide (``BFB``, ``DPUFlavor``, ``DPUServiceInterface``, ``DPUServiceTemplate``, ``DPUServiceConfiguration``, ``DPUDeployment``) as part of its own setup — you do not install them separately.

Overview
========

Once DPF is up, deploying Netris on the DPU is a matter of creating a handful of these custom resources on the DPF management cluster. A single ``DPUDeployment`` ties everything together:

- **DOCA HBN** — the host-based networking data plane running on the DPU (BGP EVPN / VXLAN VTEP).
- **netris-dpu-agent** — the Netris control-plane agent that registers the DPU with your Netris controller and manages HBN's configuration on Netris's behalf.
- A **service chain** that wires the physical ports (``p0``/``p1``) and every Physical Function (PF) / Virtual Function (VF) representor through to HBN, so host traffic is correctly forwarded into the appropriate tenant's segment on the Netris-managed fabric.

No manual container installation is needed on the DPU itself. DPF pulls and runs both Helm charts as DPUServices once the ``DPUDeployment`` is created.

Creating the Resources
=======================

Create the following six resources on the DPF management cluster. `Apply Order`_ below shows the sequence used to apply them.

1. Interfaces — ``physical-ifaces.yaml``
-----------------------------------------

Declares the physical ports (``p0``, ``p1``), the two PF representors (``pf0hpf``, ``pf1hpf``), and 16 VF representors (``pf0vf0-7``, ``pf1vf0-7``) that will be wired into the service chain.

.. code-block:: yaml

   ---
   apiVersion: svc.dpu.nvidia.com/v1alpha1
   kind: DPUServiceInterface
   metadata:
     name: p0
     namespace: dpf-operator-system
   spec:
     template:
       spec:
         template:
           metadata:
             labels:
               interface: "p0"
           spec:
             interfaceType: physical
             physical:
               interfaceName: p0
   ---
   apiVersion: svc.dpu.nvidia.com/v1alpha1
   kind: DPUServiceInterface
   metadata:
     name: p1
     namespace: dpf-operator-system
   spec:
     template:
       spec:
         template:
           metadata:
             labels:
               interface: "p1"
           spec:
             interfaceType: physical
             physical:
               interfaceName: p1
   ---
   apiVersion: svc.dpu.nvidia.com/v1alpha1
   kind: DPUServiceInterface
   metadata:
     name: pf0hpf
     namespace: dpf-operator-system
   spec:
     template:
       spec:
         template:
           metadata:
             labels:
               interface: "pf0hpf"
           spec:
             interfaceType: pf
             pf:
               pfID: 0
   ---
   apiVersion: svc.dpu.nvidia.com/v1alpha1
   kind: DPUServiceInterface
   metadata:
     name: pf1hpf
     namespace: dpf-operator-system
   spec:
     template:
       spec:
         template:
           metadata:
             labels:
               interface: "pf1hpf"
           spec:
             interfaceType: pf
             pf:
               pfID: 1
   ---
   apiVersion: svc.dpu.nvidia.com/v1alpha1
   kind: DPUServiceInterface
   metadata:
     name: pf0vf0-rep
     namespace: dpf-operator-system
   spec:
     template:
       spec:
         template:
           metadata:
             labels:
               interface: "pf0vf0"
           spec:
             interfaceType: vf
             vf:
               parentInterfaceRef: p0
               pfID: 0
               vfID: 0
   ---
   apiVersion: svc.dpu.nvidia.com/v1alpha1
   kind: DPUServiceInterface
   metadata:
     name: pf0vf1-rep
     namespace: dpf-operator-system
   spec:
     template:
       spec:
         template:
           metadata:
             labels:
               interface: "pf0vf1"
           spec:
             interfaceType: vf
             vf:
               parentInterfaceRef: p0
               pfID: 0
               vfID: 1
   ---
   # ... one entry per remaining VF you need, e.g. pf0vf2-rep ... pf0vf7-rep (parentInterfaceRef: p0, pfID: 0, vfID: 2-7)
   # and pf1vf0-rep ... pf1vf7-rep (parentInterfaceRef: p1, pfID: 1, vfID: 0-7)

*(Full 19-interface manifest — 2 physical + 2 PF + 16 VF — available on request; trimmed here for brevity. Adjust the VF count to match how many VFs you actually need per PF.)*

2. BFB — ``bfb.yaml``
-----------------------

Points DPF at the BlueField Bootstream (BFB) image to provision onto the DPUs.

.. code-block:: yaml

   ---
   apiVersion: provisioning.dpu.nvidia.com/v1alpha1
   kind: BFB
   metadata:
     name: bf-bundle
     namespace: dpf-operator-system
   spec:
     url: $BFB_URL

Replace ``$BFB_URL`` with the actual download URL for the BFB image matching your BlueField/DOCA version before applying this file.

3. DPUFlavor — ``hbn-dpuflavor.yaml``
---------------------------------------

Zero-Trust mode flavor with SR-IOV enabled (46 VFs across both PFs), the OVS bridge (``br-sfc``) bring-up script, and the grub/nvconfig parameters HBN needs.

.. code-block:: yaml

   ---
   apiVersion: provisioning.dpu.nvidia.com/v1alpha1
   kind: DPUFlavor
   metadata:
     name: hbn-ntrs
     namespace: dpf-operator-system
   spec:
     dpuMode: zero-trust
     bfcfgParameters:
     - UPDATE_ATF_UEFI=yes
     - UPDATE_DPU_OS=yes
     - WITH_NIC_FW_UPDATE=yes
     configFiles:
     - operation: override
       path: /etc/mellanox/mlnx-bf.conf
       permissions: "0644"
       raw: |
         ALLOW_SHARED_RQ="no"
         IPSEC_FULL_OFFLOAD="no"
         ENABLE_ESWITCH_MULTIPORT="yes"
     - operation: override
       path: /etc/mellanox/mlnx-ovs.conf
       permissions: "0644"
       raw: |
         CREATE_OVS_BRIDGES="no"
         OVS_DOCA="yes"
     - operation: override
       path: /etc/mellanox/mlnx-sf.conf
       permissions: "0644"
       raw: ""
     grub:
       kernelParameters:
       - console=hvc0
       - console=ttyAMA0
       - earlycon=pl011,0x13010000
       - fixrttc
       - net.ifnames=0
       - biosdevname=0
       - iommu.passthrough=1
       - cgroup_no_v1=net_prio,net_cls
       - hugepagesz=2048kB
       - hugepages=3072
     nvconfig:
     - device: '*'
       parameters:
       - PF_BAR2_ENABLE=0
       - PER_PF_NUM_SF=1
       - PF_TOTAL_SF=21
       - PF_SF_BAR_SIZE=10
       - NUM_PF_MSIX_VALID=0
       - PF_NUM_PF_MSIX_VALID=1
       - PF_NUM_PF_MSIX=228
       - INTERNAL_CPU_MODEL=1
       - INTERNAL_CPU_OFFLOAD_ENGINE=0
       - SRIOV_EN=1
       - NUM_OF_VFS=46
       - LAG_RESOURCE_ALLOCATION=1
     ovs:
       rawConfigScript: |
         _ovs-vsctl() {
           ovs-vsctl --no-wait --timeout 15 "$@"
         }

         _ovs-vsctl set Open_vSwitch . other_config:doca-init=true
         _ovs-vsctl set Open_vSwitch . other_config:dpdk-max-memzones=50000
         _ovs-vsctl set Open_vSwitch . other_config:hw-offload=true
         _ovs-vsctl set Open_vSwitch . other_config:pmd-quiet-idle=true
         _ovs-vsctl set Open_vSwitch . other_config:max-idle=20000
         _ovs-vsctl set Open_vSwitch . other_config:max-revalidator=5000
         _ovs-vsctl --if-exists del-br ovsbr1
         _ovs-vsctl --if-exists del-br ovsbr2
         _ovs-vsctl --may-exist add-br br-sfc
         _ovs-vsctl set bridge br-sfc datapath_type=netdev
         _ovs-vsctl set bridge br-sfc fail_mode=secure
         _ovs-vsctl --may-exist add-port br-sfc p0
         _ovs-vsctl set Interface p0 type=dpdk
         _ovs-vsctl set Interface p0 mtu_request=9216
         _ovs-vsctl set Port p0 external_ids:dpf-type=physical
         _ovs-vsctl --may-exist add-port br-sfc p1
         _ovs-vsctl set Interface p1 type=dpdk
         _ovs-vsctl set Interface p1 mtu_request=9216
         _ovs-vsctl set Port p1 external_ids:dpf-type=physical

.. note::
   ``NUM_OF_VFS=46`` is the example value from NVIDIA's own DPF Zero-Trust reference guide, sized for that guide's reference hardware — it is not a Netris requirement. This sets how many VFs the firmware makes available in total; ``physical-ifaces.yaml`` above only wires up the subset you actually intend to use (16, in that example — 8 per PF) into Netris's service chain. Size this to your own DPU's port and workload count, keeping it at least as large as the VF count you declare in ``physical-ifaces.yaml``.

4. DOCA HBN service — ``hbn-service.yaml``
---------------------------------------------

Two resources: the ``DPUServiceTemplate`` (which Helm chart/image to run) and the ``DPUServiceConfiguration`` (which internal interfaces the HBN service exposes — all mapped to the ``mybrhbn`` network, one per physical/PF/VF interface).

.. code-block:: yaml

   ---
   apiVersion: svc.dpu.nvidia.com/v1alpha1
   kind: DPUServiceTemplate
   metadata:
     name: doca-hbn
     namespace: dpf-operator-system
   spec:
     deploymentServiceName: "doca-hbn"
     helmChart:
       source:
         repoURL: $HELM_REGISTRY_REPO_URL
         version: 1.0.3
         chart: doca-hbn
       values:
         image:
           repository: $HBN_NGC_IMAGE_URL
           tag: 3.1.0-doca3.1.0
         resources:
           memory: 6Gi
           nvidia.com/bf_sf: 20
         configuration:
           user:
             create: true
             password:
               secretKey: password
               secretName: bmc-shared-password
             username: hbn
   ---
   apiVersion: svc.dpu.nvidia.com/v1alpha1
   kind: DPUServiceConfiguration
   metadata:
     name: doca-hbn
     namespace: dpf-operator-system
   spec:
     deploymentServiceName: doca-hbn
     serviceConfiguration: {}
     interfaces:
     - name: p0_if
       network: mybrhbn
     - name: p1_if
       network: mybrhbn
     - name: pf0hpf_if
       network: mybrhbn
     - name: pf1hpf_if
       network: mybrhbn
     - name: pf0vf0_if
       network: mybrhbn
     - name: pf0vf1_if
       network: mybrhbn
     # ... one entry per remaining VF interface (pf0vf2_if ... pf1vf7_if), all on network: mybrhbn

.. note::
   ``mybrhbn`` is an arbitrary internal network label, not a fixed or reserved name — NVIDIA's own reference guide uses a different made-up name (``mybrsfc``) for the equivalent field. You can rename it to whatever you like as long as every ``network:`` value in this file stays consistent; it isn't referenced from any of the other five files.

Replace ``$HELM_REGISTRY_REPO_URL`` with your Helm chart registry URL and ``$HBN_NGC_IMAGE_URL`` with the HBN container image location before applying this file. ``bmc-shared-password`` must already exist as a Secret in ``dpf-operator-system`` before applying — it's the same credential used elsewhere in your DPF Zero-Trust setup.

5. Netris DPU agent service — ``netris-agent-service.yaml``
---------------------------------------------------------------

.. code-block:: yaml

   ---
   apiVersion: svc.dpu.nvidia.com/v1alpha1
   kind: DPUServiceConfiguration
   metadata:
     name: netris-dpu-agent
     namespace: dpf-operator-system
   spec:
     deploymentServiceName: netris-dpu-agent
   ---
   apiVersion: svc.dpu.nvidia.com/v1alpha1
   kind: DPUServiceTemplate
   metadata:
     name: netris-dpu-agent
     namespace: dpf-operator-system
   spec:
     deploymentServiceName: "netris-dpu-agent"
     helmChart:
       source:
         repoURL: https://netrisai.github.io/charts
         version: 0.1.0
         chart: netris-dpu-agent
       values:
         controller:
           host: <YOUR_NETRIS_CONTROLLER_HOST>
           authKey: <YOUR_NETRIS_CONTROLLER_AUTH_KEY>
         hbn:
           url: https://<HBN_SERVICE_ENDPOINT>:8765
           password: <HBN_SERVICE_PASSWORD>

Replace ``controller.host`` / ``controller.authKey`` with the values from your Netris controller (Settings → Auth Keys). ``hbn.url`` should point at the doca-hbn service's ClusterIP/hostname on port 8765, and ``hbn.password`` must match the credential configured in the HBN service (``bmc-shared-password`` above).

6. DPUDeployment — ``dpudeployment.yaml``
--------------------------------------------

This is the resource that, once applied, actually triggers provisioning. It references the ``bfb`` and ``flavor`` from steps 2–3, both services from steps 4–5, and defines the full service chain wiring every physical/PF/VF interface through to HBN.

.. code-block:: yaml

   ---
   apiVersion: svc.dpu.nvidia.com/v1alpha1
   kind: DPUDeployment
   metadata:
     name: hbn
     namespace: dpf-operator-system
   spec:
     dpus:
       bfb: bf-bundle
       flavor: hbn-ntrs
       nodeEffect:
         noEffect: true
       dpuSets:
       - nameSuffix: "dpuset1"
         nodeSelector:
           matchLabels:
             feature.node.kubernetes.io/dpu-enabled: "true"
     services:
       doca-hbn:
         serviceTemplate: doca-hbn
         serviceConfiguration: doca-hbn
       netris-dpu-agent:
         serviceTemplate: netris-dpu-agent
         serviceConfiguration: netris-dpu-agent
     serviceChains:
       switches:
         - ports:
           - serviceInterface:
               matchLabels:
                 interface: p0
           - service:
               name: doca-hbn
               interface: p0_if
         - ports:
           - serviceInterface:
               matchLabels:
                 interface: p1
           - service:
               name: doca-hbn
               interface: p1_if
         - ports:
           - serviceInterface:
               matchLabels:
                 interface: pf0hpf
           - service:
               name: doca-hbn
               interface: pf0hpf_if
         - ports:
           - serviceInterface:
               matchLabels:
                 interface: pf1hpf
           - service:
               name: doca-hbn
               interface: pf1hpf_if
         - ports:
           - serviceInterface:
               matchLabels:
                 interface: pf0vf0
           - service:
               name: doca-hbn
               interface: pf0vf0_if
         - ports:
           - serviceInterface:
               matchLabels:
                 interface: pf0vf1
           - service:
               name: doca-hbn
               interface: pf0vf1_if
         # ... one switch entry per remaining VF (pf0vf2 ... pf1vf7), each wiring
         # serviceInterface "pfXvfY" to doca-hbn interface "pfXvfY_if"

Apply Order
===========

Run the following from a machine with ``kubectl`` configured against the DPF management cluster:

.. code-block:: shell

   kubectl apply -f physical-ifaces.yaml
   kubectl apply -f bfb.yaml
   kubectl apply -f hbn-dpuflavor.yaml
   kubectl apply -f hbn-service.yaml
   kubectl apply -f netris-agent-service.yaml
   kubectl apply -f dpudeployment.yaml

Verify
======

Same pattern as DPU provisioning verification in the DPF RDG:

.. code-block:: shell

   watch -n10 "kubectl describe dpu -n dpf-operator-system | grep 'Node Name\|Type\|Last\|Phase'"

or with ``dpfctl``:

.. code-block:: shell

   kubectl -n dpf-operator-system exec deploy/dpf-operator-controller-manager -- /dpfctl describe dpudeployments

Once the DPU reaches ``Ready``, both ``doca-hbn`` and ``netris-dpu-agent`` should show as running DPUServices, and the DPU should register in your Netris controller's inventory automatically.

Next Steps
==========

Continue to :doc:`bluefield-3-dpus` to attach the DPU to a server object in Netris inventory and connect its VFs to a VNet.
