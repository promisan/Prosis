<!--
    Copyright © 2025 Promisan

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

<cfajaximport tags="cfdiv">

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

<cfform method="post" name="stockform" id="stockform" style="height:100%;width:100%">							

	<table width="100%" height="100%" style="padding-top:10px" border="0">
		   
	  <tr>
		   <td width="350" height="100%" style="min-width:350px" valign="top">
		   
		       <cf_divscroll style="height:100%">					
		   
			   <table cellspacing="0" cellpadding="0" width="100%" height="100%" class="formpadding">
			   
			   		<tr><td height="7"></td></tr>	
					
					<tr><td style="padding-right:4px"><table width="100%">
			   
			   		<tr bgcolor="E6E6E6"><td class="labellarge" style="height:30px;padding-left:8px"><cf_tl id="Source"></td></tr>
					
					</table></td></tr>
			   
			   		<tr><td height="10"></td></tr>
					
					<cfquery name="warehouse" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					  	SELECT    * 
						FROM      Warehouse
						WHERE     Mission = '#workorder.mission#'
						AND       Operational = 1				
						ORDER BY  WarehouseDefault DESC									 
					</cfquery>  
									
					<!--- default warehouse --->				
					<cfset url.warehouse = warehouse.warehouse>
					
					<tr>
				       
						<td style="padding-left:3px">
						

						
						<!--- define all workorder that are not closed and that have
						transaction for items net earmarked in a positive --->
											
						<cfquery name="workorderselect" 
						datasource="AppsWorkorder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						  	SELECT    W.WorkOrderId, CustomerName, W.Reference
							FROM      WorkOrder W INNER JOIN
							          Customer C ON W.CustomerId = C.CustomerId
							WHERE     W.Mission      = '#workorder.mission#' 
							AND       W.ActionStatus < '3'
							AND       W.WorkOrderId != '#url.workorderid#'
							
							AND EXISTS
			
									(		
										SELECT    'X'
										FROM      Materials.dbo.ItemTransaction T
										WHERE     Mission     = '#workorder.mission#' 
										AND       WorkOrderId = W.WorkOrderId					
										<!--- only for earmarked to workorderllineitem --->
										AND      T.RequirementId IN (SELECT WorkOrderItemId 
							                    			         FROM   WorkOrder.dbo.WorkOrderLineItem 
																     WHERE  WorkOrderItemId = T.RequirementId)
										
										GROUP BY  WorkOrderId
										HAVING    SUM(TransactionQuantity) > 1			
							        )							
							
							ORDER BY  C.CustomerName, W.Reference								 
							
					    </cfquery>  
						
						<cfselect name="workorderidselect"
					          group="customername"
					          queryposition="below"
					          query="workorderselect"
					          value="workorderid"
					          display="reference"
							  onchange="javascript:ptoken.navigate('#SESSION.root#/Workorder/Application/Assembly/EarmarkStock/getWorkorderItem.cfm?mission=#workorder.mission#&warehouse=#url.warehouse#&workorderid='+this.value,'itemselect')"
					          visible="Yes"
							  style="height:30px;font-size:17px;10px;width:94%"
					          enabled="Yes"
					          id="workorderidselect"
					          class="regularxl">
								 						 
								  <option value="all"><cf_tl id="ANY earmarked workorder">|<cf_tl id="Select item"></option>
								  <option value=""><cf_tl id="NOT earmarked stock"></option>
						
						</cfselect>									
						
						</td>
					
					</tr>
							  
			     	<tr> 
											  
				          <td align="left" width="90%" style="padding-left:3px;padding-right:10px" id="itemselect">
						  								
						    <table width="99%" cellspacing="0" cellpadding="0">
							
								<tr>
								
								   <td width="98%" style="height:30px;padding-left:7px;border:1px solid silver" id="itembox"></td>
								   	
								   <td width="30" valign="top" style="padding-left:3px">
								   	
								        <cfset link = "#SESSION.root#/Workorder/Application/Assembly/EarmarkStock/getItem.cfm?mission=#workorder.mission#&warehouse=#url.warehouse#">
									   										
										<!--- take the runtime value of the warehouse instead --->
																    									   
								   		<cf_selectlookup
										    box          = "itembox"
											link         = "#link#"
											title        = "Item Selection"
											icon         = "contract.gif"
											style        = "height:25px"
											button       = "Yes"
											close        = "Yes"	
											filter1      = "warehouse"
											filter1value = "#url.warehouse#"													
											class        = "Item"
											des1         = "ItemNo">	
											
										<input type="hidden" 
											    name="itemno" 
												id="itemno" 
												size="4" 
												value="" 
												class="regular" 
												readonly 
												style="text-align: center;">	
								
									</td>										
									
								</tr>
							
							</table>  
																								
					  	  </td>			  	   
				    </tr>
						
					<tr id="uomlabel" class="xxhide">
					
					    <td id="uombox" style="height:30px;padding-left:3px;border:0px solid silver">
						
							<input type="hidden" 
							    name="uom" 
								id="uom" 
								size="4" 
								value="" 
								class="regular" 
								readonly 
								style="text-align: center;">	
						
						</td>
					</tr>	
					
					<cfoutput>		
					
					<input type="hidden" name="workorderid"   id="workorderid"         value="#url.workorderid#">
					<input type="hidden" name="workorderline" id="workorderline"       value="#url.workorderline#">			
					<input type="hidden" name="systemfunctionid" id="systemfunctionid" value="#url.systemfunctionid#">
					
					<tr>						   
						
						<td style="padding-left:3px;padding-right:10px" id="boxwarehouse" class="hide">																
																			
								<select name="warehouse" id="warehouse"
								    class="regularxl" style="font-size:20px;height:36px;width:100%"
									onchange="ptoken.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/getStockLevel.cfm?mission=#workorder.mission#&warehouse='+this.value+'&itemno='+document.getElementById('itemno').value+'&uom='+document.getElementById('uom').value+'&workorderid='+document.getElementById('workorderid').value+'&workorderline='+document.getElementById('workorderline').value,'stockbox');ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/setWarehouseTo.cfm?itemno='+document.getElementById('itemno').value+'&mission=#workorder.mission#&warehouse='+this.value,'boxtransferto')">
									<cfloop query="Warehouse">
										<option value="#Warehouse#">#WarehouseName#</option>
									</cfloop>
								</select>						  			
						
						</td>				
					
					</tr>			
								
					</cfoutput>				
					
					<tr><td height="5"></td></tr> 
					
					<tr><td height="1" colspan="1" class="line"></td></tr>
					
					<tr>
						<td colspan="1" id="stockbox" style="height:100%;padding-left:4;padding-top:4px" valign="top">															
						<!--- stock content --->					
						</td>				
					</tr>
					
				  
			   </table>
			   
		   		</cf_divscroll>
		   
		   </td> 
	      
	       <td width="70%" height="100%" valign="top" style="padding-left:4px;padding-top:4px;border-left:1px solid silver">
		      
		   <cf_divscroll style="height:100%" id="orderbox">		   
		   		 <cfinclude template="WorkOrderListing.cfm">
		   </cf_divscroll>	   	     
		   
		   </td> 	   
		   
	  </tr> 
	    
	  <tr bgcolor="E6E6E6"><td style="padding-left:10px;padding-right:10px" height="40" colspan="2" id="processbox" class="hide">	  
		  	<cfinclude template="EarmarkProcess.cfm">			    
		  </td>
	  </tr>
	  
	</table>

</cfform>
