
<cfparam name="url.init" default="0">
<cfparam name="url.selected" default="">

<cfquery name="uomlist" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM   ItemWarehouseLocationUoM 
	WHERE  Warehouse = '#url.warehouse#'	
    AND    Location  = '#url.location#'	
	AND    ItemNo    = '#url.itemno#' 		
	AND    UoM       = '#url.uom#' 		
	ORDER BY MovementDefault DESC			
</cfquery>

<cfif uomlist.recordcount gte "1">

	<cfoutput>
	
		<select name="movementuom" id="movementuom" class="regularxl enterastab">
			<cfloop query="uomlist">
				<option value="#MovementUoM#" <cfif url.selected eq MovementUoM>selected</cfif>>#MovementUoM#</option>
			</cfloop>
		</select>			
	
	</cfoutput>
	
<cfelse>

	<cf_compression>
	
</cfif>
