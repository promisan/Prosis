
<!--- set the selected account --->


<cfquery name="get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Program
		WHERE  ProgramCode = '#URL.ProgramCode#'
	</cfquery>

<cfoutput>
	
<script>    
	document.getElementById("programcode#url.scope#").value        = '#get.ProgramCode#'		
	document.getElementById("programdescription#url.scope#").value = '#get.ProgramName#'		
	
</script>	

</cfoutput>