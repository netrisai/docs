.. meta::
    :description: Getting Started for Equinix Metal

########################################
Equinix Metal API integration enablement
########################################


For each Equinix Metal Project+location you need to define an individual Site in Netris Controller.

Go to Netris Web Console → Net → Sites and click +Add.

You only need to deal with the below 5 fields. Leave the rest to default values for now. 


.. list-table:: 
   :widths: 25 50
   :header-rows: 1
   
   * - Netris Parameter
     - What to do:
   * - Switch Fabric
     - Select "Equinix Metal" from the dropdown menu.
   * - Name
     - Type a descriptive name for your Equinix Metal Project+location.
   * - Equinix Project ID
     - Copy/Paste the Project ID from Equinix Metal portal under Project Settings → General → Project ID.
   * - Equinix Project API key
     - Create a new Read/Write API key in Equinix Metal portal under Project Settings → Project API keys → + Add New Key. Then copy/paste here.
   * - Equinix Location
     - Select your equinix location from the dropdown menu.


Equinix Metal Project ID

.. image:: /tutorials/images/equinix-metal-project-id.png
    :align: center


Equinix Metal Project API key

.. image:: /tutorials/images/equinix-metal-project-api-keys.png
    :align: center


Netris Create New Site

.. image:: /tutorials/images/netris-create-equinix-metal-site.png
    :align: center
    

