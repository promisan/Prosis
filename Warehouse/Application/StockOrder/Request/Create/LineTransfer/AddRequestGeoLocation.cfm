
<cfquery name="qGeoLocation" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   DISTINCT ISNULL(Location.LocationName, 'undetermined') AS LocationName, LocationId
	FROM     WarehouseLocation LEFT OUTER JOIN Location ON WarehouseLocation.LocationId = Location.Location
	WHERE    WarehouseLocation.Warehouse = '#url.warehouse#'
</cfquery>

<cfoutput>
		
	<select name="ShipToGeoLocation" 		 		 
		  class="regularxl enterastab"
		  message="Please, select a valid location to ship to."
		  onchange="ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/Request/Create/LineTransfer/AddRequestProduct.cfm?scope=#url.scope#&mission=#url.mission#&directtowarehouse=#url.directtowarehouse#&warehouse=#url.warehouse#&geolocationid='+this.value,'divAddRequestProduct');">
		  <cfloop query="qGeoLocation">
			  <option value="#Locationid#">#LocationName#</option>				  
		  </cfloop>		
	</select>

    <!--- passes the first row value to the next dropdown --->
		 
	<script>
		ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/Request/Create/LineTransfer/AddRequestProduct.cfm?scope=#url.scope#&mission=#url.mission#&directtowarehouse=#url.directtowarehouse#&warehouse=#url.warehouse#&geolocationid=#qGeoLocation.LocationId#','divAddRequestProduct');
	</script>
		
</cfoutput>
