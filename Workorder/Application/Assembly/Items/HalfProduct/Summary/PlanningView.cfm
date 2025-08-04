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
<cfoutput>

<table width="95%" cellspacing="4" cellpadding="4">

	<tr><td height="10"></td></tr>
	<tr><td colspan="2" style="font-size:35px" class="labellarge"> <cf_tl id="Planned Production"></td></tr>
	
	<tr>	  
	   <td colspan="2" class="line"></td>
	</tr>

	<tr><td height="6"></td></tr>
	
	<tr><td class="labellarge"><b> <cf_tl id="Product"></td>
	    <td class="labelmedium" align="right"></td>
	</tr>
				
	<cfquery name="sale" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  ISNULL(SUM(SaleAmountIncome),0) as SaleIncome	
	     FROM    WorkOrderLineItem WOL 
		 WHERE   WorkOrderId  = '#url.workorderid#'	
		 AND     WorkOrderLine = '#url.workorderline#'
	</cfquery>
	
	<cf_exchangeRate 
        CurrencyFrom = "#workorder.currency#" 
        CurrencyTo   = "#application.BaseCurrency#">
																						
	<cfset tot = sale.SaleIncome*exc>	
	
	<tr><td style="padding-left:10px" width="90%" class="labelmedium"> <cf_tl id="Gross Product Value"></td>
	    <td class="labelmedium" align="right">#numberformat(tot,",__.__")#</td>
	</tr>
	
	<cfquery name="BOM" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  ISNULL(SUM(R.Amount),0) as Amount	
		  FROM    WorkOrderLineItemResource R 
		 		 INNER JOIN WorkOrderLineItem I  ON I.WorkOrderItemId = R.WorkOrderItemId		    
		 WHERE   WorkOrderId   = '#url.workorderid#'	
		 AND     WorkOrderLine = '#url.workorderline#'
		 <!--- AND     ResourceMode  = 'Receipt' --->
	</cfquery>
	
	<cfset bom = BOM.amount>
	
	<cfif abs(tot-bom) gte 1>
	<tr>
	    <td style="padding-left:10px" class="labelmedium"> <cf_tl id="BOM Value"></td>
		<td class="labelmedium" align="right"><font color="gray">#numberformat(bom,",__.__")#</td></tr>
	
	<tr>
	   <td></td>
	   <td class="line"></td>
	</tr>
	
	</cfif>
	
	<cfquery name="productsub" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   R.CategoryItemName, R.CategoryItemOrder, SUM(WOL.SaleAmountIncome) AS SaleIncome
		FROM     Materials.dbo.Ref_CategoryItem R INNER JOIN
                 Materials.dbo.Item I ON R.CategoryItem = I.CategoryItem AND R.Category = I.Category INNER JOIN
                 WorkOrderLineItem WOL ON I.ItemNo = WOL.ItemNo
		WHERE    WorkOrderId  = '#url.workorderid#'	
		AND      WorkOrderLine = '#url.workorderline#'		 
		GROUP BY R.CategoryItemName, R.CategoryItemOrder
		ORDER BY R.CategoryItemOrder
	</cfquery>
	
	<cfloop query="productsub">
	
	<tr>
		<td class="labelit" style="padding-left:20px">#CategoryItemName#</td>
		<td class="labelit" align="right" style="padding-right:10px">#numberformat(saleincome,",__.__")#</td>
	</tr>
	
	</cfloop>
	
	<tr>
	   <td></td>
	   <td class="line"></td>
	</tr>
	
	<cfset net = tot-bom>
		
	<cfif abs(tot-bom) gte 1>
		
	<tr><td style="padding-left:10px" class="labelmedium"> <cf_tl id="Price gain/loss"></td>
	    <td class="labelmedium" align="right">#numberformat(net,",__.__")#</td>
	</tr>
	
	</cfif>
	
	<tr><td height="15"></td></tr>
	
	<tr><td class="labellarge"><b> <cf_tl id="Cost of Goods Produced"></td>
	    <td class="labelmedium" align="right"></td>
	</tr>
		
	<cfquery name="supply" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  C.Description, ISNULL(SUM(R.Amount),0) as Amount	
	     FROM    WorkOrderLineItemResource R 
		 		 INNER JOIN WorkOrderLineItem I  ON I.WorkOrderItemId = R.WorkOrderItemId	
				 INNER JOIN Materials.dbo.Item M ON M.ItemNo = R.ResourceItemNo	 
				 INNER JOIN Materials.dbo.Ref_Category C ON M.Category = C.Category
		 WHERE   I.WorkOrderId   = '#url.workorderid#'	
		 AND     I.WorkOrderLine = '#url.workorderline#'
		 		 
		  <!--- supply items --->
		 AND     M.ItemClass = 'Supply'
					 
		 <!--- not customer provided and deducted on top 
		 
		 AND    ResourceItemNo NOT IN  (
		 
				 SELECT  ResourceItemNo
			     FROM    WorkOrderLineResource  
				 WHERE   WorkOrderId   = '#url.workorderid#'	
				 AND     WorkOrderLine = '#url.workorderline#'
				 AND     ResourceMode  = 'Receipt'
				 AND     ResourceUoM   = R.ResourceUoM )
				 
		 --->		 
				 
		 GROUP BY C.Description		 
		 
	</cfquery>
	
	<cfquery name="total" dbtype="query">
		SELECT SUM(Amount) as amount
		FROM supply
	</cfquery>
	
	<cfif total.amount eq "">
		<cfset bom = 0>
	<cfelse>
		<cfset bom = Total.amount>
	</cfif>	
		
	<tr><td style="padding-left:20px" class="labelmedium"> <cf_tl id="BOM Supplies"> </td>
	     <td class="labelmedium" align="right" style="padding-right:10px">#numberformat(bom,",__.__")#</td>
	</tr>
	
	<cfloop query="supply">
	<tr><td style="padding-left:40px" class="labelit">#Description#</td>
	     <td class="labelit" align="right" style="padding-right:40px">#numberformat(amount,",__.__")#</td>
	</tr>
	</cfloop>	
	
	<cfquery name="services" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		 SELECT  M.ItemDescription, ISNULL(SUM(Amount),0) as Amount	
	     FROM    WorkOrderLineResource R 		 		
				 INNER JOIN Materials.dbo.Item M ON M.ItemNo = R.ResourceItemNo	 
				 INNER JOIN Materials.dbo.Ref_Category C ON M.Category = C.Category
		 WHERE   WorkOrderId   = '#url.workorderid#'	
		 AND     WorkOrderLine = '#url.workorderline#'
		
		 <!--- service items --->
		 AND     M.ItemClass = 'Service'
		 <!---
		 AND     R.ResourceMode  != 'Receipt'
		 --->
							 
		GROUP BY ItemDescription		 
		
	</cfquery>
	
	<cfquery name="total" dbtype="query">
		SELECT SUM(Amount) as amount
		FROM services
	</cfquery>
	
	<cfif total.amount eq "">
		<cfset svc = 0>
	<cfelse>
		<cfset svc = total.amount>
	</cfif>	
	
	<tr><td style="padding-left:20px" class="labelmedium"> <cf_tl id="Standard Services"></td>
	     <td class="labelmedium" align="right" style="padding-right:10px">#numberformat(svc,",__.__")#</td>
	</tr>
	
	<cfloop query="services">
	<tr><td style="padding-left:40px" class="labelit">#ItemDescription#</td>
	     <td class="labelit" align="right" style="padding-right:40px">#numberformat(amount,",__.__")#</td>
	</tr>
	</cfloop>	
	
	<cfquery name="total" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  ISNULL(SUM(Amount),0) as Amount	
	     FROM    WorkOrderLineResource R 
		 WHERE   WorkOrderId   = '#url.workorderid#'	
		 AND     WorkOrderLine = '#url.workorderline#'		
		 <!--- 
		 AND     ResourceMode  != 'Receipt'
		 --->
	</cfquery>
	
		
	<cfset oth = total.amount-svc-bom>
	
	<tr><td style="padding-left:20px" class="labelmedium"> <cf_tl id="BOM adjustment"></td>
	    <td class="labelmedium" align="right" style="padding-right:10px">#numberformat(oth,",__.__")#</td>
	</tr>
	
	<tr>
	   <td></td>
	   <td class="line"></td>
	</tr>
		
	<tr><td style="padding-left:10px" class="labelmedium"><cf_tl id="Estimated Costs"></td>
	    <td class="labelmedium" align="right">#numberformat(total.amount,",__.__")#</td>
	</tr>		
					
	<tr><td></td></tr>
	
	<tr>
	   <td></td>
	   <td class="line"></td>
	</tr>
	<tr><td></td></tr>
	
	<tr><td class="labellarge"><b><cf_tl id="Estimated Production result"></td>
	    <td class="labellarge" align="right">
		
		<cfif tot-total.amount gt 0>
		#numberformat(tot-total.amount,",__.__")#
		<cfelse>
		<font color="FF0000">
		(#numberformat(tot-total.amount,",__.__")#)
		</cfif>
		
		</td>
	</tr>
	
	<tr>
	   <td></td>
	   <td class="line"></td>
	</tr>

</table>

</cfoutput>