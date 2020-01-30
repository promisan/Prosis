
<cfparam name="url.customerid" default="">

<cfquery name="WorkOrder" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrder
		 WHERE   WorkOrderId       = '#url.workorderid#'
</cfquery>

<cfif url.CustomerId neq "">
		
	<cfquery name="Customer" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Customer
		WHERE  CustomerId = '#url.customerid#'	
	</cfquery>
	
<cfelse>
	
	<cfquery name="Customer" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Customer
		WHERE  CustomerId = '#workorder.customerid#'	
	</cfquery>
	
</cfif>

<table width="300" cellspacing="0" cellpadding="0">


    <tr><td>
	
	<cfoutput query="Customer">
		<input type="hidden" name="Customerid" id="Customerid" value="#Customer.CustomerId#">		
	</cfoutput>
	
	</td>

	<td style="padding-left:3px;padding-top:1px;padding-bottom:1px;height:25px;border-left: 1px solid Silver;border-right: 1px solid Silver;border-top: 1px solid Silver;border-bottom: 1px solid Silver;">
	<cfoutput query="Customer">
	#Customer.CustomerName#
	</cfoutput>
	</td>
	
</tr></table>
