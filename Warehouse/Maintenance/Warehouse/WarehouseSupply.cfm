
<cfquery name="Supply" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Warehouse 
	WHERE  Mission = '#URL.Mission#' 
</cfquery>
	

<select name="SupplyWarehouse" id="SupplyWarehouse" class="regularxl">
	<option value="">N/A</option>
	<cfoutput query="Supply">
	<option value="#Warehouse#">#WarehouseName#</option>
	</cfoutput>
</select>