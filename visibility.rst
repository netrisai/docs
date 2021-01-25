**********************
Visibility (Telescope)
**********************

Graph Boards
=================
You can create custom graph boards with data sources available in different parts of the system. You can even sum multiple graphs and visualize them in a single view.

To start with Graph Boards, first, you need to add a new Graph Board. 

1. Navigate to Telescope→Graph Boards, open the dropdown menu in the top left corner, then click +Add board.

.. image:: images/telescope.png
    :align: center
    
2. Type a name and assign it to one of the tenants that you manage. Later on, you can optionally mark the Graph Board as public if you want the particular board to be visible to all users across multiple tenants.  

.. image:: images/createboard.png
    :align: center
    
Now you can add graphs by clicking +Add graph. 

Description of +Add graph fields:

* **Title** - Title for the new graph.
* **Type** - Type of data source.
    * Bps - Traffic bits per second.
    * Pps - Traffic packets per second.
    * Errors - Errors per second.
    * Optical - Optical signal statistics/history.
    * MAC Count - History of the number of MAC addresses on the port.
* **Function** - Currently, only summing is supported.
* **+Member** - Add data sources by service (E-BGP, V-NET, etc..) or by Switch Port.

Example: Sum of traffic on two ISP(Iris1 + Iris2) links.

.. image:: images/ISP_Iris.png
    :align: center
