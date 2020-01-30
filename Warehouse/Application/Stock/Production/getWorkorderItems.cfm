
<!--- workorder items for entry by line --->

<cfparam name="url.workorderid" default="">
<cfparam name="url.receiptmode" default="FP">

<cfquery name="get" 
	datasource="AppsMaterials"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM Warehouse
	WHERE Warehouse = '#url.warehouse#'
</cfquery>	

<cfif url.receiptmode eq "FP">
	
	<cfquery name="Items" 
		datasource="AppsWorkOrder"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
			SELECT  WOL.WorkorderItemId as RequirementId,
					WOL.WorkOrderId,
					WOL.WorkOrderLine,
					(SELECT isNULL(SUM(TransactionQuantity),0)
					 FROM   Materials.dbo.ItemTransaction
					 WHERE  WorkorderId     = WOL.WorkorderId
					 AND    WorkorderLine   = WOL.WorkOrderLine
					 AND    RequirementId   = WOL.WorkorderItemId
					 <!---
					 AND    ItemNo          = WOL.ItemNo
					 AND    TransactionUoM  = WOL.UoM 
					 --->
					 AND    TransactionType = '0') as Already,          
					I.ItemNo, 
					I.ItemPrecision,
					I.ItemDescription,
					U.UoM, 
					I.Category,
					I.Classification,
					U.UoMDescription, 
					WOL.Quantity, 
					WOL.Currency, 
					WOL.SalePrice, 
					WOL.SaleAmountIncome,
					WOL.Created
			FROM    WorkOrderLineItem WOL 
					INNER JOIN Materials.dbo.Item I 
						ON WOL.ItemNo = I.ItemNo 
					INNER JOIN Materials.dbo.ItemUoM U 
						ON WOL.ItemNo = U.ItemNo 
						AND WOL.UoM = U.UoM
			WHERE	WOL.WorkOrderId = '#url.workorderid#' 
			ORDER BY WorkOrderLine, I.Classification, I.ItemDescription, U.UoMDescription
				
	</cfquery>

<cfelse>

		<cfquery name="Items" 
		datasource="AppsWorkOrder"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			SELECT  WOL.ResourceId as RequirementId,
					WOL.WorkOrderId,
					WOL.WorkOrderLine,
					(SELECT isNULL(SUM(TransactionQuantity),0)
					 FROM   Materials.dbo.ItemTransaction
					 WHERE  WorkorderId     = WOL.WorkorderId
					 AND    WorkorderLine   = WOL.WorkOrderLine
					 AND    RequirementId   = WOL.ResourceId
					 <!--- 
					 AND    ItemNo          = WOL.ResourceItemNo
					 AND    TransactionUoM  = WOL.ResourceUoM 
					 --->
					 AND    TransactionType = '0') as Already,          
					I.ItemNo, 
					I.ItemPrecision,
					I.ItemDescription,
					U.UoM, 
					I.Category,
					I.Classification,
					U.UoMDescription, 
					WOL.Quantity, 					
					WOL.Created
			FROM    WorkOrderLineResource WOL 
					INNER JOIN Materials.dbo.Item I 
						ON WOL.ResourceItemNo = I.ItemNo 
					INNER JOIN Materials.dbo.ItemUoM U 
						ON WOL.ResourceItemNo = U.ItemNo 
						AND WOL.ResourceUoM = U.UoM
			WHERE	  WOL.WorkOrderId = '#url.workorderid#' 
			AND       ResourceMode = 'Receipt'  <!--- provided by the customer --->			
			ORDER BY WorkOrderLine, I.Classification, I.ItemDescription, U.UoMDescription
		</cfquery>	

</cfif>

<cfquery name="Customer" 
	datasource="AppsWorkorder"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT C.CustomerName, W.Reference, W.OrderDate
	FROM   Workorder W, Customer C
	WHERE  WorkorderId = '#url.workorderid#'
	AND    W.CustomerId = C.CustomerId	
</cfquery>	

<cfoutput>

<script language="JavaScript">
	ColdFusion.navigate('#session.root#/warehouse/Application/Stock/Production/getWorkOrder.cfm?workorderid=#url.workorderid#','workorderselect')
</script>

</cfoutput>

<table width="100%" cellspacing="0" cellpadding="0">

	<tr><td style="height:30;padding-left:3px" class="labellarge">
	<cfoutput>
		<table>
		<tr>			
				<cfset link = "#session.root#/warehouse/Application/Stock/Production/getWorkOrderItems.cfm?warehouse=#url.warehouse#&workorderid=#url.workorderid#">			
				
				
				<input type="hidden" id="receiptmodeselected" value="#url.receiptmode#">
						
				<td style="padding-left:4px"><input type="radio" name="ReceiveMode" value="FP" <cfif url.receiptmode eq "FP">checked</cfif> onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#link#&receiptmode=FP','itemcontent')"></td>
				<td style="padding-left:5px" class="labelit">Finished product</td>
				<td style="padding-left:5px">
				<input type="radio" name="ReceiveMode" onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#link#&receiptmode=RAW','itemcontent')" <cfif url.receiptmode eq "RAW">checked</cfif> value="RAW">
				</td>
				<td class="labelit" style="padding-left:5px;padding-right:10px">Raw Materials received</td>
			
		</tr>
		</table>
	</cfoutput>
	
	</td></tr>
	<tr><td style="padding-left:7px" class="linedotted"></td></tr>
	
	<tr>
		<td style="padding:10px">

			<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">
			
				<tr>
					
					<td class="labelit"><cf_tl id="Item"></td>
					<td class="labelit"><cf_tl id="Description"></td>
					<td class="labelit"><cf_tl id="Code"></td>
					<td class="labelit"><cf_tl id="UoM"></td>
					<td align="right" class="labelit"><cf_tl id="Ordered"></td>
					<td align="right" class="labelit"><cf_tl id="Already"></td>
					<td colspan="3"></td>
					<!---
					<td class="labelit"><cf_tl id="Currency"></td>
					<td class="labelit" align="right"><cf_tl id="Price"></td>
					<td class="labelit" align="right"><cf_tl id="Total"></td>
					--->
				</tr>
				
				<!---
					<td align="right" class="labelit"><cf_tl id="Reference"></td>
					<td align="right" class="labelit"><cf_tl id="Received"></td>
					<td align="right" class="labelit"><cf_tl id="Location"></td>
					--->
					
				<tr><td colspan="9" class="line"></td></tr>
				
				<cfif Items.recordcount eq "0">
				
				<tr><td align="center" colspan="10" class="labelit" style="padding-top:10px">No records found to show in this view</td></tr>
				
				</cfif>
				
				<cfoutput query="Items">
				
					<cf_precision number="#itemPrecision#">	
				
					<tr class="navigation_row">
						
						<td class="labelit">#ItemNo#</td>
						<td class="labelit" style="padding:1px">#ItemDescription#</td>
						<td class="labelit" style="padding:1px">#Classification#</td>
						<td class="labelit" style="padding:1px">#uoMDescription#</td>
						<td class="labelit" align="right" style="padding:1px">#NumberFormat(Quantity,'#pformat#')#</td>
						<td class="labelit" align="right" style="padding-right:4px"><cfif Already eq 0>--<cfelse><font color="0080C0">#NumberFormat(Already,'#pformat#')#</cfif></td>
						<td colspan="3"></td>
					</tr>
					
					<tr class="navigation_row_child">
					
								
					   <td colspan="2"></td>	
					   <td colspan="7">
						   <table>
						   
						   <cfloop index="row" from="1" to="4">
						   <cfif row eq "1" or row eq "3">
						   <tr>
						   </cfif>
						   <td style="padding-left:10px;padding-right:10px" class="labelsmall"><cf_tl id="receipt">:</td>
							
							<!--- warehouse mode --->
													
							<cfif get.ModeSetItem eq "Category">
							
								<!--- check if the item belongs to this warehouse for the category of the item, if not
								then no option to record it --->
														
								<cfquery name="getCategory" 
								datasource="AppsMaterials"
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT  *
									FROM    WarehouseCategory
									WHERE   Warehouse = '#url.warehouse#'
									AND     Category = '#category#' 																				   
							   </cfquery>		
							   
							   <cfif getCategory.recordcount eq "1">
							   
							       <td class="labelit" align="right" style="padding:1px">
									  <input type="text" name="reference_#row#_#left(requirementid,8)#" class="regularxl enterastab" style="width:70px;text-align:right">						
								   </td>
							   
								   <td class="labelit" align="right" style="padding:1px">
									  <input type="text" name="quantity_#row#_#left(requirementid,8)#" class="regularxl enterastab" style="width:60px;text-align:right">						
								   </td>
								   
								   <td align="right">
								   
								     <cfquery name="LocationList" 
									  datasource="AppsMaterials"
									  username="#SESSION.login#" 
									  password="#SESSION.dbpw#">
										SELECT  *
										FROM    WarehouseLocation
										WHERE   Warehouse = '#url.warehouse#'
										AND     Operational = '1' 												   
									 </cfquery>									   	  
									 
									 <select name="location_#row#_#left(requirementid,8)#" class="regularxl enterastab">
									 <cfloop query="LocationList">
									 	<option value="#Location#">#Description# #storagecode#</option>
									 </cfloop>
									 </select>
								   
								   </td>
								   
							   <cfelse>
							   
								   	<td colspan="3" align="center" class="labelit">cat.n/a</td>	   
							   
							   </cfif>		
							
							<cfelseif get.ModeSetItem eq "Location">
							
								<!--- check if the item belongs to this warehouse for the category of the item, if not
								then no option to record it --->
							
								<cfquery name="LocationList" 
								datasource="AppsMaterials"
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT  *
									FROM    WarehouseLocation
									WHERE   Warehouse = '#url.warehouse#'
									AND     Operational = '1' 								
									AND     Location IN
									              (SELECT  Location
									               FROM    ItemWarehouseLocation
									               WHERE   Warehouse = '#url.warehouse#'
											       AND     ItemNo    = '#ItemNo#')								
													   
								 </cfquery>		
								 
								<cfif location.recordcount gte "1"> 	
								
								   <td class="labelit" align="right" style="padding:1px">
									  <input type="text" name="reference_#row#_#left(requirementid,8)#" class="regularxl enterastab" style="width:70px;text-align:right">						
								   </td>
								
								   <td class="labelit" align="right" style="padding:1px">
									  <input type="text" name="quantity_#row#_#left(requirementid,8)#" class="regularxl enterastab" style="width:60px;text-align:right">						
								   </td>
								   
								   <td align="right">	
								     <select name="location_#row#_#left(requirementid,8)#"  class="regularxl enterastab">
									 <cfloop query="LocationList">
									 	<option value="#Location#">#Description# #storagecode#</option>
									 </cfloop>
									 </select>
								   </td>							
								
								<cfelse>
								
									<td colspan="3" align="center" class="labelit">loc.n/a</td>	
								
								</cfif>					
							
							<cfelse>
							
								  <!--- always allow receipt --->
								  
								   <td class="labelit" align="right" style="padding:1px">
									  <input size="10" type="text" name="reference_#row#_#left(requirementid,8)#" class="regularxl enterastab" style="width:70px;text-align:right">						
								   </td>
							
								  <td class="labelit" align="right" style="padding:1px">
									  <input type="text" name="quantity_#row#_#left(requirementid,8)#" class="regularxl enterastab" style="width:60px;text-align:right">						
								  </td>
								   
								  <td align="right">
								   
								     <cfquery name="LocationList" 
									  datasource="AppsMaterials"
									  username="#SESSION.login#" 
									  password="#SESSION.dbpw#">
										SELECT  *
										FROM    WarehouseLocation
										WHERE   Warehouse = '#url.warehouse#'
										AND     Operational = '1' 												   
									 </cfquery>									   	  
									 
									 <select name="location_#row#_#left(requirementid,8)#" class="regularxl enterastab">
										 <cfloop query="LocationList">
									 		<option value="#Location#">#Description# #storagecode#</option>
										 </cfloop>
									 </select>
								   
								  </td>
													
							</cfif>		
							
						</cfloop>	
						
						<cfif row eq "2" or row eq "4"></tr></cfif>	
							
													
						</table>				
						</td>
												
					</tr>			
				
				</cfoutput>
			
			</table>
		
		</td>
	</tr>
	<tr><td class="linedotted"></td></tr>
	
</table>

<cfoutput>
	<script language="JavaScript">
		document.getElementById('workorderid').value = '#url.workorderid#'
		document.getElementById('submitbox').className = 'regular'
	</script>
</cfoutput>

<cfset AjaxOnLoad("doHighlight")>
