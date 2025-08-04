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


<cfparam name="url.workorderid"   default="91FB3AC7-FA3F-4C5E-8802-00A5BD1E28A6">
<cfparam name="url.workorderline" default="349">

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrder
		WHERE   WorkOrderId = '#url.WorkOrderId#'			
</cfquery>

<!--- prevision to keep RI intact --->

<cfquery name="audit" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	DELETE FROM WorkOrderLineItemResource
	WHERE WorkOrderItemIdResource IN (
			SELECT WorkOrderItemIdResource
			FROM   WorkOrderLineItemResource AS U INNER JOIN
			       WorkOrderLineItem AS I ON U.WorkOrderItemId = I.WorkOrderItemId
			WHERE  WorkOrderId = '#url.WorkOrderId#'
			AND    NOT EXISTS
		                  (SELECT     'X' AS Expr1
		                   FROM       Materials.dbo.ItemUoM
		                   WHERE      ItemNo = U.ResourceItemNo AND UoM = U.ResourceUoM)
    )
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

<cfquery name="ItemFinished" 
	datasource="AppsWorkOrder"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

		SELECT  WO.Mission,
				WOL.WorkOrderItemId, 
				WOL.BillingMode,
				I.ItemNo, 
				I.ItemColor,
				U.ItemBarcode,
				I.Classification,
				I.ItemNoExternal,
				I.ItemDescription,
				U.UoM, 
				U.UoMDescription, 
				WOL.Quantity, 
				WOL.SaleType,
				
				(SELECT count(*) 
				 FROM   WorkOrderLineItemResource
				 WHERE  WorkOrderItemId = WOL.WorkOrderItemId 
				) as Resources,
				
				(SELECT SUM(Amount) 
				 FROM   WorkOrderLineItemResource
				 WHERE  WorkOrderItemId = WOL.WorkOrderItemId ) as Cost,		
												
				(SELECT ISNULL(SUM(RequestQuantity),0) 
				 FROM   Purchase.dbo.RequisitionLine
				 WHERE  Mission       = '#get.Mission#'						 
				 AND    RequirementId = WOL.WorkOrderItemId 
				 AND    ActionStatus >= '1' and ActionStatus < '9' ) as Outsourced,									
								
				<cfinvoke component = "Service.Process.WorkOrder.WorkorderLineItem"  
				   method           = "InternalWorkOrder" 
				   mission          = "#get.Mission#"
				   mode             = "view"
				   returnvariable   = "NotEarmarked">	
				
				(SELECT    ISNULL(SUM(TransactionQuantity), 0) 
				 FROM      Materials.dbo.ItemTransaction
				 WHERE     Mission           = '#get.Mission#'				 
				 AND       ItemNo            = WOL.ItemNo
				 AND       TransactionUoM    = WOL.UoM		
					 
					 <!--- individual mode issuing from the roll (Hicosa) is not supported for reservation yet --->
					 
				 AND       ItemCategory IN ( SELECT Category FROM Materials.dbo.Ref_Category WHERE StockControlMode = 'Stock' )
	
					 <!--- Hanno, rethink this embedded query as it is a bit slow 5/4/2021 --->
					 
				 AND       ( RequirementId IS NULL OR RequirementId IN (#preservesingleQuotes(notearmarked)#) )
							 				 
				 AND       ActionStatus IN ('0','1')                ) as InStock,
								
				(SELECT   ISNULL(SUM(RequestQuantity),0) 
				 FROM      Purchase.dbo.RequisitionLine
				 WHERE     Mission       = '#get.Mission#'						 
				 AND       RequirementId = WOL.WorkOrderItemId 
				 AND       ActionStatus != '9'                  	) as Requested,
				
				(SELECT   ISNULL(SUM(RequestQuantity),0) 
				 FROM      Purchase.dbo.RequisitionLine
				 WHERE     Mission       = '#get.Mission#'						 
				 AND       RequirementId = WOL.WorkOrderItemId 
				 AND       ActionStatus = '3'		             	) as Obligated,
												
				(SELECT    ISNULL(SUM(TransactionQuantity), 0) 
				 FROM      Materials.dbo.ItemTransaction
				 WHERE     WorkOrderId    = WOL.WorkOrderId
				 AND       WorkOrderLine  = WOL.WorkOrderLine
				 AND       RequirementId  = WOL.WorkOrderItemId
				 AND       TransactionType != '2' ) as Earmarked,  <!--- quantity received 1, transferred 8 or quantity internally produced 0 for this order --->							
												
				(SELECT    ISNULL(SUM(TransactionQuantity), 0) 
				 FROM      Materials.dbo.ItemTransaction
				 WHERE     WorkOrderId    = WOL.WorkOrderId
				 AND       WorkOrderLine  = WOL.WorkOrderLine
				 AND       RequirementId  = WOL.WorkOrderItemId) as OnHandForOrder,  <!--- quantity received  / issued local onhand for this workorder which is TO SHIP --->
								
				<!--- returned quantities which is tratype 5 --->
				
				(SELECT    ISNULL(SUM(TransactionQuantity*-1), 0) 
				 FROM      Materials.dbo.ItemTransaction
				 WHERE     WorkOrderId = WOL.WorkOrderId
				 AND       WorkOrderLine = WOL.WorkOrderLine
				 AND       RequirementId  = WOL.WorkOrderItemId
				 AND       TransactionType IN ('2','3')  <!--- 10/3/2014 removed '8' for the transaction type ---> 
				) as Shipped, <!--- quantity shipped to customer --->
				
				(SELECT    ISNULL(SUM(TransactionQuantity), 0) 
				 FROM      Materials.dbo.ItemTransaction
				 WHERE     WorkOrderId = WOL.WorkOrderId
				 AND       WorkOrderLine = WOL.WorkOrderLine
				 AND       RequirementId  = WOL.WorkOrderItemId
				  AND      TransactionType IN ('3')  <!--- 10/3/2014 removed '8' for the transaction type --->
				) as Returns, <!--- quantity returned to customer --->
							
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
	    ORDER BY I.Classification, I.ItemDescription, U.UoMDescription
								
</cfquery>


<cfif get.ActionStatus eq "1" or get.ActionStatus eq "0">
	<cfset mode = "edit">
<cfelse>
	<cfset mode = "view">
</cfif>

<cfoutput>
			
	<table width="100%" height="100%" style="min-height:300" class="navigation_table">		
			
		<cfquery name="Totals" dbtype="query">
				SELECT   '#get.Currency#' as Currency, 
				         SUM(SaleAmountIncome) as AmountIncome, 		
						 SUM(SaleAmountTax) as AmountTax,				 
						 count(*) as Lines,
						 SUM(Earmarked) as Earmarked
				FROM     ItemFinished				
		</cfquery>
		
		<cfloop query="Totals">
												
			<tr>
				<td align="right">
				<table width="100%">
					<tr class="labelmedium2" style="background-color:ffffff;height:26px;border-bottom:1px solid silver;">
						<td align="left" style="padding:2px">
							<table cellspacing="0" cellpadding="0">
							<tr class="labelmedium2">
							<cfif mode eq "edit">
								<td style="height:30px"></td>															
								<td style="padding-left:6px;font-size:16px;">
								  <cf_tl id="Generate Bill of Materials for order" var="1">
								  <input type="button" style="width:370px;border:1px solid silver" class="button10g" value="#lt_text#" onclick="getBOM('#url.workorderid#','#url.workorderline#','finalproduct')">								 				  								 
								</td>
							</cfif>
							</tr>
							</table>
						</td>
						<td style="padding-left:5px">#Lines#</td>
						<td style="padding-left:5px">
						
						<cfif totals.Earmarked gte "1" or get.actionStatus gte "3">						
						#get.Currency#
						<cfelse>
						
						<cfquery name="currencylist" 
						datasource="AppsLedger"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">						
							SELECT   Currency
							FROM     Currency
						</cfquery>
						
						<select name="Currency" class="regularxl" onchange="ptoken.navigate('#session.root#/workorder/application/Assembly/Items/FinalProduct/setCurrency.cfm?workorderid=#url.workorderid#&currency='+this.value,'cur')">
						<cfloop query="CurrencyList">
							<option value="#Currency#" <cfif currency eq get.Currency>selected</cfif>>#Currency#</option>
						</cfloop>
						</select>
						
						</cfif>
						
						</td>
						<td id="cur"></td>
						<td style="border-left:1px solid silver;padding-right:13px;padding-left:5px" align="right"><cf_tl id="Sale">:</td>
						<td style="border-left:1px solid silver;font-size:16px;padding-right:13px;padding-left:5px">#numberformat(AmountIncome,',.__')#</td>
						<td style="border-left:1px solid silver;padding-right:13px;padding-left:5px" align="right"><cf_tl id="Tax">:</td>
						<td style="border-left:1px solid silver;font-size:16px;padding-right:13px;padding-left:5px">#numberformat(AmountTax,',.__')#</td>		
						<td style="border-left:1px solid silver;font-size:16px;padding-right:13px;padding-left:5px" align="right">#numberformat(AmountIncome+AmountTax,',.__')#</td>
					</tr>				
				</table>			
				</td>
			</tr>								
									
		</cfloop>
						
		<tr>
			<td height="100%">
			
				<cf_divscroll>
	
					<table width="100%">			
					
						<tr class="line labelmedium2 fixrow fixlengthlist">
						
							<td colspan="2" style="height:40px;font-size:16px">
							
							</td>
														
							<td><cf_tl id="Item">
							
							 <cfif mode eq "edit">
							      <cf_tl id="Add" var="1">
							      <input type="button" onclick="javascript:addFinalProduct('#url.WorkOrderId#','#url.WorkOrderLine#','','');" style="width:65px;border:1px solid silver" class="button10g" value="#lt_text#">																
							   </cfif>
							
							</td>								
							<cfif line.ServiceType eq "WorkOrder">	
							<td><cf_tl id="Color"></td>				
							<cfelse>
							<td><cf_tl id="Code"></td>	
							</cfif>			
							<td><cf_tl id="UoM"></td>								
							<td><cf_tl id="BOM"></td>								
							<td><cf_tl id="Cost">#Application.BaseCurrency#</td>
							
							<td align="right"><cf_tl id="Order"></td>	
							<td align="right"><cf_tl id="Price"></td>						
							<td align="right"><cf_tl id="Total">#get.Currency#</td>		
							
							<cfif line.ServiceType eq "WorkOrder" or Line.ServiceType eq "Sale">
							<td align="center"><cf_tl id="Outsource"></td>
							</cfif>							
							<td align="center"><cf_tl id="InStock"></td>
						
							<td align="right"><cf_UIToolTip  tooltip="Available earmarked stock"><cf_tl id="Earmarked"></cf_UIToolTip><cf_space spaces="15"></td>
											
							<td align="center"><cf_tl id="To ship"></td>
							
							<cfif line.pointerSale eq "1">
								<td align="center"><cf_tl id="Shipped"></td>
							<cfelse>
								<td align="center"><cf_tl id="Freed"></td>
							</cfif>
							
							<td align="center"><cf_tl id="Pending"></td>
							<td align="center"><cf_tl id="Returns"></td>
							
						</tr>					
																						
						<cfloop query="ItemFinished">
						
							<tr class="navigation_row line labelmedium fixlengthlist" style="height:22px">
							
								<td style="height:15px">
								
									<cfif mode eq "edit">
									
										<table>
											<tr>
												<td style="padding-top:2px" onclick="editFinalProduct('#url.WorkOrderId#','#url.WorkOrderLine#','#workorderitemid#');">												
													<cf_img icon="open" onclick="editFinalProduct('#url.WorkOrderId#','#url.WorkOrderLine#','#workorderitemid#');" navigation="yes">													
												</td>
												<td style="padding-top:2px">
												
												    <cfif Requested eq "0" 
														and Earmarked eq "0" 
														and Shipped eq "0">													
														
														<cf_img icon="delete" onclick="removeFinalProduct('#url.WorkOrderId#','#url.WorkOrderLine#','#ItemNo#','#UoM#','#SaleType#');">
														
												    </cfif>
													
												</td>												
											</tr>
										</table>
										
									</cfif>	
								
								</td>		
								
								<td align="right">#currentrow#.</td>													
								<td title="#itemDescription#">
								<cfif SaleType eq "Promotion"><font color="800040">P:
								<cfelseif SaleType eq "Discount"><font color="008000">D:
								</cfif>#ItemDescription#</td>
								<cfif line.ServiceType eq "WorkOrder">	
								<td>#ItemColor#</td>		
								<cfelse>
									<cfif itembarcode neq "">								
									<td><a href="javascript:item('#itemno#','','#get.mission#')">#ItemBarcode#</a></td>
									<cfelse>
									<td><a href="javascript:item('#itemno#','','#get.mission#')">#ItemNoExternal#</a></td>
									</cfif>
								</cfif>		
								<td>#UoMDescription#</td>												
								
								<td bgcolor="FFBC9B">	
								
									<table width="100%">
										
										<tr class="labelmedium" style="height:20px">
											<td width="20">													
											<cf_img icon="expand" 
											   id="exp_#WorkOrderItemId#" 
											   toggle="Yes" 
											   onclick="toggleobjectbox('resourcebox_#WorkOrderItemId#','resource_#WorkOrderItemId#','#SESSION.Root#/WorkOrder/Application/Assembly/Items/FinalProduct/FinalProductBOM.cfm?WorkOrderItemId=#WorkOrderItemId#')"
											   tooltip="See Bill of materials for this quote.">									      											      									   
											</td>
											<td style="padding-right:4px" align="right">#Resources#</td>																					
										</tr>
										
									</table>	
									   
								</td>		
															
								<td align="right" bgcolor="ffbc9b" style="background-color:##ffbc9b80;border-left:1px solid gray">#numberformat(Cost,',.__')#</td>																	
								<td bgcolor="A8EFF2" style="background-color:##A8EFF280;border-left:1px solid gray" align="right">#numberformat(Quantity,'__')#</td>								
								
								<td style="border-left:1px solid gray" align="right"><cfif BillingMode neq "None">#numberformat(SalePrice,',.___')#</cfif></td>	
								<td style="border-left:1px solid gray" align="right"><cfif BillingMode neq "None">#numberformat(SaleAmountIncome,',')#</cfif></td>
																								
								<cfif line.ServiceType eq "WorkOrder" or line.serviceType eq "Sale">
								
									<td bgcolor="D0FBD6" style="background-color:##D0FBD680;border-left:1px solid gray;">
									
										<table width="100%">
										
											<tr class="labelmedium" style="height:20px">						
											
												<td>	
																																
												<cf_img icon = "expand" 
												   id        = "req_#WorkOrderItemId#" 
												   toggle    = "Yes" 
												   onclick   = "toggleobjectbox('requestbox_#WorkOrderItemId#','request_#WorkOrderItemId#','../../Assembly/Items/FinalProduct/FinalProductRequisition.cfm?WorkOrderId=#URL.WorkOrderId#&WorkOrderItemId=#WorkOrderItemId#')"
												   tooltip   = "See outsourced requisitions for this quote.">
												   
												</td>
																												
												<td id="xxrequest_#WorkOrderItemId#" style="width:100%" align="right">#numberformat(Outsourced,'__')#</td>	
												
												<td align="right">
												
												<cfset bal = quantity-shipped>
																														
												 <cfif mode eq "edit" and bal gt 0>
													<cf_tl id="add requisition" var="1">
													<cf_img icon="open" tooltip="Add Requisition" onclick="requisitionadd('#get.Mission#','#url.WorkOrderId#','#url.WorkOrderLine#','#workOrderItemId#','#workOrderItemId#');">
												 </cfif>	
												 								   
												</td>																	
																				
											</tr>
											
										</table>	
																
									</td>
								
								</cfif>
																
								<td bgcolor="D0FBD6" align="right" style="background-color:##D0FBD680;border-left:1px solid gray">#instock#</td>								
																
								<td style="padding-right:3px;border-left:1px solid gray;background-color:##ffffaf" align="right">
								
									<table width="100%">
										
											<tr class="labelmedium" style="height:20px">																				
											<td width="20">	
																																
											<cf_img icon="expand" 
													   id="ear_#WorkOrderItemId#" 
													   toggle="Yes" 
													   onclick="toggleobjectbox('earmarkbox_#WorkOrderItemId#','earmark_#WorkOrderItemId#','../../Assembly/Items/FinalProduct/getDetailLines.cfm?WorkOrderId=#URL.WorkOrderId#&drillid=#WorkOrderItemId#')"
													   tooltip="See earmarked stock for this quote.">
											
											</td>											
											<td align="right">#numberformat(Earmarked,'__')#</td>													
											</tr>
									
									</table>		
								
								</td>
															
								<td style="border-left:1px solid gray;padding-left:1px;background-color:##f1f1f180" align="right">
								
									<table width="100%">
										
											<tr class="labelmedium" style="height:20px">												
											<td width="20">	
											
												<cf_img icon="expand" 
												   id="ear_#WorkOrderItemId#" 
												   toggle="Yes" 
												   onclick="toggleobjectbox('earmarkbox_#WorkOrderItemId#','earmark_#WorkOrderItemId#','../../Assembly/Items/FinalProduct/getDetailLines.cfm?WorkOrderId=#URL.WorkOrderId#&drillid=#WorkOrderItemId#')"
												   tooltip="See details for this column.">
									
											</td>										
											<td align="right">
												<cfif OnHandForOrder gt "0">
													#numberformat(OnHandForOrder,'__')#
												<cfelse>
												    --	
												</cfif>
											</td>												
											</tr>
									
									</table>		
								
								</td>
								
								<cfif BillingMode eq "None">
								
									<td align="right" colspan="2"></td>
									
								<cfelse>
								
									<td align="right" bgcolor="e1e1e1" style="background-color:##e1e1e180;border-left:1px solid gray">#Shipped#</td>
																	
									<cfset bal = quantity-shipped>
									<cfif bal gt 0>
									<td style="background-color:##ffffaf80;border-left:1px solid gray" align="right">#bal#</b></td>
									<cfelse>
									<td align="center" style="font-size:10px;background-color:green;color:white;border-left:1px solid gray"><cf_tl id="complete"></td>
									</cfif>
									
								</cfif>
								
								<td align="right" style="background-color:##E3E8C680;border-left:1px solid gray;border-right:1px solid silver;">
								<cfif Returns gt "0">
								#numberformat(Returns,'__')#
								<cfelse>
								--
								</cfif>
								</td>
								
							</tr>
							
							<tr id="resourcebox_#ItemFinished.WorkOrderItemId#" class="hide">
							    <td></td>
								<td style="padding:3px" colspan="14" id="resource_#ItemFinished.WorkOrderItemId#"></td>							
							</tr>						
							
							<!--- button to support the refresh of the content from the dialog of the requisition --->
							
							<input type="button"
							       class="hide"
							       id="process_#workorderitemid#" 
								   value="process_#workorderitemid#" 
								   onclick="ptoken.navigate('../../Assembly/Items/FinalProduct/FinalProductRequisition.cfm?WorkOrderId=#URL.WorkOrderId#&workorderitemid=#workorderitemid#','request_#workorderitemid#')">
																				
							<tr id="requestbox_#workorderitemid#" class="hide">
							    <td></td>
							    <td colspan="15" id="request_#WorkOrderItemId#"></td>													
							</tr>
							
							<tr id="earmarkbox_#workorderitemid#" class="hide">
							    <td></td>
							    <td colspan="15" id="earmark_#WorkOrderItemId#"></td>													
							</tr>
							
																							
						</cfloop>
										
					</table>
				
				</cf_divscroll>
			
			</td>
		</tr>
		
		<tr><td style="height:30px"></td></tr>
						
	</table>

</cfoutput>

<script>
	Prosis.busy('no')
</script>
<cfset AjaxOnLoad("doHighlight")>