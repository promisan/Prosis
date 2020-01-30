

<cfquery name="Delete" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM PurchaseExecution
		 WHERE ExecutionId = '#URL.id2#'
</cfquery>

<cfset url.id2 = "">
<cfinclude template="POViewDistribution.cfm">
