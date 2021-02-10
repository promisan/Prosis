
<!--- check if code exists --->
 
<cfquery name="check" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     *
			FROM       WarehouseLocation
			WHERE      Warehouse = '#url.warehouse#'
			AND        Location = '#url.value#'            			
</cfquery>

<cfif check.recordcount eq "0">
	<table><tr><td style="height:17px;width:17px;background-color:green"></td></tr></table>	
<cfelse>
	<table><tr><td style="height:17px;width:17px;background-color:red"></td></tr></table>
</cfif>