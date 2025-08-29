<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfquery name="get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   WarehouseLocation
	WHERE  Warehouse  = '#url.shipto#'
	AND    Storageid  = '#url.StorageId#'	  
</cfquery>

<cfquery name="Item" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	   SELECT *
	   FROM   Item
	   WHERE  ItemNo  = '#url.ItemNo#'	  
</cfquery>

<cf_precision number="#item.ItemPrecision#">

<cfquery name="Check" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT SUM(Quantity) as Total
	FROM   WarehouseCart C, WarehouseLocation L
	WHERE  C.ShipToWarehouse = L.Warehouse
	AND    C.ShipToLocation  = L.Location
	AND    C.ItemNo          = '#url.ItemNo#' 
	AND    C.UoM             = '#url.UoM#'	 
	<cfif get.Locationid eq "">
	AND    L.LocationId      is NULL	
	<cfelse>
	AND    L.LocationId      = '#get.LocationId#'	
	</cfif>
	AND    L.Warehouse       = '#get.Warehouse#'    
</cfquery>

<cfoutput>
   <font color="008000"><b>#numberformat(check.total,'#pformat#')#
   <script>
      // alert("Quantities are recorded. Select Request submission to actually send your request.") 
   </script>
</cfoutput>