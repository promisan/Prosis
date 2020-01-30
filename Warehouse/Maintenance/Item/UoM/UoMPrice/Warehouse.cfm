<cfquery name="getLookup" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Warehouse
	<cfif url.mission neq "">
		WHERE	Mission = '#url.mission#'
	</cfif>
</cfquery>
<select name="Warehouse" id="Warehouse" class="regularxl">
	<option value="">Any</option>
	<cfoutput query="getLookup">
	  <option value="#getLookup.Warehouse#" <cfif getLookup.Warehouse eq #url.Warehouse#>selected</cfif>>#getLookup.WarehouseName#</option>
  	</cfoutput>
</select>