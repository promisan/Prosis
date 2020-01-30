
<cfquery name="WarehouseList" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   * 
		FROM     Warehouse P
		WHERE    Mission = '#URL.Mission#' 
		AND      Warehouse IN (SELECT Warehouse 
		                       FROM   WarehouseCategory 
							   WHERE  Warehouse = P.Warehouse
							   AND    Category  = '#url.Category#'
                               AND    Operational = 1
							   AND    SelfService = 1)
		AND      Distribution = 1										   
						   
		ORDER BY WarehouseDefault DESC
</cfquery>
   
<cfif WarehouseList.recordcount eq "0">
   
	   <cfquery name="WarehouseList" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   * 
			FROM     Warehouse P
			WHERE    Mission = '#URL.Mission#' 
			AND      Distribution = 1	
			ORDER BY WarehouseDefault DESC
	   </cfquery>
   						   
</cfif>
 						  
<cfquery name="WarehouseSelect" datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    * 
		FROM      Warehouse
		WHERE     City IN (SELECT City 
		                   FROM   Warehouse 
						   WHERE  Warehouse = '#url.Warehouse#')									 			   												   
		ORDER BY  WarehouseDefault DESC
</cfquery>

<cfif url.directtowarehouse eq "">

<select class="regularxl enterastab" style="width:100%" name="warehouseTo" id="warehouseTo">
	<cfoutput query="WarehouseList">
		<option value="#Warehouse#" <cfif WarehouseSelect.warehouse eq Warehouse>selected</cfif>>#WarehouseName# #Warehouse#</option>
	</cfoutput>
</select>	

<cfelse>

<select class="regularxl enterastab" style="width:100%" name="warehouseTo" id="warehouseTo">
	<cfoutput query="WarehouseList">
		<option value="#Warehouse#" <cfif url.directtowarehouse eq Warehouse>selected</cfif>>#WarehouseName# #Warehouse#</option>
	</cfoutput>
</select>	

</cfif>	