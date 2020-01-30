
<!--- show the transaction --->


<cfoutput>

	<script>

		function processaction(act,des,doc,src) {
		if (confirm("Do you want to " + des + " this transaction ?")) {
		    window.location = "AssignmentActionProcess.cfm?action=1&act=" + act + "&doc=" + doc + "&src=" + src, "right";
	  	}
	}

</script>	
</cfoutput>

<cfquery name="SearchResult" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    	 SELECT * FROM EmployeeAction 		
		 WHERE  ActionDocumentNo = '#url.actionReference#'	
</cfquery>				

<cfset ActionStatus = SearchResult.actionStatus>

<cfinclude template="../Authorization/Staffing/TransactionViewDetail.cfm">

