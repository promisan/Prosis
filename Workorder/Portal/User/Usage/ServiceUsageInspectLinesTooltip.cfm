<cfif url.content eq "NonBillable">
	    <cfset dbselect = "NonBillable">
<cfelse>
	    <cfset dbselect = "">		
</cfif>

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">		
	SELECT    * 
	FROM      WorkorderLine 
	WHERE     WorkorderLineId = '#url.workorderlineid#'
</cfquery>

<cfquery name="getCalls" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">		
	SELECT    *
	FROM      WorkOrderLineDetail#dbselect# 
	WHERE     WorkOrderId   = '#get.workorderid#' 
	AND       WorkOrderLine = '#get.workorderline#'
	AND       year(TransactionDate)  = '#url.year#'
	AND       month(TransactionDate) = '#url.month#'	
	AND       day(TransactionDate)   = '#url.day#'	
	
	<cfif url.ref neq "">
	AND       Reference LIKE ('%#url.ref#%')	
	</cfif>		
	
	<cfif dbselect eq "">
	AND      ActionStatus != '9'
	</cfif>
</cfquery>


<cfset sel=CreateDate(URL.year,URL.month,URL.Day)>

<table align="center" cellspacing="2" cellpadding="2">
<tr>
<td class="labelit">
<cfoutput>
  #dateformat(sel,"DDDD #CLIENT.DateFormatShow#")#
</cfoutput>	
</td>
</tr>
<tr>
<td class="labelit">
<cfoutput>
  Total of traffic: <b>#getCalls.recordcount#</b>
</cfoutput>	
</td>
</tr>
</table>
