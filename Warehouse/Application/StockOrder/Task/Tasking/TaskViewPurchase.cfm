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
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM   Request R, Item I
	  WHERE  RequestId = '#URL.RequestId#'
	  AND    R.ItemNo = I.ItemNo
</cfquery>

<cfquery name="whs" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM   Warehouse
	  WHERE  Warehouse = '#get.Warehouse#'  
</cfquery>

<cfif whs.taskingMode eq "1">

<!--- pending to filter on the valid period --->

<cfquery name="Purchase" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  
	SELECT    O.OrgUnitName as Vendor,
			  PL.PurchaseNo, 
	          PL.RequisitionNo,
			  RL.Reference,
			  PL.Currency,
	          RL.Period, <!--- likely better to take the funding period ?? --->
	          PL.OrderItem, 
			  PL.OrderItemNo, 
			  PL.OrderAmount AS PurchaseAmount,  <!--- us dollars --->
			  RL.RequestDescription
	FROM      PurchaseLine PL INNER JOIN
	          RequisitionLine RL ON PL.RequisitionNo = RL.RequisitionNo INNER JOIN
			  Purchase P ON P.PurchaseNo = PL.PurchaseNo INNER JOIN 
			  Organization.dbo.Organization O ON O.OrgUnit = P.OrgUnitVendor
	WHERE     RL.Mission    = '#get.mission#' 
	
	AND       P.OrderType IN (SELECT FundingOrderType FROM Materials.dbo.Ref_ParameterMission WHERE Mission = '#get.mission#')
	
	<!--- purchase order was raised in the same master --->
	AND       RL.ItemMaster = '#get.itemmaster#' 
	
	AND       PL.PurchaseNo IN (SELECT PurchaseNo
		                         FROM   Purchase 
								 WHERE  ActionStatus >= '3' 
								 AND    ActionStatus < '9' 
								 AND    PurchaseNo = PL.PurchaseNo)
								 
								 ORDER BY O.OrgUnitName
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
	<tr>  
	  <td width="40"></td>
	  <td class="labelit">PO Number</td>
	  <td class="labelit">Line</td>
	  <td class="labelit">Curr</td>
	  <td class="labelit" align="right" width="12%">Obligated</td>
	  <td class="labelit" align="right" bgcolor="f4f4f4" width="12%"><i>Billed</i></td>
	  <td class="labelit" align="right" width="12%">Received</td>
	  <td class="labelit" align="right" width="12%">Tasked</td>
	  <td class="labelit" align="right" width="12%">This Request</td>
	  <td class="labelit" align="right" width="12%">Balance</td>
	</tr>
	
	<tr><td class="linedotted" colspan="10"></td></tr>
	
	<cfif Purchase.recordcount eq "0">
	
	<tr><td colspan="10" class="label" style="height:20px" align="center">No valid purchase orders available</td></tr>
	<tr><td class="linedotted" colspan="10"></td></tr>
	
	</cfif>
	
	<cfoutput query="Purchase" group="Vendor">
	
	    <tr><td colspan="10" style="padding:2px" class="labelit">#Vendor#</font></td></tr>
		<tr><td colspan="10" class="linedotted"></td></tr>		
	
		<cfoutput>
		
		<cfset currto = currency>
				
		<cfquery name="Invoiced" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">		  
		  SELECT    SUM(AmountMatched) AS Invoiced  <!--- expressed in the currency of the purchaseline --->
		  FROM      InvoicePurchase IP
		  WHERE     RequisitionNo = '#requisitionno#'
		  AND       Invoiceid IN (SELECT Invoiceid 
		                          FROM   Invoice 
								  WHERE  ActionStatus != '9' 
		                          AND    InvoiceId     = IP.InvoiceId)	  					
		</cfquery>	
			
		<cfif Invoiced.Invoiced eq "">
		   <cfset inv = "0">
		<cfelse>
		   <cfset inv = Invoiced.Invoiced>   
		</cfif>
				
		<cfquery name="ReceiptSame" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT    SUM(ReceiptAmount) as Received
			FROM      PurchaseLineReceipt
			WHERE     (RequisitionNo = '#requisitionno#') AND (ActionStatus <> '9')			
			AND       Currency = '#currency#'
		</cfquery>		
		
		<cfif ReceiptSame.received eq "">
		   <cfset rcp = "0">
		<cfelse>
		   <cfset rcp = ReceiptSame.received>   
		</cfif>
		
		<!--- other currencies to be corrected --->
		
		<cfquery name="ReceiptOther" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT    *
			FROM      PurchaseLineReceipt
			WHERE     (RequisitionNo = '#requisitionno#') AND (ActionStatus <> '9')						
			AND       Currency != '#currency#'
		</cfquery>		
		
		<cfloop query="ReceiptOther">
		
			<cf_ExchangeRate Datasource="AppsPurchase" CurrencyFrom="#APPLICATION.BaseCurrency#" CurrencyTo="#Currto#">
			<cfset rcp = rcp + (receiptamountBase * exc)> 
		
		</cfloop>
		
		<!--- tasked in same currency --->
					
		<cfquery name="Task" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT    SUM(TaskAmount) as Tasked
			FROM      RequestTask T
			WHERE     (
			            RequestId != '#url.requestid#' 
					    OR 
					   (RequestId  = '#url.requestid#' AND TaskSerialNo != '#url.serialno#')
					  )
			AND       RecordStatus = '1'
			AND       SourceRequisitionNo = '#requisitionno#'
			AND       TaskType     = 'Purchase'
			
			<!--- has no receipts recorded yet --->
			AND       TaskId NOT IN (SELECT WarehouseTaskId 
			                         FROM   Purchase.dbo.PurchaseLineReceipt 
									 WHERE  WarehouseTaskId = T.TaskId
									 AND    RecordStatus != '9') 
			AND       TaskCurrency = '#currTo#'						 
			
		</cfquery>
				
		<cfif task.tasked eq "">
		   <cfset tsk = "0">
		<cfelse>
		   <cfset tsk = task.tasked>   
		</cfif>	
		
		<!--- tasked in other currency --->
		
		<cfquery name="TaskOtherCurr" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT    *
			FROM      RequestTask T
			WHERE     (
			            RequestId != '#url.requestid#' 
					    OR 
					   (RequestId  = '#url.requestid#' AND TaskSerialNo != '#url.serialno#')
					  )
			AND       RecordStatus = '1'
			AND       SourceRequisitionNo = '#requisitionno#'
			AND       TaskType     = 'Purchase'
			
			<!--- has no receipts recorded yet --->
			AND       TaskId NOT IN (SELECT WarehouseTaskId 
			                         FROM   Purchase.dbo.PurchaseLineReceipt 
									 WHERE  WarehouseTaskId = T.TaskId
									 AND    RecordStatus != '9') 
			AND       TaskCurrency != '#currTo#'
		</cfquery>		
		
		<cfloop query="TaskOtherCurr">
		
			<cf_ExchangeRate Datasource="AppsPurchase" CurrencyFrom="#APPLICATION.BaseCurrency#" CurrencyTo="#CurrTo#">
			<cfset tsk = tsk + (TaskAmountBase * exc)> 
		
		</cfloop>					
		
		<cfquery name="Current" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		      SELECT * 
			  FROM   RequestTask			  
			  WHERE  RequestId    = '#URL.RequestId#'
			  AND    TaskSerialNo = '#URL.SerialNo#'
		</cfquery>
		
		<cfif Current.TaskAmountBase eq "">
		   <cfset new = "0">
		<cfelse>
		
		   <cfif current.TaskCurrency eq CurrTo>
		   	  <cfset new = Current.TaskAmount>   
		   <cfelse>
		      <cf_ExchangeRate Datasource="AppsPurchase" CurrencyFrom="#APPLICATION.BaseCurrency#" CurrencyTo="#CurrTo#">
			  <cfset tsk = tsk + (Current.TaskAmountBase * exc)> 
		   </cfif>
		    
		</cfif>		
			
		<cfset bal = PurchaseAmount-rcp-tsk-new>
		
		<cfif requisitionno eq current.sourcerequisitionno>
			<tr bgcolor="FFFF00" class="labelit">
		<cfelse>				
			<tr class="labelit">		
		</cfif>
		
			<td width="40" style="padding-left:5px">

			<cfif bal lte 0>			
				<!--- disabled --->				
			<cfelse>
			
				<input type="radio" 
				    id="selectline" style="height:14px;width:14px"
				    onclick="taskedit('#url.requestId#','#url.serialno#','requisition',this.value,'')"
				    name="selectline" value="#RequisitionNo#" <cfif requisitionno eq current.sourcerequisitionno>checked</cfif>>
					
			</cfif>	
			</td>	   
		    <td>
			<a href="javascript:ProcPOEdit('#purchaseno#')"><font color="0080C0">
			<cf_getPurchaseNo purchaseNo="#PurchaseNo#" mode="only">
			</a></td>
		    <td>#Reference#</td>		
			<td>#Currency#</td>
			<td align="right">#numberformat(PurchaseAmount,'__,__.__')#</td>
			<td align="right" bgcolor="f4f4f4"><font bgcolor="c0c0c0"><i>#numberformat(inv,'__,__.__')#</td>
			<td align="right">#numberformat(rcp,'__,__.__')#</font></td>
			<td align="right"><font color="408080" style="font-style: italic;">#numberformat(tsk,'__,__.__')#</font></td>
			<td align="right">#numberformat(new,'__,__.__')#</font></td>
			<td align="right"><cfif bal lt 0><b><font color="FF0000"></cfif>#numberformat(bal,'__,__.__')#
			</td>
			
		</tr>
		</cfoutput>
				
	</cfoutput>
	
	</td></tr>
	
</table>

</cfif>

<cfoutput>
<script>
	Prosis.busy('no')
	parent.taskrefresh('#url.requestid#')
</script>
</cfoutput>



