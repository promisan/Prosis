<cfoutput>

<table width="95%" cellspacing="4" cellpadding="4">

	<tr><td height="10"></td></tr>
	<tr><td colspan="2" style="font-size:34px" class="labellarge"> <cf_tl id="Quotation"></td></tr>
	
	<tr>	  
	   <td colspan="2" class="line"></td>
	</tr>

	<tr><td height="6"></td></tr>
	
	<tr><td class="labellarge"><b> <cf_tl id="Sale"></td>
	    <td class="labelmedium" align="right"></td>
	</tr>
				
	<cfquery name="sale" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  ISNULL(SUM(SaleAmountIncome),0) as SaleIncome,
		 		 ISNULL(SUM(SaleAmountTax),0) as SaleTax
	     FROM    WorkOrderLineItem WOL 
		 WHERE   WorkOrderId  = '#url.workorderid#'	
		 AND     WorkOrderLine = '#url.workorderline#'
	</cfquery>
	
	<cf_exchangeRate 
        CurrencyFrom = "#workorder.currency#" 
        CurrencyTo   = "#application.BaseCurrency#"
		EffectiveDate= "#dateformat(workorder.orderdate,client.dateformatshow)#">
																				
	<cfset tot = sale.SaleIncome*exc>
	<cfset tax = sale.SaleTax*exc>
	
	<tr><td style="padding-left:10px" width="90%" class="labelmedium"> <cf_tl id="Gross Sales Value"></td>
	    <td align="right">
		<table>
		<tr>
		<td class="labelit" align="right" style="padding-right:6px">(#numberformat(tax,",__.__")#)</td>
	    <td class="labelmedium" align="right">#numberformat(tot,",__.__")#</td>
		</tr>
		</table>
		</td>
	</tr>
	
	<cfquery name="salesub" 
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
	
	<cfloop query="salesub">
	
	<cfset tot = SaleIncome*exc>
	
	<tr>
		<td class="labelit" style="padding-left:20px">#CategoryItemName#</td>
		<td class="labelit" align="right" style="padding-right:10px">#numberformat(tot,",__.__")#</td>
	</tr>
	
	</cfloop>
	
	<tr>
	   <td></td>
	   <td class="line"></td>
	</tr>
		
	<cfquery name="customer" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  ISNULL(SUM(Amount),0) as Amount	
	     FROM    WorkOrderLineResource R 
		 WHERE   WorkOrderId   = '#url.workorderid#'	
		 AND     WorkOrderLine = '#url.workorderline#'
		 AND     ResourceMode  = 'Receipt'
	</cfquery>
	
	<cfset cus = customer.amount>
	
	<cfif cus neq "0">
	
	<tr>
	    <td style="padding-left:10px" class="labelmedium"> <cf_tl id="Received Customer materials"></td>
		<td class="labelmedium" align="right"><font color="6688aa">#numberformat(cus,",__.__")#</td>
	</tr>
	
	<tr>
	   <td></td>
	   <td class="line"></td>
	</tr>
	
	<cfset net = tot - cus>
		
	<tr><td style="padding-left:10px" class="labelmedium"> <cf_tl id="Sale value"></td>
	    <td class="labelmedium" align="right"><b>#numberformat(net,",__.__")#</td>
	</tr>
	
	</cfif>
	
	<cfset net = tot-cus>
	
	<tr><td height="15"></td></tr>
	
	<tr><td class="labellarge"><b> <cf_tl id="Costing"></td>
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
					 
		 <!--- not customer provided and deducted on top --->
		 
		 AND    ResourceItemNo NOT IN  (
		 
				 SELECT  ResourceItemNo
			     FROM    WorkOrderLineResource  
				 WHERE   WorkOrderId   = '#url.workorderid#'	
				 AND     WorkOrderLine = '#url.workorderline#'
				 AND     ResourceMode  = 'Receipt'
				 AND     ResourceUoM   = R.ResourceUoM )
				 
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
		
	<tr><td style="padding-left:10px" class="labelmedium"> <cf_tl id="BOM Supplies"> </td>
	     <td class="labelmedium" align="right" style="padding-right:0px">#numberformat(bom,",__.__")#</td>
	</tr>
	
	<cfloop query="supply">
	<tr><td style="padding-left:20px" class="labelit">#Description#</td>
	     <td class="labelit" align="right" style="padding-right:10px"><font color="808080">#numberformat(amount,",__.__")#</td>
	</tr>
	</cfloop>	
	
	<cfquery name="services" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		 SELECT  Description, ISNULL(SUM(Amount),0) as Amount	
	     FROM    WorkOrderLineResource R 		 		
				 INNER JOIN Materials.dbo.Item M ON M.ItemNo = R.ResourceItemNo	 
				 INNER JOIN Materials.dbo.Ref_Category C ON M.Category = C.Category
		 WHERE   WorkOrderId   = '#url.workorderid#'	
		 AND     WorkOrderLine = '#url.workorderline#'
		
		 <!--- service items --->
		 AND     M.ItemClass = 'Service'
		 AND     R.ResourceMode != 'Receipt'
							 
		GROUP BY Description		 
		
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
	
	<tr><td style="padding-left:10px" class="labelmedium"> <cf_tl id="Labor and services"></td>
	     <td class="labelmedium" align="right" style="padding-right:0px">#numberformat(svc,",__.__")#</td>
	</tr>
	
	<cfif services.recordcount gte "2">
	
	<cfloop query="services">
	<tr><td style="padding-left:20px" class="labelit">#Description#</td>
	     <td class="labelit" align="right" style="padding-right:10px"><font color="808080">#numberformat(amount,",__.__")#</td>
	</tr>
	</cfloop>	
	
	</cfif>
	
	<cfquery name="total" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  ISNULL(SUM(Amount),0) as Amount	
	     FROM    WorkOrderLineResource R 
		 WHERE   WorkOrderId   = '#url.workorderid#'	
		 AND     WorkOrderLine = '#url.workorderline#'		 
		 AND     ResourceMode  != 'Receipt'
	</cfquery>
	
	
	<cfset oth = total.amount-svc-bom>
	
	<cfif abs(oth) gte 0.01>
	
		<tr><td style="padding-left:10px" class="labelmedium"> <cf_tl id="BOM Corrections"></td>
		    <td class="labelmedium" align="right" style="padding-right:10px">#numberformat(oth,",__.__")#</td>
		</tr>
		
		
	
	</cfif>
	
	<tr>
		   <td></td>
		   <td class="line"></td>
		</tr>
		
	<tr><td style="padding-left:10px" class="labelmedium"><cf_tl id="Estimated Direct Costs"></td>
	    <td class="labelmedium" align="right"><b>#numberformat(total.amount,",__.__")#</td>
	</tr>		
	
	<tr><td height="15"></td></tr>

	<tr><td class="labelmedium"><cf_tl id="Gross Margin"></td>
	    <td class="labelmedium" align="right">
		<cfif net-total.amount gt 0>
		<font color="6688aa">
		#numberformat(net-total.amount,",__.__")#
		<cfelse>
		<font color="FF0000">
		(#numberformat(net-total.amount,",__.__")#)
		</cfif>
		</td>
	</tr>
	
	<tr><td></td></tr>
	
	<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *
	     FROM    WorkOrder
		 WHERE   WorkOrderId  = '#url.workorderid#'			 
	</cfquery>
	
	<cfset overhead = net * (workorder.orderoverhead/100)>
	
	<cfset overhead = "0">
	
	<tr><td style="padding-left:20px" class="labelit"><cf_tl id="Overhead provision"> #workorder.orderoverhead#%</td>
	    <td class="labelit" align="right" style="padding-right:10px">#numberformat(overhead,",__.__")#</td>
	</tr>
	
	<tr><td></td></tr>
	
	<tr>
	   <td></td>
	   <td class="line"></td>
	</tr>
	<tr><td height="5"></td></tr>
	
	<tr><td class="labellarge"><b><cf_tl id="Estimated Margin"></td>
	    <td class="labellarge" align="right">
		
		<cfif net-total.amount-overhead gt 0>
		<font color="008000">
		#numberformat(net-total.amount-overhead,",__.__")#
		<cfelse>
		<font color="FF0000">
		(#numberformat(net-total.amount-overhead,",__.__")#)
		</cfif>
		
		</td>
	</tr>
	
	<tr>
	   <td></td>
	   <td class="line"></td>
	</tr>

</table>

</cfoutput>