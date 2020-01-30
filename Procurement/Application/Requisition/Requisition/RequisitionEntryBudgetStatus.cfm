
<cfif url.action eq "true">
   <cfset act = 1>
<cfelse>
   <cfset act = 9>   
</cfif>

<cfquery name="Status" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
       UPDATE RequisitionLineBudget
	   SET    Status = '#act#', 
	          StatusUserid = '#SESSION.acc#',
			  StatusDate = getDate()
	   WHERE BudgetId = '#url.id#'
</cfquery>