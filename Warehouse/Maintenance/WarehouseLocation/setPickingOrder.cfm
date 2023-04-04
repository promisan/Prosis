
<cfif url.pickingOrder neq "">

<cfquery name="set" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE ItemWarehouseLocation
		SET    PickingOrder = '#url.pickingOrder#'
		WHERE  Warehouse = '#url.warehouse#'
		AND    Location = '#url.location#'	
	</cfquery>
	
	done!
	
</cfif>	