

<cfif url.scope eq "backoffice">

	<!--- show all products in the target warehouse AND the selected DIRECT TO warehouse --->
		
	<cfquery name="qProduct" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT DISTINCT 
					I.ItemNo, 
					I.ItemDescription,
					I.Category
			FROM 	ItemWarehouseLocation IWL INNER JOIN Item I ON I.ItemNo = IWL.ItemNo
			WHERE	IWL.Warehouse = '#url.warehouse#'
			AND     IWL.Operational = 1
			AND		IWL.Location IN (SELECT Location 
			                         FROM   WarehouseLocation 
									 WHERE  Warehouse = IWL.Warehouse
									 <cfif url.geolocationid neq "">
									 AND    LocationId = '#url.geolocationid#'
									 <cfelse>
									 AND    Locationid is NULL
									 </cfif>
									 )
			AND      I.ItemClass = 'Supply' 
			
			AND      I.Category IN ( 
			                         SELECT Category
			                         FROM   WarehouseCategory
									 WHERE  Operational = 1
									 AND    Warehouse = '#url.directtowarehouse#'
									)		
			
			ORDER BY I.Category,I.ItemNo
	</cfquery>
	
	

<cfelse>
	
	<!--- show all products in the target warehouse --->
	
	<cfquery name="qProduct" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT DISTINCT 
					I.ItemNo, 
					I.ItemDescription,
					I.Category
			FROM 	ItemWarehouseLocation IWL INNER JOIN Item I ON I.ItemNo = IWL.ItemNo
			WHERE	IWL.Warehouse = '#url.warehouse#'
			AND     IWL.Operational = 1
			AND		IWL.Location IN (SELECT Location 
			                         FROM   WarehouseLocation 
									 WHERE  Warehouse = IWL.Warehouse
									 <cfif url.geolocationid neq "">
									 AND    LocationId = '#url.geolocationid#'
									 <cfelse>
									 AND    Locationid is NULL
									 </cfif>
									 )
			AND      I.ItemClass = 'Supply' 
			ORDER BY I.Category,I.ItemNo
	</cfquery>

</cfif>

<cfif find("MSIE 10","#CGI.HTTP_USER_AGENT#")>
		
	<cfform>
		
	<cfselect name="itemNo" 
			query="qProduct" 
			value="itemNo" 
			group="category"
			display="ItemDescription"
			required="Yes" 
			style="width:300"
			class="regularxl enterastab"
			message="Please, select a valid product."
			onchange="javascript:ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/Request/Create/LineTransfer/AddRequestLocation.cfm?scope=#url.scope#&mission=#url.mission#&directtowarehouse=#url.directtowarehouse#&warehouse=#url.warehouse#&geolocationid=#url.geolocationid#&itemno='+this.value,'divAddRequestLocation');"/>
	
	</cfform>
	
<cfelse>	
	
		<cfoutput>
			
		<select name="itemNo" 
				query="qProduct" 
				value="itemNo" 
				group="category"
				display="ItemDescription"
				required="Yes" 
				class="regularxl enterastab"
				style="width:300"
				message="Please, select a valid product."
				onchange="javascript:ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/Request/Create/LineTransfer/AddRequestLocation.cfm?scope=#url.scope#&mission=#url.mission#&directtowarehouse=#url.directtowarehouse#&warehouse=#url.warehouse#&geolocationid=#url.geolocationid#&itemno='+this.value,'divAddRequestLocation');"/>
				  <cfloop query="qProduct">
					  <option value="#ItemNo#">#ItemDescription#</option>				  
				  </cfloop>		
		</select>	
		
		</cfoutput>	
	
</cfif>


<cfoutput>
	<script>
		ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/Request/Create/LineTransfer/AddRequestLocation.cfm?scope=#url.scope#&mission=#url.mission#&directtowarehouse=#url.directtowarehouse#&warehouse=#url.warehouse#&geolocationid=#url.geolocationid#&itemno=#qProduct.itemno#','divAddRequestLocation');
		
		ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/Request/Create/LineTransfer/AddRequestDirectTo.cfm?scope=#url.scope#&mission=#url.mission#&directtowarehouse=#url.directtowarehouse#&warehouse=#url.warehouse#&category=#qProduct.category#','divAddRequestDirectTo');	
	</script>
</cfoutput> 