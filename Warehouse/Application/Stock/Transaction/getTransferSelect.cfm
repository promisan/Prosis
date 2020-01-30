
<cfquery name="loc" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   W.*, R.Description as LocationClassName
		FROM     WarehouseLocation W, Ref_WarehouseLocationClass R
		WHERE    Warehouse = '#url.warehouse#'		
		AND      W.LocationClass = R.Code
		AND      Location != '#url.location#'
</cfquery>

<cfoutput>

<select name="Tolocation" id="Tolocation">
	<cfloop query="loc">
		<option value="#Location#">#LocationClassName#: #Description#</option>
	</cfloop>
</select>		

</cfoutput>	

