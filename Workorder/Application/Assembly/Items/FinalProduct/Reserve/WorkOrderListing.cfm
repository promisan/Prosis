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
<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrder
		WHERE   WorkOrderId = '#url.WorkOrderId#'			
</cfquery>

<cfquery name="line" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_ServiceItemDomainClass R INNER JOIN
                WorkOrderLine WL ON R.ServiceDomain = WL.ServiceDomain AND R.Code = WL.ServiceDomainClass
		WHERE   WorkOrderId = '#url.WorkOrderId#'			
		AND     WorkOrderLine = '#url.workorderline#'
</cfquery>

<cfinvoke component = "Service.Process.WorkOrder.WorkorderLineItem"  
	   method           = "InternalWorkOrder" 
	   mission          = "#get.Mission#"
	   returnvariable   = "NotEarmarked">	
  

<cfquery name="ItemFinished" 
	datasource="AppsWorkOrder"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

		SELECT  WO.Mission,
				WOL.WorkOrderItemId, 
				WOL.BillingMode,
				I.ItemNo, 
				I.ItemColor,
				I.Classification,
				I.ItemDescription,
				U.UoM, 
				U.UoMDescription, 
				WOL.Quantity, 
				
				(
				 SELECT    ISNULL(SUM(TransactionQuantity), 0) 
				 FROM      Materials.dbo.ItemTransaction
				 WHERE     Mission         = '#get.Mission#'
				 AND       Warehouse       = '#url.warehouse#'				 
				 AND       ItemNo          = WOL.ItemNo
				 AND       TransactionUoM  = WOL.UoM	
				 AND       ItemCategory IN (SELECT Category 
				                            FROM   Materials.dbo.Ref_Category 
											WHERE  StockControlMode = 'Stock')
				
				 <!--- not earmarked stock --->
				 AND       (
				          RequirementId IS NULL 	
						 <cfif notearmarked neq ""> 
						  OR 
						  RequirementId IN (#preservesingleQuotes(notearmarked)#)
						 </cfif> 
						  
						  )
						 				 
				 AND       ActionStatus IN ('0','1')
				 ) as InStock,						
																
				( 
				 SELECT    ISNULL(SUM(TransactionQuantity), 0) 
				 FROM      Materials.dbo.ItemTransaction				
				 WHERE     WorkOrderId    = WOL.WorkOrderId
				 AND       WorkOrderLine  = WOL.WorkOrderLine		
				 AND       TransactionType != '2'
				 AND       RequirementId = WOL.WorkOrderItemId
				) as Reserved,  <!--- quantity received or quantity internally produced for this workorder --->
				
				( 
				 SELECT    ISNULL(SUM(TransactionQuantity*-1), 0) AS Shipped
				 FROM      Materials.dbo.ItemTransaction
				 WHERE     TransactionType IN ('2','3')  <!--- 10/3/2013 removed the '8' from the transaction type --->				 
				 AND       WorkOrderId    = WOL.WorkOrderId
				 AND       WorkOrderLine  = WOL.WorkOrderLine			
				 AND       RequirementId = WOL.WorkOrderItemId
				) as Shipped, <!--- quantity shipped to customer --->
								
				WOL.Currency, 
				WOL.SalePrice, 
				WOL.SaleAmountIncome, 
				WOL.SaleAmountTax, 
				WOL.SalePayable, 
				WOL.Created
				
		FROM    WorkOrderLineItem WOL INNER JOIN Materials.dbo.Item I    ON WOL.ItemNo = I.ItemNo 
									  INNER JOIN Materials.dbo.ItemUoM U ON WOL.ItemNo = U.ItemNo AND WOL.UoM = U.UoM
						 			  INNER JOIN WorkOrder WO ON WOL.WorkOrderId = WO.WorkOrderId
		WHERE	WOL.WorkOrderId   = '#url.workorderid#' 
		AND     WOL.WorkOrderLine = '#url.workorderline#'
	    ORDER BY I.Classification,
		         I.ItemDescription, 
				 U.UoMDescription
</cfquery>


<cfif get.ActionStatus eq "1" or get.ActionStatus eq "0">
	<cfset mode = "edit">
<cfelse>
	<cfset mode = "view">
</cfif>

<cfoutput>

<table width="100%" height="100%">
   		  
  <tr><td height="100%">
  
    <cf_divscroll style="height:100%" id="orderbox">
			
	<table width="98%" class="navigation_table">	
	
	<tr class="fixrow"><td id="boxtransferto" style="height:40px">
  
  	  <cfset url.mission = get.Mission>
	  <cfinclude template="setWarehouseTo.cfm">
	  
	  </td>
  </tr>	
		
		<tr>
			<td height="100%">
			
				<table width="100%">			
				
					<tr class="labelmedium2 line fixrow240 fixlengthlist">
					
						<td></td>
						<td></td>
						<td><cf_tl id="Code"></td>
						<td><cf_tl id="Description"></td>		
						<td><cf_tl id="Color"></td>							
						<td><cf_tl id="UoM"></td>					
						<td align="right"><cf_tl id="Ordered"></td>													
						<td align="right"><cf_tl id="InStock"></td>		
						<td align="right"><cf_tl id="Reserved"></td>																		
						<cfif line.pointerSale eq "1">
							<td align="right"><cf_tl id="Shipped"></td>
						<cfelse>
							<td align="right"><cf_tl id="Freed"></td>
						</cfif>
						<td align="right"><cf_tl id="Pending"></td>
						
					</tr>					
																					
					<cfloop query="ItemFinished">
					
						<cfset bal = quantity-shipped>
													
						<tr class="navigation_row line labelmedium2 fixlengthlist">
						
							<td align="center">							    
								
								<cfif mode eq "edit">
								
									<cfif bal gt 0 
									    and instock gte "1" 
										and Reserved lt Quantity>	
										<input type="checkbox" class="radiol" checked name="selectline" value="'#workorderitemid#'">
																	
									</cfif>
																		
								</cfif>	
															
							</td>		
							
							<td>#currentrow#.</td>					
							<td>#Classification#</td>
							<td title="#ItemDescription#">#ItemDescription#</td>
							<td>#ItemColor#</td>
							<td>#uoMDescription#</td>																															
							<td bgcolor="A8EFF2" align="right">#numberformat(Quantity,'__')#</td>																
							<td bgcolor="e3e3e3" align="right">#numberformat(InStock,'__')#</td>
							
							<td align="right" bgcolor="ffffcf">
							
								<table width="100%">
									
									<tr class="labelmedium">																				
									<td width="20" style="padding-top:8px;padding-left:5px">											
									
									       <cf_img icon="expand" 
											   id="ear_#WorkOrderItemId#" 
											   toggle="Yes" 
											   onclick="toggleobjectbox('earmarkbox_#WorkOrderItemId#','earmark_#WorkOrderItemId#','#session.root#/Workorder/Application/Assembly/Items/FinalProduct/getDetailLines.cfm?WorkOrderId=#URL.WorkOrderId#&drillid=#WorkOrderItemId#')">										
									</td>																			
									<td align="right">#numberformat(Reserved,'__')#</td>												
									</tr>
								
								</table>		
							
							</td>
														
							<cfif BillingMode eq "None">
							
								<td align="right" colspan="2"></td>
								
							<cfelse>
								<td align="right" bgcolor="e1e1e1">#Shipped#</td>
																
								<cfif bal gt 0>
								<td bgcolor="ffffaf" align="right">#bal#</td>
								<cfelse>
								<td align="center" bgcolor="00FF40"><cf_tl id="Completed"></td>
								</cfif>
								
							</cfif>
							
						</tr>																					
						
						<tr id="earmarkbox_#workorderitemid#" class="hide">
						    <td></td>
						    <td colspan="9" style="padding-left:10px" id="earmark_#WorkOrderItemId#"></td>													
						</tr>										
																						
					</cfloop>
					
					<tr><td colspan="12" align="center" style="padding-top:4px">

						<cf_tl id="Apply Reservation" var="apply">
						
						<input type   = "button" 
						     class    = "button10g" 
						     style    = "width:260px;height:28px" 
							 value    = "#apply#" 
							 name     = "Submit" 
							 onclick  = "_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('#SESSION.root#/WorkOrder/Application/Assembly/Items/FinalProduct/Reserve/ReserveSubmit.cfm?mission=#get.mission#&warehouse=#url.warehouse#&workorderid=#url.workorderid#&workorderline=#url.workorderline#','orderbox','','','POST','reserveform')">
					
					</td></tr>
														
				</table>
				
			</td>
		</tr>
						
	</table>
	
	</cf_divscroll>
	
	</td>
	</tr>
	
</table>

</cfoutput>

<script>
	Prosis.busy('no');
</script>

<cfset AjaxOnLoad("doHighlight")>