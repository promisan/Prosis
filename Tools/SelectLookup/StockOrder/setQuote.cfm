

<cfoutput>

<cfif url.action eq "delete">
	
	<cfquery name="set" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	    DELETE FROM CustomerRequest
		WHERE RequestNo = '#url.id#'
		
	</cfquery>
	
	<script>
	 document.getElementById('r#url.id#').className = "hide"	
	</script>

</cfif>

</cfoutput>