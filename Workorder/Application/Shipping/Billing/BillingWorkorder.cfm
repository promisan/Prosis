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
<cfquery name="getselect" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
SELECT  *
FROM (

	
	SELECT     W.WorkOrderId,	          
			   W.Reference, 
			   W.ActionStatus, 			 
			   W.OrderDate,
	          
			   <!--- pending billing for the lines --->				
			   
			   (SELECT    SUM(TS.SalesBaseTotal) AS TotalShippedPending
				FROM      Materials.dbo.ItemTransaction T INNER JOIN
	                      Materials.dbo.ItemTransactionShipping TS ON T.TransactionId = TS.TransactionId
			    WHERE     T.WorkOrderId = W.WorkOrderId 
				<!--- not billed yet --->
				AND       (TS.InvoiceId IS NULL 
				           OR 
						   TS.InvoiceId NOT IN
					                          (SELECT  TransactionId
	                				           FROM    Accounting.dbo.TransactionHeader
					                           WHERE   TransactionId = TS.InvoiceId AND RecordStatus = '1')) 
				
				<!--- final product --->							   
			    AND  T.RequirementId IS NOT NULL 
				
				<!--- issuance and not returned --->
				
				AND  T.TransactionType IN ('2','3') 
				AND  T.TransactionId NOT IN
		                          ( SELECT    ParentTransactionId
		                            FROM      Materials.dbo.ItemTransaction
	    	                        WHERE     ParentTransactionId = T.TransactionId AND TransactionType = '3')
				) as PendingBilling,	
						
			    W.Created
				
	FROM        WorkOrder W 
	WHERE       W.Mission = '#URL.Mission#'
	AND         W.ActionStatus IN ('0','1','3')
	AND         W.CustomerId = '#workorder.customerid#'
	<!--- tp prevent mixing in journals --->
	AND         W.Currency   = '#workorder.currency#'
	
	<!--- Condition added by dev on 3/31/2014 
	<cfif url.transactionlot neq "">
		AND        W.WorkorderId IN 
		                        (SELECT WorkOrderId 
								 FROM   Materials.dbo.Itemtransaction 
								 WHERE  WorkOrderId = W.WorkOrderId 
						         AND    Mission     = '#url.mission#' 
								 AND    TransactionLot LIKE ('%#url.transactionlot#%'))
		
	</cfif>
	
	--->
		
) as Derrived

WHERE  abs(PendingBilling) >= 0.5

<!--- condition to show only workorders that have confirmed shipment pending to be invoiced,
Hanno 23/3/2014 : technically we should also filter to take only WorkOrderLine that are meant for sale !!
--->

</cfquery>

	<table width="96%" align="center" class="navigation_table">
	
		<tr><td colspan="3" style="padding-left:4px;padding-top:4px;padding-bottom:4px" class="labelmedium"><cf_tl id="Select workOrder"></td></tr>
		
		<cfoutput query="getSelect">
		
			<cfif url.workorderid eq workorderid>
				<cfset cl = "6688aa">
			<cfelse>
				<cfset cl = "black">
			</cfif>		
			
			<tr class="labelit line navigation_row">
			    <td style="height:20px;padding-left:3px">
				  <cfif url.workorderid eq workorderid><input type="hidden" name="workselected" value="'#workorderid#'"><cfelse><input type="checkbox" onclick="applyWorkorder()" name="workselected" value="'#workorderid#'"></cfif>
			    </td>
				<td style="padding-left:3px"><font color="#cl#">#Reference#</font></td>
				<td style="padding-left:3px"><font color="#cl#">#dateformat(OrderDate,client.dateformatshow)#</font></td>
			</tr>
		
		</cfoutput>
	
	</table>

<cfset ajaxonload("doHighlight")>
