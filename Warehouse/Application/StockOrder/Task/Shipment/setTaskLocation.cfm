
<!--- set the task location and reset the workflow and transactions --->

<cfquery name="getTask" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT R.ItemNo, R.UoM
	FROM   RequestTask RT INNER JOIN Request R ON RT.RequestId = R.RequestId
    WHERE  RT.StockOrderId = '#url.stockorderid#'		
</cfquery>	

<cfquery name="TaskOrder" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   TaskOrder
    WHERE  StockOrderId = '#url.stockorderid#'		
</cfquery>	

<cfquery name="LocationList" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   W.*, 
		         ISNULL(W.Description+''+StorageCode,W.Description) as LocationName, 
		         R.Description as LocationClassName
		FROM     WarehouseLocation W, Ref_WarehouseLocationClass R					
		WHERE    Warehouse       = '#url.warehouse#'	
		AND      W.LocationClass = R.Code					
		AND      W.Operational  = 1 
		AND      W.Distribution = 1
		<!--- move only to locations that have this stock item recorded --->
		AND      W.Location IN (SELECT Location
		                        FROM   ItemWarehouseLocation 
								WHERE  Warehouse = W.Warehouse
								AND    Location  = W.Location
								AND    ItemNo    = '#GetTask.ItemNo#'
								AND    UoM       = '#GetTask.UoM#')
		ORDER BY LocationClass
</cfquery>	


<table cellspacing="0" cellpadding="0">

	<cfform>
	
		<tr><td>
						
			<cfselect name="location" id="location"
		         group    = "LocationClassName"
				 onchange = ""
				 class    = "regularxl"
		         query    = "LocationList"
			     selected = "#TaskOrder.Location#"
		         value    = "Location"
		         display  = "LocationName"	        
		         style    = "font:10px"/>			  
						
		</td>
		
		<td style="padding-left:4px;padding-top:2px" id="settasklocation">	
	    <cfoutput>
   		 <img src="#SESSION.root#/images/save.png" height="22" width="20" alt="" border="0" 
		  onclick="ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/task/shipment/setTaskLocationSubmit.cfm?stockorderid=#url.stockorderid#&warehouse=#url.warehouse#&&location='+document.getElementById('location').value,'processtask')">							
		</cfoutput>  		
	    </td>			
		</tr>
		
	</cfform>	

</table>	

		  