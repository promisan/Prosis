
<cfquery name="getWarehouse" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Materials.dbo.Warehouse
	WHERE  Mission = '#url.mission#'
	AND    SaleMode != '0'
</cfquery>

<cfif getWarehouse.recordcount eq "0">
	
	<cfquery name="getWarehouse" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Materials.dbo.Warehouse
		WHERE  Mission = '#url.mission#'	
	</cfquery>

</cfif>

<cfparam name="url.itemno" default="">


<select name="Warehouse" class="regularxl" onchange="_cf_loadingtexthtml='';ColdFusion.navigate('getWarehouseItem.cfm?warehouse='+this.value+'&itemno=#url.itemno#','itembox')">
	<option value="">Not applicable</option>
	<cfoutput query="getWarehouse">
		<option value="#warehouse#" <cfif url.selected eq warehouse>selected</cfif>>#WarehouseName#</option>
	</cfoutput>			
</select>		
