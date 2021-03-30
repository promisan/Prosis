

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
				I.ItemDescription,
				U.UoM, 
				U.UoMDescription, 
				WOL.Quantity, 
				WOL.SaleType,
				
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
				
				<cfif line.ServiceType eq "WorkOrder">		
				
				(
				 SELECT ISNULL(SUM(RequestQuantity),0) 
				 FROM   Purchase.dbo.RequisitionLine
				 WHERE  Mission       = '#get.Mission#'						 
				 AND    RequirementId = WOL.WorkOrderItemId 
				 AND    ActionStatus >= '1' and ActionStatus < '9'
				) as Outsourced,
				
				<cfelse>							
								
				<cfinvoke component = "Service.Process.WorkOrder.WorkorderLineItem"  
				   method           = "InternalWorkOrder" 
				   mission          = "#get.Mission#"
				   mode             = "view"
				   returnvariable   = "NotEarmarked">	
				
				(
				 SELECT    ISNULL(SUM(TransactionQuantity), 0) 
				 FROM      Materials.dbo.ItemTransaction
				 WHERE     Mission         = '#get.Mission#'				 
				 AND       ItemNo            = WOL.ItemNo
				 AND       TransactionUoM    = WOL.UoM		
				 
				 <!--- individual mode issuing from the roll (Hicosa) is not supported for
				 reservation yet --->
				 
				 AND       ItemCategory IN (SELECT Category 
				                            FROM   Materials.dbo.Ref_Category 
											WHERE  StockControlMode = 'Stock')
				 <!--- not earmarked stock --->
				 AND       (
				         (RequirementId IS NULL) 	
						  OR 
						  RequirementId IN (#preservesingleQuotes(notearmarked)#)
						  )
						 				 
				 AND       ActionStatus IN ('0','1')
				) as InStock,
				
				</cfif>
				
				(
				 SELECT ISNULL(SUM(RequestQuantity),0) 
				 FROM   Purchase.dbo.RequisitionLine
				 WHERE  Mission       = '#get.Mission#'						 
				 AND    RequirementId = WOL.WorkOrderItemId 
				 AND    ActionStatus != '9'
				) as Requested,
				
				(
				 SELECT ISNULL(SUM(RequestQuantity),0) 
				 FROM   Purchase.dbo.RequisitionLine
				 WHERE  Mission       = '#get.Mission#'						 
				 AND    RequirementId = WOL.WorkOrderItemId 
				 AND    ActionStatus = '3'
				) as Obligated,
												
				( 
				 SELECT    ISNULL(SUM(TransactionQuantity), 0) 
				 FROM      Materials.dbo.ItemTransaction
				 WHERE     Mission           = '#get.Mission#'		
				 AND       TransactionType != '2'
				 AND       RequirementId = WOL.WorkOrderItemId
				) as Earmarked,  <!--- quantity received 1, transferred 8 or quantity internally produced 0 for this order --->							
												
				( 
				 SELECT    ISNULL(SUM(TransactionQuantity), 0) 
				 FROM      Materials.dbo.ItemTransaction
				 WHERE     Mission           = '#get.Mission#'				 
				 AND       RequirementId     = WOL.WorkOrderItemId								
				) as OnHandForOrder,  <!--- quantity received  / issued local onhand for this workorder which is TO SHIP --->
								
				<!--- returned quantities which is tratype 5 --->
				
				( 
				 SELECT    ISNULL(SUM(TransactionQuantity*-1), 0) AS Shipped
				 FROM      Materials.dbo.ItemTransaction
				 WHERE     TransactionType IN ('2','3')  <!--- 10/3/2014 removed '8' for the transaction type --->
				 AND       Mission       = '#get.Mission#'			
				 AND       RequirementId = WOL.WorkOrderItemId
				) as Shipped, <!--- quantity shipped to customer --->
				
				( 
				 SELECT    ISNULL(SUM(TransactionQuantity), 0) AS Shipped
				 FROM      Materials.dbo.ItemTransaction
				 WHERE     TransactionType IN ('3')  <!--- 10/3/2014 removed '8' for the transaction type --->
				 AND       Mission       = '#get.Mission#'			
				 AND       RequirementId = WOL.WorkOrderItemId
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
			
	<table width="100%" height="100%" style="min-width:800;min-height:300" class="navigation_table">		
			
		<cfquery name="Totals" dbtype="query">
				SELECT   '#get.Currency#' as Currency, 
				         SUM(SaleAmountIncome) as AmountIncome, 		
						 SUM(SaleAmountTax) as AmountTax,				 
						 count(*) as Lines,
						 SUM(Earmarked) as Earmarked
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
								  <a href="##" onclick="getBOM('#url.workorderid#','#url.workorderline#','finalproduct')">
								  <font color="0080C0">[<cf_tl id="Generate Bill of Materials for order">]</font>								  
								  </a>
								</td>
							</cfif>
							</tr>
							</table>
						</td>
						<td valign="bottom" style="padding-left:5px" class="labelmedium">#Lines#</td>
						<td valign="bottom" style="padding-left:5px" class="labelmedium">
						
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
						<td valign="bottom" style="padding-right:13px;padding-left:5px" class="labelmedium"  align="right"><cf_tl id="Sale">:</td>
						<td valign="bottom" style="padding-right:13px;padding-left:5px" class="labelmedium">#numberformat(AmountIncome,',.__')#</td>
						<td valign="bottom" style="padding-right:13px;padding-left:5px" class="labelmedium"  align="right"><cf_tl id="Tax">:</td>
						<td valign="bottom" style="padding-right:13px;padding-left:5px" class="labelmedium">#numberformat(AmountTax,',.__')#</td>		
						<td valign="bottom" style="padding-right:13px;padding-left:5px" class="labellarge"  align="right">#numberformat(AmountIncome+AmountTax,',.__')#</td>
					</tr>				
				</table>			
				</td>
			</tr>				
								
									
		</cfloop>
						
		<tr>
			<td style="padding:1px;" height="100%">
			
				<cf_divscroll>
	
					<table width="99%" cellspacing="0" cellpadding="0">			
					
						<tr class="line labelmedium2">
						
							<td width="5%" style="padding-left:3px">
							   <cfif mode eq "edit">
								<a href="javascript:addFinalProduct('#url.WorkOrderId#','#url.WorkOrderLine#','','');">
								<cf_tl id="Add">
								</a>
							   </cfif>
							</td>
							
							<td style="width:40"></td>
							
							<td style="width:100%"><cf_tl id="Description"></td>								
							<cfif line.ServiceType eq "WorkOrder">	
							<td style="min-width:80px"><cf_tl id="Color"></td>				
							<cfelse>
							<td style="min-width:80px"><cf_tl id="Code"></td>	
							</cfif>			
							<td style="min-width:70px"><cf_tl id="UoM"></td>								
							<td style="min-width:50px"><cf_tl id="BOM"></td>								
							<td style="min-width:80px"><cf_tl id="Cost">#Application.BaseCurrency#</td>
							
							<td style="min-width:70px;padding-left:2px;padding-right:2px" align="right"><cf_tl id="Order"></td>	
							<td style="min-width:80px;padding-left:2px;padding-right:2px" align="right"><cf_tl id="Price"></td>						
							<td style="min-width:80px;padding-left:2px;padding-right:2px" align="right"><cf_tl id="Total">#get.Currency#</td>		
							
							<cfif line.ServiceType eq "WorkOrder">
							<td style="min-width:70px;padding-left:2px;padding-right:2px" align="center"><cf_tl id="Outsourced"></td>	
							<cfelse>
							<td style="min-width:70px;padding-left:2px;padding-right:2px" align="center"><cf_tl id="InStock"></td>
							</cfif>
							
							<td style="min-width:70px;;padding-left:2px;padding-right:2px;cursor:pointer" align="right"><cf_UIToolTip  tooltip="Available earmarked stock"><cf_tl id="Earmarked"></cf_UIToolTip><cf_space spaces="15"></td>
											
							<td style="min-width:70px;;padding-left:2px;padding-right:2px" align="center"><cf_tl id="To ship"></td>
							
							<cfif line.pointerSale eq "1">
								<td style="min-width:70px;padding-left:2px;padding-right:2px" align="center"><cf_tl id="Shipped"></td>
							<cfelse>
								<td style="min-width:70px;padding-left:2px;padding-right:2px" align="center"><cf_tl id="Freed"></td>
							</cfif>
							
							<td style="min-width:70px;padding-left:2px;padding-right:2px" align="center"><cf_tl id="Pending"></td>
							<td style="min-width:70px;padding-left:2px;padding-right:2px" align="center"><cf_tl id="Returns"></td>
							
						</tr>					
																						
						<cfloop query="ItemFinished">
						
							<tr class="navigation_row line labelmedium2" style="height:25px">
							
								<td align="center" style="height:15">
								
									<cfif mode eq "edit">
									
										<table width="40">
											<tr>
												<td style="padding-top:2px" onclick="editFinalProduct('#url.WorkOrderId#','#url.WorkOrderLine#','#workorderitemid#');">												
													<cf_img icon="edit" onclick="editFinalProduct('#url.WorkOrderId#','#url.WorkOrderLine#','#workorderitemid#');" navigation="yes">													
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
								<td style="padding-left:3px">
								<cfif SaleType eq "Promotion"><font color="800040">P:
								<cfelseif SaleType eq "Discount"><font color="008000">D:
								</cfif>#ItemDescription#</td>
								<cfif line.ServiceType eq "WorkOrder">	
								<td>#ItemColor#</td>		
								<cfelse>
								<cfif itembarcode neq "">								
								<td>#ItemBarcode#</td>
								<cfelse>
								<td>#Classification#</td>
								</cfif>
								</cfif>		
								<td style="padding-right:2px">#UoMDescription#</td>												
								
								<td bgcolor="FFBC9B">	
								
									<table width="100%">
										
										<tr class="labelit">
											<td width="20" style="padding-left:5px;padding-top:3px">			
										
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
															
								<td align="right" bgcolor="ffbc9b" style="background-color:##ffbc9b80;border-left:1px solid gray;padding-right:5px">#numberformat(Cost,',.__')#</td>																	
								<td bgcolor="A8EFF2" style="background-color:##A8EFF280;border-left:1px solid gray;padding-right:5px" align="right">#numberformat(Quantity,'__')#</td>								
								
								<td style="border-left:1px solid gray;padding-right:3px" align="right"><cfif BillingMode neq "None">#numberformat(SalePrice,',.__')#</cfif></td>	
								<td style="border-left:1px solid gray;padding-right:3px" align="right"><cfif BillingMode neq "None">#numberformat(SaleAmountIncome,',')#</cfif></td>
								
								<cfif line.ServiceType eq "WorkOrder">
								
									<td bgcolor="D0FBD6" style="background-color:##D0FBD680;border-left:1px solid gray;padding-right:2px">
									
										<table width="100%" cellspacing="0" cellpadding="0">
										
											<tr class="labelmedium">									
											
												<td width="15" style="padding-top:3px">			
																				
												<cf_img icon="expand" 
												   id="req_#WorkOrderItemId#" 
												   toggle="Yes" 
												   onclick="toggleobjectbox('requestbox_#WorkOrderItemId#','request_#WorkOrderItemId#','../../Assembly/Items/FinalProduct/FinalProductRequisition.cfm?WorkOrderId=#URL.WorkOrderId#&WorkOrderItemId=#WorkOrderItemId#')"
												   tooltip="See outsourcing for this quote.">
												   
												</td>
												
												<td width="20"  style="padding-top:3px">											
												 <cfif mode eq "edit">
													<cf_tl id="add requisition" var="1">
													<cf_img icon="add" tooltip="Add Requisition" onclick="requisitionadd('#get.Mission#','#url.WorkOrderId#','#url.WorkOrderLine#','#workOrderItemId#','#workOrderItemId#');">
												 </cfif>									   
												</td>		
																			
												<td width="90%" align="right">#numberformat(Outsourced,'__')#</td>	
																				
											</tr>
											
										</table>	
																
									</td>
								
								<cfelse>
																
								<td bgcolor="D0FBD6" align="right" style="background-color:##D0FBD680;border-left:1px solid gray;padding-right:2px">#instock#</td>								
								
								</cfif>
								
								
								<td style="padding-right:3px;border-left:1px solid gray;padding-left:5px'background-color:##ffffaf" align="right" bgcolor="ffffcf">
								
								<table width="100%" cellspacing="0" cellpadding="0">
									
										<tr class="labelit">									
										
										<td width="20" style="padding-top:3px;padding-left:1px">	
										
										
										<cf_img icon="expand" 
												   id="ear_#WorkOrderItemId#" 
												   toggle="Yes" 
												   onclick="toggleobjectbox('earmarkbox_#WorkOrderItemId#','earmark_#WorkOrderItemId#','../../Assembly/Items/FinalProduct/getDetailLines.cfm?WorkOrderId=#URL.WorkOrderId#&drillid=#WorkOrderItemId#')"
												   tooltip="See outsourcing for this quote.">
										
										</td>
										
										<td align="right">#numberformat(Earmarked,'__')#</td>		
										
										</tr>
								
								</table>		
								
								</td>
															
								<td style="padding-right:3px;;border-left:1px solid gray;padding-left:5px;background-color:##f1f1f180" align="right" bgcolor="f1f1f1">
								
									<table width="100%" cellspacing="0" cellpadding="0">
										
											<tr class="labelit">												
											<td width="20" style="padding-top:3px;padding-left:1px">	
											
												<cf_img icon="expand" 
														   id="ear_#WorkOrderItemId#" 
														   toggle="Yes" 
														   onclick="toggleobjectbox('earmarkbox_#WorkOrderItemId#','earmark_#WorkOrderItemId#','../../Assembly/Items/FinalProduct/getDetailLines.cfm?WorkOrderId=#URL.WorkOrderId#&drillid=#WorkOrderItemId#')"
														   tooltip="See details for this column.">
											
											</td>										
											<td align="right">
											<cfif OnHandForOrder gt "0">
												#numberformat(OnHandForOrder,'__')#
											</cfif>
											</td>												
											</tr>
									
									</table>		
								
								</td>
								
								<cfif BillingMode eq "None">
								
									<td align="right" colspan="2" style="padding-right:3px"></td>
									
								<cfelse>
								
									<td align="right" bgcolor="e1e1e1" style="background-color:##e1e1e180;padding-right:3px;border-left:1px solid gray;padding-left:5px">#Shipped#</td>
																	
									<cfset bal = quantity-shipped>
									<cfif bal gt 0>
									<td bgcolor="ffffaf" style="background-color:##ffffaf80;padding-right:3px;border-left:1px solid gray;padding-left:5px" align="right">#bal#</b></td>
									<cfelse>
									<td bgcolor="white" align="right" style="padding-right:10px">
									<img src="#session.root#/images/check_icon.gif" alt="Completed" border="0">
									</td>
									</cfif>
									
								</cfif>
								
								<td align="right" bgcolor="E3E8C6" style="background-color:##E3E8C680;padding-right:3px;border-left:1px solid gray;padding-left:5px">
								#returns#
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
								   onclick="ColdFusion.navigate('../../Assembly/Items/FinalProduct/FinalProductRequisition.cfm?WorkOrderId=#URL.WorkOrderId#&workorderitemid=#workorderitemid#','request_#workorderitemid#')">
																				
							<tr id="requestbox_#workorderitemid#" class="hide">
							    <td></td>
							    <td colspan="14" id="request_#WorkOrderItemId#"></td>													
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
						
	</table>

</cfoutput>

<script>
	Prosis.busy('no')
</script>
<cfset AjaxOnLoad("doHighlight")>