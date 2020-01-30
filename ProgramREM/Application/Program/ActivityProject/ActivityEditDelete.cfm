
<cftransaction>
	
	<cfquery name = "DeleteActivity" 
		datasource= "AppsProgram" 
		username  = "#SESSION.login#" 
		password  = "#SESSION.dbpw#">
		UPDATE  ProgramActivity 
	    SET     RecordStatus = '9'
		WHERE   ActivityId = '#URL.ActivityId#'	 
	</cfquery>		
					
	<!--- remove child or parent records --->	
	
	<cfquery name="DeleteDependency" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE ProgramActivityParent
	    WHERE  ActivityId = '#URL.ActivityId#' OR ActivityParent = '#URL.ActivityId#'		 
	</cfquery>	

</cftransaction>

<!--- should also recalculated the dates --->	 

<script>
    
	try { opener.document.getElementById('progressrefresh').click() } catch(e) { }
	window.close()
	    
</script>	