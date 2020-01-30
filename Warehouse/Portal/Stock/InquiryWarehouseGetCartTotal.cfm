
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