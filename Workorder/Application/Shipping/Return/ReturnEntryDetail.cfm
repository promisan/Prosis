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

<cfparam name="url.shipmode" default="Pending">

<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT * 
	FROM WorkOrder W, Customer C 
	WHERE WorkorderId = '#url.workorderid#'
	AND  W.Customerid = C.CustomerId
</cfquery>  
		
<cfquery name="Lines" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	
	SELECT *
	FROM (

		SELECT     T.TransactionId,
				   T.TransactionSerialNo,	
		           T.Mission, 
		           T.Warehouse, 
				   W.WarehouseName,
				   T.TransactionType, 
				   T.TransactionTimeZone, 
				   T.TransactionBatchNo,
				   T.TransactionDate, 
				   T.ItemNo, 
				   U.ItemBarCode,
				   U.UoMDescription,
				   T.ActionStatus,
				   T.TransactionLot,
				   I.Classification,
				   T.ItemDescription, 
				   T.ItemCategory, 			   
				   
				   T.TransactionQuantity*-1 as TransactionQuantity, 
				   
				   (  SELECT ISNULL(SUM(TransactionQuantity),0) as Returned
		              FROM   ItemTransaction
					  WHERE  ParentTransactionId = T.TransactionId 
					  AND    TransactionType = '3'
				   ) as ReturnedQuantity, 
				   
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
				   INNER JOIN Item I      ON I.ItemNo = T.ItemNo
				   INNER JOIN ItemUoM U   ON U.ItemNo = T.ItemNo AND U.UoM = T.TransactionUoM
		
		WHERE      T.Mission = '#workorder.mission#' 
		
		<!--- issuance transaction assigned to the workorder of a customer --->	
		AND        T.WorkOrderId = '#url.workorderid#' 
	
		<!--- finished product of a workorder --->
		AND        T.RequirementId is not NULL
		
		<!--- Issuance transaction --->
		AND        T.TransactionType = '2' 
			
		<cfif url.shipmode eq "Pending">
		
		<!--- line is not yet billed or AR billing was NOT voided --->
		AND        (
		              TS.InvoiceId IS NULL OR NOT EXISTS (SELECT 'X'
					                                      FROM    Accounting.dbo.TransactionHeader
		                        					      WHERE   TransactionId = TS.InvoiceId
													      AND     RecordStatus != '9')
			 	 )
				 
		<cfelse>
		
		AND        (
		             EXISTS (SELECT  'X'
							 FROM    Accounting.dbo.TransactionHeader
		                     WHERE   TransactionId = TS.InvoiceId
							 AND     RecordStatus != '9')
			 	 )
		
				 
		</cfif>																	 
			
	
	) as Sub
	
	WHERE TransactionQuantity - ReturnedQuantity > 0.05
	
	ORDER BY Warehouse, TransactionLot, TransactionDate		
	
	<!--- show only issuance lines that have not been fully returned yet --->
		
</cfquery>	


<table width="100%">
	
	<tr class="labelmedium2 fixrow line">
		<td width="30" align="center">
			<input type="Checkbox" 
				id="selectAll" 
				name="selectAll" 
				onclick="selectAllCB(this,'.clsCheckbox')">
		</td>
		<td><cf_tl id="Code"></td>
		<td><cf_tl id="Description"></td>
		<td><cf_tl id="Barcode"></td>
		<td><cf_tl id="Lot"></td>
		<td><cf_tl id="Batch"></td>
		<td><cf_tl id="Date"></td>		
		<td align="right"><cf_tl id="Shipped"></td>				
		<td align="right"><cf_tl id="Returned"></td>	
		<td align="right"><cf_tl id="Quantity"></td>					
		<td align="right"><cf_tl id="Price"></td>
		<!---
		<td align="right"><cf_tl id="Extended"></td>
		<td align="right"><cf_tl id="Tax"></td>
		<td align="right"><cf_tl id="Payable"></td>
		--->
		<td style="width:70px" align="right"><cf_tl id="Return"></td>	
	</tr>
	
	<cfif lines.recordcount eq "0">
	
		<tr><td colspan="12" class="line"></td></tr>
		<tr><td colspan="12" style="height:40px" align="center" class="labelmedium"><font color="6688aa"><cf_tl id="All shipments were billed"></td></tr>
		<tr><td colspan="12" class="line"></td></tr>
		
	<cfelse>
					
		<cfoutput query="Lines" group="Warehouse">
		
			<tr><td style="height:40" colspan="11" class="labelmedium2"><cf_tl id="from"><b>#WarehouseName#</td></tr>
		
			<cfoutput>
							
			<tr class="labelmedium2 navigation_row line clsWarehouseRow">
				<td style="display:none;" class="ccontent">#ItemBarCode# #ItemDescription# #TransactionBatchNo# #TransactionLot#</td>
				<td width="40" style="height:20" align="center">
				
				<!---
				<cfif actionstatus eq "0">
				<img src="#session.root#/images/pending.gif" style="height:15px;width:22px" alt="Pending confirmation" border="0">
				<cfelse>
				--->
				
				<input type  = "checkbox" 
					onchange = "_cf_loadingtexthtml='';ptoken.navigate('setTotal.cfm','totalbox','','','POST','billingform')" 
				  	style    = "width:15px;height:13px" 
				  	class    = "radiol clsCheckbox" 
				  	name     = "selected" 
				  	id       = "selected"
				  	value    = "'#TransactionId#'">
				
				<!---  
				</cfif>
				--->
				
				</td>
				<td style="padding-right:2px">#Classification#</td>
				<td style="padding-right:2px">#ItemDescription#</td>
				<td style="padding-right:2px">#ItemBarCode#</td>
				<td style="padding-right:2px">#TransactionLot#</td>
				<td style="padding-right:2px"><a href="javascript:batch('#transactionbatchno#','#workorder.mission#','process','#url.systemfunctionid#')">
				     <font color="0080C0">#TransactionBatchNo#</font></a></td>
				<td>#dateformat(TransactionDate,client.dateformatshow)#</td>				
				<td style="padding-right:2px" align="right">#TransactionQuantity#</td>						
				<td style="padding-right:2px" align="right">#ReturnedQuantity#</td>										
				<td style="padding-right:2px" align="right">
				<cfif ReturnedQuantity neq ""><cfset q = TransactionQuantity-ReturnedQuantity>#q#				
				<cfelse>#TransactionQuantity#</cfif>
				</td>																
				<td style="padding-right:2px" align="right">#numberformat(SalesPrice,",.__")#</td>
				
				<!---				
				<td style="padding-right:2px" align="right">#numberformat(SalesAmount,"_,__.__")#</td>
				<td style="padding-right:2px" align="right">#numberformat(SalesTax,"_,__.__")#</td>
				<td style="padding-right:2px" align="right">#numberformat(SalesTotal,"_,__.__")#</td>
				--->
				
				<td style="padding-right:2px" align="right">
					<table>
						<tr>
						<td id="box_#TransactionSerialNo#" name="returnbox" class="hide">
						<input onchange="_cf_loadingtexthtml='';ptoken.navigate('setTotal.cfm','totalbox','','','POST','billingform')" 
						 type="text" id="Quantity_#TransactionSerialNo#" name="Quantity_#TransactionSerialNo#" class="regularxxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver;height:23px;text-align:right;width:70px" value="#TransactionQuantity#">				
						</td>
						</tr>
					</table>
				</td>
				
			</tr>	
						
			</cfoutput>
		
		</cfoutput>	
		
	</cfif>	
	
</table>
	
<cfset AjaxOnLoad("doHighlight")>