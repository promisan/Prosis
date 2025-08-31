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
<cfparam name="url.Year" default="2010">
<cfparam name="url.Month" default="2010">

<cfset sel = CreateDate(year, month, "1")>
<cfset end = CreateDate(year,month,daysinmonth(sel))>

<cfquery name="UsageDetail"
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
 						  
	  SELECT    ISNULL(LabelQuantity ,'Qty') as LabelQuantity,
				ISNULL(LabelCurrency,'Currency') as LabelCurrency,
				ISNULL(LabelRate,'Rate') as LabelRate,
			    BD.Amount	
	   FROM     ServiceitemUnit L INNER JOIN
                WorkOrderLineDetail BD ON L.ServiceItem = BD.ServiceItem AND L.Unit = BD.ServiceItemUnit INNER JOIN
				Ref_UnitClass C ON L.UnitClass = C.Code
	   WHERE    BD.WorkOrderId   = '#url.workorderid#'			   
       AND      BD.WorkOrderLine = '#url.workorderline#'	
	   AND      BD.TransactionDate >= #sel#	 
	   AND      BD.TransactionDate <= #end#	     		 				  
	   AND      BD.Amount > 0					 				  						  				  
	   ORDER BY C.ListingOrder, 
	            L.ListingOrder, 
				BD.ServiceItemUnit, 
				BD.TransactionDate 	  	  
</cfquery>	

<cfquery name="PersonalUsageSummary"
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
   SELECT isnull(SUM(Amount),0) AS Amount
   FROM   WorkOrderLineDetail D
   INNER JOIN WorkOrderLineDetailCharge C ON D.TransactionId = C.TransactionId
   WHERE  D.WorkOrderId   = '#url.workorderid#'			   
   AND	  D.WorkOrderLine = '#url.workorderline#'	
   AND    D.TransactionDate >= #sel#
   AND    D.TransactionDate <= #end#
   AND    D.ActionStatus != '9'
   and    C.Charged = '2'  		 				  
</cfquery>	

<cfquery name="Total" dbtype="query">
	SELECT   SUM(Amount) as Total
	FROM     UsageDetail
</cfquery>	

<cfquery name="DetailLabel" dbtype="query">
	SELECT   DISTINCT LabelCurrency
	FROM     UsageDetail
</cfquery>	

<cfoutput>

<table align="left"  width="100%" cellpadding="0" cellspacing="0">
	<tr>
	   <td class="labelit"><cf_tl id="Business Total"></td>
	   <td class="labelit" align="right"><b>#numberformat(Total.Total-PersonalUsageSummary.Amount,",.__")#</b></td>
	</tr>
	<tr>
	   <td class="labelit"><cf_tl id="Personal Total"></td>
	   <td class="labelit" align="right"><b>#numberformat(PersonalUsageSummary.Amount,",.__")#</b></td>
	</tr>
	<tr><td colspan="2" align="right" style="border-top:solid gray 1px"></td></tr>

	<tr>
	   	<td class="labelit"><cf_tl id="Total Charges"></td>	
		<td class="labelit" align="right"><b>#DetailLabel.LabelCurrency# #numberformat(Total.Total,",.__")#</b></td>
	</tr>

</table>

</cfoutput>