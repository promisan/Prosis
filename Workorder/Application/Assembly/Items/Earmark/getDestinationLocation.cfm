

<cfquery name="Warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    *
    FROM      Warehouse
    WHERE     Warehouse = '#url.warehouse#'    									  	
</cfquery>


<cfquery name="WarehouseLocation" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    *
    FROM      WarehouseLocation
    WHERE     Warehouse = '#url.warehouse#'    									  
	AND Operational = 1
</cfquery>

<select name="destinationlocation" id="destinationlocation" class="regularxl">			
	
	<cfoutput query="warehouselocation">
	<option value="#location#" <cfif warehouse.LocationReceipt eq location>selected</cfif>>#Description#</option>
	</cfoutput>
	
</select>
		