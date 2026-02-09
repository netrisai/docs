.. meta::
    :description: Enable phoenixNAP BMC API integration

.. _phxnap_api:

#####################################
Enable phoenixNAP BMC API integration
#####################################


For each phoenixNAP BMC location you need to define an individual Site in Netris Controller.

Go to Netris Web Console → Net → Sites and click +Add.

You only need to deal with the below 5 fields. Leave the rest to default values for now. 


.. list-table:: 
   :widths: 25 50
   :header-rows: 1
   
   * - Netris Parameter
     - What to do:
   * - Switch Fabric
     - Select "PhoenixNAP BMC" from the dropdown menu.
   * - Name
     - Type a descriptive name for your phoenixNAP BMC location.
   * - PhoenixNAP Client ID
     - Create a new API Credential with "bmc" scope in phoenixNAP BMC portal under API Credentials → + Create Credentials. Then copy/paste Client ID.
   * - PhoenixNAP Client Secret
     - Copy/Paste the Client Secret from the already created API Credential.
   * - PhoenixNAP Location
     - Select your phoenixNAP BMC location from the dropdown menu.


phoenixNAP BMC API Credential

.. image:: /tutorials/images/phoenixnap-api-credential.png
    :align: center


Netris Create New Site

.. image:: /tutorials/images/phoenixnap-site-create.png
    :align: center
    

