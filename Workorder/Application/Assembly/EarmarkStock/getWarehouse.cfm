

	<cfquery name="warehouse" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT *
		FROM   Warehouse
		WHERE  Warehouse IN (
	  			
					SELECT    Warehouse
					FROM      ItemTransaction
					WHERE     Mission     = '#url.mission#' 
					<cfif workorderid neq "" and workorderid neq "all">
					AND       WorkOrderId = '#url.workorderid#'
					</cfif>
					AND       ItemNo      = '#url.itemno#'
					GROUP BY  Warehouse, TransactionUoM
					HAVING    SUM(TransactionQuantity) > 0	
										
					)				 
						
				 
    </cfquery>  
	
	<cfoutput>
	
		<select name="warehouse" id="warehouse"
		    class="regularxxl" style="font-size:20px;height:36px;width:100%"		
			onchange="ptoken.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/getStockLevel.cfm?mission=#url.mission#&workorderidselect=#url.workorderid#&warehouse='+this.value+'&itemno='+document.getElementById('itemno').value+'&uom='+document.getElementById('uom').value+'&workorderid='+document.getElementById('workorderid').value+'&workorderline='+document.getElementById('workorderline').value,'stockbox');ptoken.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/setWarehouseTo.cfm?itemno='+document.getElementById('itemno').value+'&mission=#url.mission#&warehouse='+this.value,'boxtransferto')">
			<cfloop query="Warehouse">
				<option value="#Warehouse#">#WarehouseName#</option>
			</cfloop>
		</select>	
			
		<script>	
		    // refresh warehouse select
			ptoken.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/getStockLevel.cfm?mission=#url.mission#&warehouse=#warehouse.warehouse#&workorderidselect=#url.workorderid#&itemno=#url.ItemNo#&uom=#url.uom#&workorderid='+document.getElementById('workorderid').value+'&workorderline='+document.getElementById('workorderline').value,'stockbox')						
			// refresh warehouse to
			ptoken.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/setWarehouseTo.cfm?itemno=#url.itemno#&mission=#url.mission#&warehouse=#warehouse.warehouse#','boxtransferto')								
		</script>
	
	</cfoutput>				