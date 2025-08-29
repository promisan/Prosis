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
<cfparam name="Form.Selected" default="">


<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     WorkOrder
	WHERE    WorkOrderId   = '#url.workorderid#'	
</cfquery>	

<cfquery name="getTotal" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT SUM(SalePayable      * ((Quantity-QuantityBilled)/Quantity)) as SalePayable,
			   SUM(SaleAmountIncome * ((Quantity-QuantityBilled)/Quantity)) as SaleIncome,
			   SUM(SaleAmountTax    * ((Quantity-QuantityBilled)/Quantity)) as SaleTax
			   
		FROM  (		
		
				SELECT   L.WorkOrderItemId, 
				         L.Quantity,
			             (SELECT     ISNULL(SUM(B.Quantity), 0)
			              FROM       WorkOrderLineItemBilling B
			              WHERE      B.WorkOrderItemId = L.WorkOrderItemId
						  AND        EXISTS  (SELECT 'X' 
						                      FROM  Accounting.dbo.TransactionHeader
						                      WHERE Journal         = B.Journal
											  AND   JournalSerialNo = B.JournalSerialNo
											  AND   RecordStatus != '9' AND ActionStatus !='9')) AS QuantityBilled, 
						 L.SalePayable,
						 L.SaleAmountIncome,
						 L.SaleAmountTax
				FROM     WorkOrderLineItem L INNER JOIN
			             Materials.dbo.Item I    ON L.ItemNo = I.ItemNo INNER JOIN
			             Materials.dbo.ItemUoM U ON L.ItemNo = U.ItemNo AND L.UoM = U.UoM
				WHERE    WorkOrderId   = '#url.workorderid#'
				AND      WorkorderLine = '#url.workorderline#'
				
				<cfif form.selected neq "">
				AND      WorkOrderItemId IN (#preservesinglequotes(Form.Selected)#) 	
				<cfelse>
				AND 1=0
				</cfif>		
		
			  ) as Tab
			  
</cfquery>	

<cfif form.selected neq "">

<cfset sale    = getTotal.SaleIncome>
<cfset tax     = getTotal.SaleTax>
<cfset taxrate = round(tax*1000 / sale)/1000>  <!--- line 0.12 --->
<cfset total   = sale + tax>	

<cfquery name="Entry" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			   SELECT   *
			   FROM     Ref_ParameterMissionGLedger G INNER JOIN
		                Ref_AreaGLedger R ON G.Area = R.Area
			   WHERE    R.BillingEntry = 1
			   AND      G.Mission = '#workorder.mission#'
			   ORDER BY R.ListingOrder
	</cfquery>
	
	<cfset row = "0">
	<cfset ar=ArrayNew(2)>	
	
	<cfloop query="Entry">
	
		 <!--- overruling account --->
		 
		 <cfquery name="getArea" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT   *
			   FROM     WorkOrderGLedger
			   WHERE    WorkOrderId = '#url.workorderid#'
			   AND      Area        = '#Area#'			 
		 </cfquery>
		 	
		 <cfset val   = evaluate("Form.Amount_#Area#")>
		 <cfset val   = replace(val,",","","ALL")>
		 
		 <cfif val neq "" and LSIsNumeric(val) and val neq "">
		 								  
				<cfset row = row+1>
											  
			  	<cfset sale = sale + val>		
				
				<cfif applyTax eq "1">
				
				    <cfset tax = tax + (val * taxrate)>
				</cfif>
				
				<cfset total = sale + tax>				
		 
		 </cfif>
	 	
	</cfloop>

<cfoutput>	

  <script>  
  
	  document.getElementById('saleamount').value      = '#numberformat(getTotal.SaleIncome,",__.__")#'	
	  document.getElementById('totalamount').value     = '#numberformat(sale,",__.__")#'	
	  document.getElementById('taxamount').value       = '#numberformat(tax,",__.__")#'
	  document.getElementById('payableamount').value   = '#numberformat(total,",__.__")#'
  </script>
	
</cfoutput>

</cfif>