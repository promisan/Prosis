
<cfquery name="Customer" 
	datasource="AppsWorkorder"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT C.CustomerName, W.Reference, W.OrderDate
	FROM   Workorder W, Customer C
	WHERE  WorkorderId = '#url.workorderid#'
	AND    W.CustomerId = C.CustomerId	
</cfquery>	

<cfoutput>
#Customer.CustomerName# #Customer.Reference#
</cfoutput>