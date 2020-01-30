
<cfparam name="url.print" default="0">
<cfparam name="url.year" default="#year(now()-60)#">
<cfparam name="url.customerid" default="{00000000-0000-0000-0000-000000000000}">

<cfquery name="Charges"
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
   SELECT     R.Code, 
              R.Description, 
			  s.SelectionDate, 
			  s.Currency, ROUND(SUM(s.Amount), 2) AS Total
   FROM       skWorkOrderCharges AS s INNER JOIN
              ServiceItem AS R ON s.ServiceItem = R.Code INNER JOIN
              WorkOrder AS W ON s.WorkOrderId = W.WorkOrderId
   WHERE      SelectionDate >= '01/01/#url.year#' 
   AND        SelectionDate <= '12/31/#url.year#'	
   AND        W.CustomerId = '#url.customerid#'	 
   AND        R.Operational = 1 
   GROUP BY   R.Code, 
              R.Description, 
			  s.SelectionDate, 
			  s.Currency		  
   ORDER BY   s.SelectionDate, 
              R.Code		     
</cfquery>

<cf_divscroll>

<table width="97%" cellspacing="0" cellpadding="1" align="center">
	
	<cfif url.print eq "0">
	
	    <cfoutput>	
		<tr><td height="20" colspan="5" align="left"><a href="javascript:printcharges('#url.mission#','#url.customerid#','#url.year#')"><font color="0080FF">Print</font></a></td></tr>	
		</cfoutput>
		
	<cfelse>
			
		<cfquery name="Customer"
		   datasource="AppsWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
		   SELECT     *
		   FROM       Customer
		   WHERE      CustomerId = '#url.customerid#'	    
		</cfquery>
	
		<title>Print customer charges #Customer.CustomerName#</title>
		
		<cfoutput>
		<tr height="20">
	       <td colspan="4"><font face="Verdana" size="2"><b>#Customer.CustomerName#</td>		   
	   	</tr>
    	<tr><td colspan="5" class="line"></td></tr>	
		</cfoutput>
			
	</cfif>

	<tr height="20">
	   <td><font face="Verdana" size="1">Month</td>
	   <td><font face="Verdana" size="1">Service</td>
	   <td><font face="Verdana" size="1">Currency</td>
	   <td align="right"><font face="Verdana" size="1">Charged</td>
	   <td align="right" style="padding-right:3px"><font face="Verdana" size="1"><cfoutput>#url.year#</cfoutput> Year-to-date</td>
	</tr>
	<tr><td colspan="5" class="line"></td></tr>	

<cfoutput query="Charges" group="SelectionDate">

	<tr>
	   <td height="20"><font face="Verdana" size="1">#dateFormat(selectiondate,"MMMM")#</td>	 
	</tr>
	
	<cfoutput>
	
	<tr>
	   <td></td>
	   <td><font face="Verdana" size="1">#Description#</td>	 
	   <td><font face="Verdana" size="1">#Currency#</td>	 
	   <td align="right"><font face="Verdana" size="1">#numberformat(total,"__,__.__")#</td>	
	   
		<cfquery name="CumCharges"        
         dbtype="query">
			SELECT    SUM(Total) AS Total
   			FROM       Charges
   			WHERE      Code = '#Code#'
   			AND        SelectionDate >= '01/01/#url.year#' 
   			AND        SelectionDate <= '#selectiondate#'	
  		</cfquery>	   
	    
	   <td align="right"><font face="Verdana" size="1">#numberformat(CumCharges.total,"__,__.__")#</td>	
	</tr>
	<tr><td></td><td colspan="4" bgcolor="e7e7e7" height="1"></td></tr>
	
	</cfoutput>	
	
	<cfquery name="CumCharges"        
         dbtype="query">
			SELECT    SUM(Total) AS Total
   			FROM       Charges
   			WHERE      SelectionDate = '#selectiondate#'	
  		</cfquery>	   
		
	<cfquery name="Total"        
         dbtype="query">
			SELECT    SUM(Total) AS Total
   			FROM      Charges
   			WHERE     SelectionDate >= '01/01/#url.year#' 
   			AND       SelectionDate <= '#selectiondate#'	
  		</cfquery>	   	
	
	<tr>
	   <td></td>
	   <td><font face="Verdana" size="1"></td>	 
	   <td><font face="Verdana" size="1"></td>	 
	   <td style="border-top: solid gray 1px" align="right"><font face="Verdana" size="1"><b>#numberformat(CumCharges.total,"__,__.__")#</td>	 
	   <td style="border-top: solid gray 1px" align="right"><font face="Verdana" size="1"><b>#numberformat(Total.Total,"__,__.__")#</td>	
	</tr>

</cfoutput>

</table>

</cf_divscroll>

	

