
<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT * 
	FROM   WorkOrder W, Customer C 
	WHERE  WorkorderId = '#url.workorderid#'
	AND    W.Customerid = C.CustomerId
</cfquery>  
		
<cfquery name="Lines" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	

	SELECT     T.TransactionId,
	           T.Mission, 
	           T.Warehouse, 
			   W.WarehouseName,
			   T.TransactionType, 
			   T.TransactionTimeZone, 
			   T.TransactionBatchNo,
			   T.TransactionDate, 
			   T.ItemNo, 
			   T.ActionStatus,
			   I.Classification,
			   T.ItemDescription, 
			   T.ItemCategory, 
			   T.TransactionQuantity*-1 as TransactionQuantity, 
	           T.TransactionUoM, 
			   T.TransactionCostPrice, 
			   TS.PriceSchedule, 
			   TS.SalesCurrency, 
			   TS.SalesPrice, 
			   TS.TaxCode, 
			   TS.TaxPercentage, 
			   TS.TaxExemption, 
			   TS.TaxIncluded, 
	           TS.SalesAmount, 
			   TS.SalesTax, 
			   TS.SalesTotal, 
			   TS.InvoiceId
	FROM       ItemTransaction T 
	           INNER JOIN ItemTransactionShipping TS ON T.TransactionId = TS.TransactionId
			   INNER JOIN Warehouse W ON T.Warehouse = W.Warehouse
			   INNER JOIN Item I ON I.ItemNo = T.ItemNo
	
	WHERE      T.Mission = '#workorder.mission#' 
	
	<!--- issuance transaction assigned to the workorder of a customer 
	
	AND        T.WorkOrderId = '#url.workorderid#'
	
	---> 

	AND        TS.Journal         = '#journal#'
	AND        TS.JournalSerialNo = '#journalserialno#'
																	 
	ORDER BY T.Warehouse, TransactionDate														 
	
</cfquery>	
	
<table width="100%" cellspacing="0" cellpadding="0" align="center">
	
	<tr>
		<td width="4"></td>
		<td class="labelit">Code</td>
		<td class="labelit">Description</td>
		<td class="labelit">Batch</td>
		<td class="labelit">Date</td>
		<td class="labelit" align="right">Quantity</td>
		<td class="labelit" align="center">Currency</td>
		<td class="labelit" align="right">Price</td>
		<td class="labelit" align="right">Extended</td>
		<td class="labelit" align="right">Tax</td>
		<td class="labelit" align="right">Payable</td>
	</tr>
	<tr><td colspan="11" class="linedotted"></td></tr>
							
	<cfoutput query="Lines" group="Warehouse">
	
		<tr><td style="height:30" colspan="11" class="labelmedium"><b>#WarehouseName#</td></tr>
	
		<cfoutput>
						
		<tr class="navigation_row linedotted">
			<td style="height:20" align="center">
			
			<!---
			<cfif actionstatus eq "0">
			<img src="#session.root#/images/pending.gif" style="height:15px;width:22px" alt="Pending confirmation" border="0">
			<cfelse>
			<input type="checkbox" onchange="_cf_loadingtexthtml='';ColdFusion.navigate('setTotal.cfm','totalbox','','','POST','billingform')" 
			  style  = "width:15px" 
			  class  = "radiol" 
			  name   = "selected" 
			  id     = "selected"
			  value  = "'#TransactionId#'">
			</cfif>
			--->
			
			</td>
			<td class="labelit">#Classification#</td>
			<td class="labelit">#ItemDescription#</td>
			<td class="labelit"><a href="javascript:batch('#transactionbatchno#','#workorder.mission#','process','#url.systemfunctionid#')">
			     <font color="0080C0">#TransactionBatchNo#</font></a></td>
			<td class="labelit">#dateformat(TransactionDate,client.dateformatshow)#</td>
			<td class="labelit" align="right">#TransactionQuantity#</td>
			<td class="labelit" align="center">#SalesCurrency#</td>
			<td class="labelit" align="right">#numberformat(SalesPrice,"_,__.__")#</td>
			<td class="labelit" align="right">#numberformat(SalesAmount,"_,__.__")#</td>
			<td class="labelit" align="right">#numberformat(SalesTax,"_,__.__")#</td>
			<td class="labelit" align="right" style="padding-right:7px">#numberformat(SalesTotal,"_,__.__")#</td>
		</tr>	
					
		</cfoutput>
	
	</cfoutput>	
		
</table>
	
<cfset AjaxOnLoad("doHighlight")>