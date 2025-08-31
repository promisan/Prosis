<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
	      
		   <table width="100%" height="100%" class="formpadding">
		   				
				<cfquery name="warehouse" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				  	SELECT    * 
					FROM      Warehouse W
					WHERE     Mission = '#workorder.mission#'
							
					<!--- show only warehouse that have items in stock which we have in the workorder --->
					AND       EXISTS (SELECT 'X' 
					                  FROM   ItemTransaction
								      WHERE  Mission = '#workorder.mission#'
									  AND    Warehouse = W.Warehouse
									  AND    Location IN (SELECT Location FROM WarehouseLocation WHERE Warehouse = W.Warehouse and Operational = 1) <!--- speeds up the query as index is now used --->
								      AND    ItemNo IN (SELECT ItemNo
										                FROM   WorkOrder.dbo.WorkOrderLineItem
										                WHERE  WorkorderId   = '#url.workorderid#'
											    	    AND    WorkOrderLine = '#url.workorderline#' )  
											)	
					AND       Operational = 1										               	
					ORDER BY  WarehouseDefault DESC				 
				</cfquery> 
				
				<!--- speed up this query --->
				
				<!--- default warehouse --->				
				<cfset url.warehouse = warehouse.warehouse>
								
				<cfoutput>		
				
				<input type="hidden" name="workorderid"      id="workorderid"      value = "#url.workorderid#">
				<input type="hidden" name="workorderline"    id="workorderline"    value = "#url.workorderline#">			
				<input type="hidden" name="systemfunctionid" id="systemfunctionid" value = "#url.systemfunctionid#">
				
				<tr class="fixrow">						   
					
					<td style="padding-left:3px;padding-right:10px" id="boxwarehouse">																
																			
							<select name="warehouse" id="warehouse"
							    class="regularxxl" style="background-color:f1f1f1;border:0px;font-size:20px;height:35px;width:100%"
								onchange="_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('#SESSION.root#/WorkOrder/Application/Assembly/Items/FinalProduct/Reserve/WorkOrderListing.cfm?mission=#workorder.mission#&warehouse='+this.value+'&workorderid=#url.workorderid#&workorderline=#url.workorderline#','orderbox')">
								<cfloop query="Warehouse">
									<option value="#Warehouse#">#WarehouseName#</option>
								</cfloop>
							</select>						  			
					
					</td>				
				
				</tr>			
							
				</cfoutput>				
									
				<tr>
					<td colspan="1" id="stockbox" style="height:100%;padding-left:4;padding-top:4px" valign="top" id="orderbox">	
																		
						  <cfinclude template="WorkOrderListing.cfm">						   		
						 
					</td>				
				</tr>			
			  
		   </table>
		   	   
	   </td> 
        	   
  </tr> 
  
  
</table>

</cfform>
