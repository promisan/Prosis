

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
				I.Classification,
				I.ItemDescription,
				U.ItemBarcode,
				U.UoM, 
				U.UoMDescription, 
				WOL.Quantity, 
				
				(
				 SELECT count(*) 
				 FROM   WorkOrderLineItemResource
				 WHERE  WorkOrderItemId = WOL.WorkOrderItemId 
				) as Resources,
				
				(
				 SELECT SUM(Amount) 
				 FROM   WorkOrderLineItemResource
				 WHERE  WorkOrderItemId = WOL.WorkOrderItemId 
				) as Cost,		
				
				(
				 SELECT StandardCost 
				 FROM   Materials.dbo.ItemUoMMission
				 WHERE  ItemNo = WOL.ItemNo
				 AND    UoM = WOL.UoM
				 AND    Mission = WO.Mission 
				) as StandardCost,												
								
				( 
				 SELECT    ISNULL(SUM(TransactionQuantity), 0)
				 FROM      Materials.dbo.ItemTransaction
				 WHERE     TransactionType IN ('0')  
				 AND       Mission       = '#get.Mission#'			
				 AND       RequirementId = WOL.WorkOrderItemId
				 AND       ActionStatus = '1'
				) as Confirmed, <!--- quantity shipped to customer --->
				
				<!---
				
				( 
				 SELECT    ISNULL(SUM(TransactionQuantity), 0) AS Shipped
				 FROM      Materials.dbo.ItemTransaction
				 WHERE     TransactionType IN ('3')  <!--- 10/3/2014 removed '8' for the transaction type --->
				 AND       Mission       = '#get.Mission#'			
				 AND       RequirementId = WOL.WorkOrderItemId
				) as Returns, <!--- quantity returned to customer --->
				
				--->
												
				( 
				 SELECT    ISNULL(SUM(TransactionQuantity), 0) 
				 FROM      Materials.dbo.ItemTransaction S
				 WHERE     Mission           = '#get.Mission#'				 
				 AND       RequirementId     = WOL.WorkOrderItemId		
				 <!--- added hanno to exclude the usage of items by sales workorders transfer --->
				 AND       TransactionType NOT IN ('6','8')						
				) as OnHand,  <!--- quantity received in production warehouse --->
				
				
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
						 count(*) as Lines
				FROM     ItemFinished				
		</cfquery>
		
		<cfloop query="Totals">
												
			<tr class="line">
				<td align="right">
				<table width="100%">
					<tr>
						<td width="40%" class="labelmedium" align="left" style="padding:2px">
							<table cellspacing="0" cellpadding="0">
							<tr>
							
							<cfif mode eq "edit">
								<td style="height:30px"></td>															
								<td style="padding-left:6px;padding-top:28px" class="labelmedium">
								  <a href="##" onclick="getBOM('#url.workorderid#','#url.workorderline#','halfproduct')">
								  <font color="0080C0">[<cf_tl id="Generate Bill of Materials">]</font>								  
								  </a>
								</td>
								<td style="height:30px"></td>															
								<td style="padding-left:6px;padding-top:28px" class="labelmedium">
								  <a href="##" onclick="issueStock('#url.workorderid#','#url.workorderline#','halfproduct')">
								  <font color="0080C0">[<cf_tl id="Issue Produced stock">]</font>								  
								  </a>
								</td>
							</cfif>
							
							</tr>
							</table>
						</td>
						<td style="padding-left:5px" class="labelmedium">#Lines#</td>
						<td style="padding-left:5px" class="labelmedium">#get.Currency#</td>
						<td style="padding-right:13px;padding-left:5px" class="labelmedium"  align="right"><b>#numberformat(AmountIncome,',.__')#</b></td>
					</tr>				
				</table>			
				</td>
			</tr>				
			<tr><td colspan="16" class="line"></td></tr>							
									
		</cfloop>
						
		<tr>
			<td style="padding:3px;" height="100%">
			
				<cf_divscroll>
	
					<table width="99%" cellspacing="0" cellpadding="0">			
					
						<tr class="line labelit">
						
							<td width="5%" class="labelit" style="font-size:15px;padding-left:3px">
							   <cfif mode eq "edit">
								<a href="javascript:addHalfProduct('#url.WorkOrderId#','#url.WorkOrderLine#','','');" style="color:gray;">
								[<cf_tl id="Add">]
								</a>
							   </cfif>
							</td>
							
							<td class="labelsmall" style="width:30"></td>
							<td><cf_tl id="Code"></td>
							<td><cf_tl id="Description"></td>		
							<td><cf_tl id="BarCode"></td>							
							<td><cf_tl id="UoM"></td>								
							<td><cf_tl id="BOM"></td>								
							<td><cf_tl id="Cost">#Application.BaseCurrency#</td>
							
							<td align="right"><cf_tl id="Planning"></td>	
							<td align="right"><cf_space spaces="10"><cf_tl id="Price"></td>						
							<td align="right"><cf_tl id="Total">#get.Currency#</td>		
							
							<td align="right"><cf_tl id="Produced"><cf_space spaces="20"></td>	
							
							<!---
							<td style="cursor:pointer" align="right"><cf_UIToolTip  tooltip="Available earmarked stock"><cf_tl id="Earmarked"></cf_UIToolTip><cf_space spaces="15"></td>
											
							<td align="right"><cf_tl id="To ship"><cf_space spaces="15"></td>
							--->
							
							<td align="right"><cf_tl id="To confirm"><cf_space spaces="15"></td>
							
							<!---
							
							<td align="right"><cf_tl id="Pending"><cf_space spaces="15"></td>
							--->
														
						</tr>					
																						
						<cfloop query="ItemFinished">
						
							<tr class="navigation_row line labelit">
							
								<td align="center" style="height:20;padding-top:2px">
								
									<cfif mode eq "edit">
									
										<table width="40">
											<tr>
												<td onclick="editFinalProduct('#url.WorkOrderId#','#url.WorkOrderLine#','#workorderitemid#');">												
													<cf_img icon="edit" onclick="editHalfProduct('#url.WorkOrderId#','#url.WorkOrderLine#','#workorderitemid#');" navigation="yes">													
												</td>
												<td style="padding-left:2px;">
												   	<cf_img icon="delete" onclick="removeHalfProduct('#url.WorkOrderId#','#url.WorkOrderLine#','#ItemNo#','#UoM#');">
												   
												</td>
												
											</tr>
										</table>
										
									</cfif>	
								
								</td>		
								
								<td class="labelsmall">#currentrow#</td>					
								<td>#Classification#</td>
								<td>#ItemDescription#</td>
								<td>#ItemBarCode#</td>
								<td>#UoMDescription#</td>												
								
								<td bgcolor="FFBC9B">	
								
									<table width="100%" cellspacing="0" cellpadding="0">
										<tr>
										<td width="20" style="padding-left:5px">			
									
										<cf_img icon="expand" 
										   id="exp_#WorkOrderItemId#" 
										   toggle="Yes" 
										   onclick="toggleobjectbox('resourcebox_#WorkOrderItemId#','resource_#WorkOrderItemId#','#SESSION.Root#/WorkOrder/Application/Assembly/Items/HalfProduct/HalfProductBOM.cfm?WorkOrderItemId=#WorkOrderItemId#')"
										   tooltip="See Bill of materials for this quote.">									      
										      									   
										</td>
										<td class="labelit" style="padding-right:4px" align="right">#Resources#</td>
										</tr>
									</table>	
									   
								</td>	
																							
								<td align="right" bgcolor="FFBC9B" style="border-left:1px solid gray;padding-right:5px">#numberformat(Cost,',.__')#</td>																	
								<td bgcolor="A8EFF2" style="border-left:1px solid gray;padding-right:5px" align="right">#numberformat(Quantity,'__')#</td>								
																
								<!--- the price --->
								
								<cfif Cost eq "0">
								
									<cfquery name="set" 
									datasource="AppsWorkOrder"
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										UPDATE WorkOrderLineItem
										SET    SalePrice        = '#standardcost#', 
										       SaleTax          = '0',
											   SaleAmountIncome = '#standardcost*quantity#',
											   SaleAmountTax    = '0'
										WHERE  WorkOrderItemId  = '#workorderitemid#'
									</cfquery>	
									
									<cfset pric = standardcost>
									<cfset amnt = standardcost*quantity>																			
								
								<cfelseif SaleAmountIncome neq cost and quantity neq "0" and cost neq "">
													
								    <cfset cost = round(cost*1000)/1000>
									<cfset pric = cost/quantity>
									<cfset amnt = cost>
																										
									<cfquery name="set" 
									datasource="AppsWorkOrder"
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										UPDATE  WorkOrderLineItem
										SET     SalePrice        = '#pric#', 
										        SaleTax          = '0',
											    SaleAmountIncome = '#amnt#',
											    SaleAmountTax    = '0'
										WHERE   WorkOrderItemId  = '#workorderitemid#'
									</cfquery>													
									
								<cfelse>
								
									<cfset pric = saleprice>
									<cfset amnt = saleamountincome>					
								
								</cfif>					
								
								<td style="border-left:1px solid gray;padding-right:3px" align="right"><cfif BillingMode neq "None">#numberformat(pric,',.__')#</cfif></td>	
								<td style="border-left:1px solid gray;padding-right:3px" align="right"><cfif BillingMode neq "None">#numberformat(amnt,',.__')#</cfif></td>																							
								<td style="padding-right:3px;;border-left:1px solid gray;padding-left:5px" align="right" bgcolor="f1f1f1">
								
									<table width="100%" cellspacing="0" cellpadding="0">
										
											<tr>												
											<td width="20" style="padding-left:5px">	
											
												<cf_img icon="expand" 
														   id="ear_#WorkOrderItemId#" 
														   toggle="Yes" 
														   onclick="toggleobjectbox('earmarkbox_#WorkOrderItemId#','earmark_#WorkOrderItemId#','../../Assembly/Items/HalfProduct/getDetailLines.cfm?WorkOrderId=#URL.WorkOrderId#&drillid=#WorkOrderItemId#')"
														   tooltip="See details for this column.">
											
											</td>										
											<td align="right" class="labelit">#numberformat(OnHand,'__')#</td>												
											</tr>
									
									</table>		
								
								</td>
								
								<!---							
								<td align="right" bgcolor="e1e1e1" style="padding-right:3px;border-left:1px solid gray;padding-left:5px">
								--->
								
																
								<cfset bal = quantity-confirmed>
								<cfif bal gt 0>
									<td bgcolor="yellow" style="padding-right:3px;border-left:1px solid gray;padding-left:5px;border-right:1px solid gray" align="right">#bal#</b></td>
								<cfelse>
									<td bgcolor="green" align="right" style="padding-right:4px;;border-right:1px solid gray">
									<img src="#session.root#/images/check_icon.gif" alt="Completed" border="0">
									</td>
								</cfif>
								
								<!---								
								</td>
								--->
								
								<!---									
								<cfset bal = quantity-confirmed>
								<cfif bal gt 0>
									<td bgcolor="ffffaf" style="padding-right:3px;border-left:1px solid gray;padding-left:5px" align="right">#bal#</b></td>
								<cfelse>
									<td bgcolor="white" align="right">
									<img src="#session.root#/images/check_icon.gif" alt="Completed" border="0">
									</td>
								</cfif>
								--->
																
							</tr>
							
							<tr id="resourcebox_#ItemFinished.WorkOrderItemId#" class="hide">
							    <td></td>
								<td style="padding:3px" colspan="15" id="resource_#ItemFinished.WorkOrderItemId#"></td>							
							</tr>						
							
							<!--- button to support the refresh of the content from the dialog of the requisition --->
							
							<input type="button"
							       class="hide"
							       id="process_#workorderitemid#" 
								   value="process_#workorderitemid#" 
								   onclick="ColdFusion.navigate('../../Assembly/Items/HalfProduct/HalfProductRequisition.cfm?WorkOrderId=#URL.WorkOrderId#&workorderitemid=#workorderitemid#','request_#workorderitemid#')">
																				
							
							<tr id="earmarkbox_#workorderitemid#" class="hide">
							    <td></td>
							    <td colspan="16" id="earmark_#WorkOrderItemId#"></td>													
							</tr>
																														
						</cfloop>
										
					</table>
				
				</cf_divscroll>
			
			</td>
		</tr>
						
	</table>

</cfoutput>

<script>
	Prosis.busy('no')
</script>
<cfset AjaxOnLoad("doHighlight")>