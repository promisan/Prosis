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
<cfparam name="url.workorderid" default="">
<cfparam name="form.workselected" default="'#url.workorderid#'">

<cfif form.workselected eq "''">

	<table width="95%" align="center"><tr><td align="center" class="labelmedium"><cf_tl id="No workorders selected"></td></tr></table>

<cfelse>

	<!--- show the workorders and their recorded billing amounts in item transaction --->	
		
	<cfquery name="workorder" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	  	SELECT W.WorkOrderId,
		       W.Mission,
		       WL.WorkOrderLine,
			   WL.WorkOrderLineId,
			   WL.ServiceDomainClass,
			   WL.DateEffective,
			   W.Reference,
			   WL.Reference as DomainReference,
			   W.Currency,
			   W.OrderDate,
			   
			    (
			   	   SELECT   count(*)
			       FROM     WorkOrderLineItem I 
				   WHERE    I.WorkOrderId   = WL.WorkOrderId 
				   AND      I.WorkOrderLine = WL.WorkOrderLine 
				   ) as Items,
			   (
			   	   SELECT   ISNULL(SUM(I.SalePayable),0) AS Total
			       FROM     WorkOrderLineItem I 
				   WHERE    I.WorkOrderId   = WL.WorkOrderId 
				   AND      I.WorkOrderLine = WL.WorkOrderLine 
				   ) as Amount,
				   
				<!--- before tax --->   
				(
				  SELECT   ISNULL(ROUND(SUM(TS.SalesTotal), 2), 0) AS Expr1
                  FROM     Materials.dbo.ItemTransactionShipping AS TS INNER JOIN
                           Materials.dbo.ItemTransaction AS T ON TS.TransactionId = T.TransactionId
                  WHERE    T.WorkOrderId   = WL.WorkOrderId 
				  AND      T.WorkOrderLine = WL.WorkOrderLine
				  AND      TS.InvoiceId IN (
				                           SELECT   TransactionId
                                           FROM     Accounting.dbo.TransactionHeader
                                           WHERE    TransactionId = TS.InvoiceId 
										   AND      RecordStatus != '9' 
										   AND      ActionStatus != '9'
										   AND      Reference != 'PreBilling'
										   ) 
				  AND      T.TransactionType = '2'
				  
				  ) as Billed,
				  
				  (
				  SELECT   ISNULL(ROUND(SUM(TS.SalesTax), 2), 0) AS Expr1
                  FROM     Materials.dbo.ItemTransactionShipping AS TS INNER JOIN
                           Materials.dbo.ItemTransaction AS T ON TS.TransactionId = T.TransactionId
                  WHERE    T.WorkOrderId = WL.WorkOrderId 
				  AND      T.WorkOrderLine = WL.WorkOrderLine
				  AND      TS.InvoiceId IN (
				                           SELECT   TransactionId
                                           FROM     Accounting.dbo.TransactionHeader
                                           WHERE    TransactionId = TS.InvoiceId 
										   AND      RecordStatus != '9' 
										   AND      ActionStatus != '9'
										   AND      Reference != 'PreBilling'
										   
										   ) 
				  AND      T.TransactionType = '2'
				  
				  ) as TaxBilled
 
									    
		FROM   WorkOrder W, 
		       Customer C, 
			   WorkOrderLine WL,
			   Ref_ServiceItemDomainClass R 
			   
		WHERE  W.WorkorderId IN (#preservesingleQuotes(form.workselected)#)
		AND    WL.ServiceDomain      = R.ServiceDomain 
		AND    WL.ServiceDomainClass = R.Code
		AND    R.PointerSale          = 1
		AND    W.Customerid           = C.CustomerId
		AND    W.WorkOrderId          = WL.WorkOrderId
				 
	</cfquery>
	
	<table width="100%" align="center" >	
		
		<tr class="labelmedium line">
			    <td width="20%" style="border:1px solid silver;padding-left:5px"><cf_tl id="Workorder"></td>		
				<td width="15"  style="border:1px solid silver;padding-left:5px"><cf_tl id="L"></td>	   
				<td width="100" style="border:1px solid silver;padding-left:5px"><cf_tl id="Date"></td>		
				<td width="20" style="border:1px solid silver;padding-left:5px"><cf_tl id="Items"></td>		
				<td width="70" style="border:1px solid silver;padding-left:5px"><cf_tl id="Cur"></td>	
			    <td align="right" width="20%" style="border:1px solid silver;padding-right:5px"><cf_tl id="Sale"></td>		  
				<td align="right" width="20%" style="border:1px solid silver;padding-right:5px"><cf_tl id="(tax) Billed"></td>						
		</tr>
	
		<cfset row = 0>
	
		<cfoutput query="workorder" group="workorderid">	
											
			<!--- allow adding a workorder with the 
			   same billing currency, that has pendings, after selection we refresh the header showing order amount and billed --->
			
			<cfoutput>
			
			 	<cfset row = row+1>
				<tr class="labelmedium">		  
				    <td style="border:1px solid silver;padding-left:5px;padding-left:4px"><a href="javascript:workorderlineopen('#workorderlineid#','','dialog')">
					<font color="0080C0">#ServiceDomainClass# #DomainReference#</font>
					</td>			
					<td style="font-size:12px;border:1px solid silver;padding-left:5px">#WorkOrderLine#</td>		
					<td style="border:1px solid silver;padding-left:5px">#dateformat(DateEffective,client.dateformatshow)#</td>	
					<td style="border:1px solid silver;padding-left:5px">#Items#</td>		
					<td style="border:1px solid silver;padding-left:5px">#Currency#</td>		  
				    <td align="right" style="border:1px solid silver;padding-right:5px">#numberformat(Amount,",.__")#</td>			
					<td align="right" style="border:1px solid silver;padding-right:5px">	
					<font size="2" color="808080">(#numberformat(TaxBilled,",.__")#)</font> #numberformat(Billed,",.__")#			
					</td>
				</tr>
				
			</cfoutput>
				
			<tr class="labelmedium">		  
			    
				<cfif row eq recordcount>		
				
					<td colspan="3" style="border:0px solid silver;padding-right:5px">
				
					<cfinvoke component = "Service.Presentation.TableFilter"  
					   method           = "tablefilterfield" 
					   filtermode       = "enter"
					   name             = "filtersearch"
					   style            = "font:13px;height:23;width:120"
					   rowclass         = "clsWarehouseRow"
					   rowfields        = "ccontent">
					   
				<cfelse>			
	
					<td colspan="3"></td>
					
				</cfif>				   
							
				<td></td>
				<td></td>
						
				<td colspan="1" bgcolor="fafafa" style="padding-top:3px;border:1px solid silver;padding-left:5px">
				<a href="javascript:workorderview('#workorderid#')"><font color="0080C0"><cf_tl id="Ledger Posting">#Reference#:</a></td>	  	
				
				<td style="border:1px solid silver;padding-right:5px" align="right" id="billingbox_#url.workorderid#">			
			
				<cfset url.workorderid = workorderid>						 
				<cfinclude template="setBilled.cfm">		
							
				</td>
			</tr>
			
			<tr><td height="2"></td></tr>
				
		</cfoutput>
			
	</table>


</cfif>
