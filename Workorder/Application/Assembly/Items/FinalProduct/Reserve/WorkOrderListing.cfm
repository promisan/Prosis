
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
				 WHERE     Mission           = '#get.Mission#'		
				 AND       TransactionType != '2'
				 AND       RequirementId = WOL.WorkOrderItemId
				) as Reserved,  <!--- quantity received or quantity internally produced for this workorder --->
				
				( 
				 SELECT    ISNULL(SUM(TransactionQuantity*-1), 0) AS Shipped
				 FROM      Materials.dbo.ItemTransaction
				 WHERE     TransactionType IN ('2','3')  <!--- 10/3/2013 removed the '8' from the transaction type --->
				 AND       Mission       = '#get.Mission#'			
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
	    ORDER BY I.Classification, I.ItemDescription, U.UoMDescription
</cfquery>

<cfif get.ActionStatus eq "1" or get.ActionStatus eq "0">
	<cfset mode = "edit">
<cfelse>
	<cfset mode = "view">
</cfif>

<cfoutput>

<table width="100%" class="formpadding">

  <tr><td height="5"></td></tr>	
    
  <tr><td id="boxtransferto">
  
  	  <cfset url.mission = get.Mission>
	  <cfinclude template="setWarehouseTo.cfm">
	  
	  </td>
  </tr>
    			  
  <tr><td>
			
	<table width="100%" class="navigation_table">		
		
		<tr>
			<td style="padding:3px;" height="100%">
			
				<table width="100%" cellspacing="0" cellpadding="0">			
				
					<tr class="labelit line">
					
						<td width="5%"></td>
						<td style="width:30"></td>
						<td><cf_tl id="Code"></td>
						<td><cf_tl id="Description"></td>		
						<td><cf_tl id="Color"></td>							
						<td><cf_tl id="UoM"></td>					
						<td align="right"><cf_tl id="Ordered"></td>													
						<td align="right"><cf_tl id="InStock"></td>		
						<td align="right"><cf_tl id="Reserved"><cf_space spaces="15"></td>																		
						<cfif line.pointerSale eq "1">
							<td align="right"><cf_tl id="Shipped"><cf_space spaces="15"></td>
						<cfelse>
							<td align="right"><cf_tl id="Freed"><cf_space spaces="15"></td>
						</cfif>
						<td align="right"><cf_tl id="Pending"><cf_space spaces="15"></td>
						
					</tr>					
																					
					<cfloop query="ItemFinished">
					
						<cfset bal = quantity-shipped>
													
						<tr class="navigation_row line cellcontent">
						
							<td align="center" style="height:22">							    
								
								<cfif mode eq "edit">
								
									<cfif bal gt 0 
									    and instock gte "1" 
										and Reserved lt Quantity>	
										<input type="checkbox" checked name="selectline" value="'#workorderitemid#'">
									<cfelse>
										<input type="checkbox" name="selectline" value="'#workorderitemid#'">									
									</cfif>
																		
								</cfif>	
															
							</td>		
							
							<td>#currentrow#.</td>					
							<td>#Classification#</td>
							<td>#ItemDescription#</td>
							<td>#ItemColor#</td>
							<td>#uoMDescription#</td>																															
							<td bgcolor="A8EFF2" style="padding-right:5px" align="right">#numberformat(Quantity,'__')#</td>																
							<td bgcolor="e3e3e3" style="padding-right:5px" align="right">#numberformat(InStock,'__')#</td>
							
							<td style="padding-right:3px" align="right" bgcolor="ffffcf">
							
								<table width="100%" cellspacing="0" cellpadding="0">
									
										<tr>										
																			
										<td width="20" style="padding-left:5px">	
										
										<cf_img icon="expand" 
												   id="ear_#WorkOrderItemId#" 
												   toggle="Yes" 
												   onclick="toggleobjectbox('earmarkbox_#WorkOrderItemId#','earmark_#WorkOrderItemId#','#session.root#/Workorder/Application/Assembly/Items/FinalProduct/getDetailLines.cfm?WorkOrderId=#URL.WorkOrderId#&drillid=#WorkOrderItemId#')">
										
										</td>
																			
										<td align="right" class="labelit">#numberformat(Reserved,'__')#</td>		
										
										</tr>
								
								</table>		
							
							</td>
														
							<cfif BillingMode eq "None">
							
								<td align="right" colspan="2" style="padding-right:3px"></td>
								
							<cfelse>
								<td align="right" bgcolor="e1e1e1" style="padding-right:3px">#Shipped#</td>
																
								<cfif bal gt 0>
								<td bgcolor="ffffaf" style="padding-right:3px" align="right">#bal#</b></td>
								<cfelse>
								<td bgcolor="white" align="right">
									<img src="#session.root#/images/check_icon.gif" 
									   width="18" 
									   height="18" 
									   alt="Completed" 
									   border="0">
								</td>
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
						
						<input type  = "button" 
						     class   = "button10g" 
						     style   = "width:260px;height:28px" 
							 value   = "#apply#" 
							 name    = "Submit" 
							 onclick = "_cf_loadingtexthtml='';Prosis.busy('yes');ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/Assembly/Items/FinalProduct/Reserve/ReserveSubmit.cfm?mission=#get.mission#&warehouse=#url.warehouse#&workorderid=#url.workorderid#&workorderline=#url.workorderline#','orderbox','','','POST','reserveform')">
					
					</td></tr>
														
				</table>
				
			</td>
		</tr>
						
	</table>
	
	</td>
	</tr>
	
</table>

</cfoutput>

<script>
	Prosis.busy('no');
</script>

<cfset AjaxOnLoad("doHighlight")>