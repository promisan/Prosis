
<cfparam name="url.workorderid"   default="BC45B157-EE35-066E-D6B7-BCE776B2F802">
<cfparam name="url.workorderline" default="1">

<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT   * 
	FROM     WorkOrder
	WHERE    WorkOrderId = '#url.workorderid#'	
</cfquery>  	

<cfquery name="workorderline" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT   * 
	FROM     WorkOrderLine
	WHERE    WorkOrderId   = '#url.workorderid#'	
	AND      WorkOrderLine = '#url.workorderline#'
</cfquery>  	

<cfform method="post" name="reserveform" id="reserveform" style="height:100%;width:100%">							

<table width="100%" height="100%" style="padding-top:10px" border="0">

  <tr>
	   <td width="100%" height="100%" valign="top">
	      
		   <table cellspacing="1" cellpadding="1" width="100%" height="100%" class="formpadding">
		   				
				<cfquery name="warehouse" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				  	SELECT    * 
					FROM      Warehouse
					WHERE     Mission = '#workorder.mission#'
					AND       Operational = 1			
					<!--- show only warehouse that have items that are part of the workorder --->
					AND       Warehouse IN (SELECT DISTINCT Warehouse 
					                        FROM   ItemTransaction
											WHERE  Mission = '#workorder.mission#'
											AND    ItemNo IN (
											                  SELECT ItemNo
											                  FROM   WorkOrder.dbo.WorkOrderLineItem
												              WHERE  WorkorderId = '#url.workorderid#'
															  AND    WorkOrderLine = '#url.workorderline#'
															  )  
											)				               	
					ORDER BY  WarehouseDefault DESC				 
				</cfquery>  
				
				<!--- default warehouse --->				
				<cfset url.warehouse = warehouse.warehouse>
								
				<cfoutput>		
				
				<input type="hidden" name="workorderid"      id="workorderid"      value = "#url.workorderid#">
				<input type="hidden" name="workorderline"    id="workorderline"    value = "#url.workorderline#">			
				<input type="hidden" name="systemfunctionid" id="systemfunctionid" value = "#url.systemfunctionid#">
				
				<tr>						   
					
					<td style="padding-left:3px;padding-right:10px" id="boxwarehouse">																
																			
							<select name="warehouse" id="warehouse"
							    class="regularxl" style="font-size:20px;height:30px;width:100%"
								onchange="_cf_loadingtexthtml='';Prosis.busy('yes');ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/Assembly/Items/FinalProduct/Reserve/WorkOrderListing.cfm?mission=#workorder.mission#&warehouse='+this.value+'&workorderid=#url.workorderid#&workorderline=#url.workorderline#','orderbox')">
								<cfloop query="Warehouse">
									<option value="#Warehouse#">#WarehouseName#</option>
								</cfloop>
							</select>						  			
					
					</td>				
				
				</tr>			
							
				</cfoutput>				
									
				<tr>
					<td colspan="1" id="stockbox" style="height:100%;padding-left:4;padding-top:4px" valign="top">															
						   <cf_divscroll style="height:100%" id="orderbox">
						   		 <cfinclude template="WorkOrderListing.cfm">
						   </cf_divscroll>				
					</td>				
				</tr>
				
			  
		   </table>
		   	   
	   </td> 
        	   
  </tr> 
  
  
</table>

</cfform>
