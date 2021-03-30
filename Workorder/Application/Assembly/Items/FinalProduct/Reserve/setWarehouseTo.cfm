
<cfparam name="url.itemno" default="">

<table cellspacing="0" cellpadding="0">
	  
	  <tr> 
	  
	  <td class="labelmedium" style="padding-left:10px;padding-right:10px"><cf_tl id="Warehouse">:</td>
	  
	  <td style="padding-left:3px;padding-right:10px">
															
					<cfquery name="warehouse" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					  	SELECT   * 
						FROM     Warehouse
						WHERE    Mission = '#url.mission#'
						AND      Operational = 1			
						AND     ( Warehouse IN (SELECT Warehouse
						                       FROM   WarehouseCategory
											   WHERE  Operational = 1
											   AND    Category IN (SELECT Category FROM Item WHERE ItemNo = '#url.itemno#'))            	
								OR    					   
								
								Warehouse = '#url.warehouse#'
								
								)
						ORDER BY WarehouseDefault DESC				 
					</cfquery>  
					
					<cfoutput>	
											
						<select name="warehouseto" id="warehouseto"
						    class="regularxxl" style="width:250px"
							onchange="ptoken.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/setWarehouseLocationTo.cfm?itemno=#url.itemno#&warehouse=#url.warehouse#&warehouseto='+this.value,'boxlocationto')">
							<cfloop query="Warehouse">
								<option value="#Warehouse#" <cfif url.warehouse eq warehouse>selected</cfif>>#WarehouseName#</option>
							</cfloop>
						</select>			
					</cfoutput>	
									   							
				</td>				
			  
		<td style="padding-left:3px;padding-right:10px" class="labelmedium"><cf_tl id="Location">:</td>
		
		<td id="boxlocationto">
		
			<cfset url.warehouseto = url.warehouse>
			<cfinclude template="setWarehouseLocationTo.cfm">
		
		</td>
	  
	  </tr>
		  
</table>