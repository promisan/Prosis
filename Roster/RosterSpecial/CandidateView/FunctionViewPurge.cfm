
<cfquery name="Remove" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM FunctionOrganization
	WHERE FunctionId = '#URL.ID#' 
</cfquery>

<cfquery name="Remove" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Document
	SET   FunctionId = NULL
	WHERE FunctionId = '#URL.ID#' 
</cfquery>

<cfoutput>
<script language="JavaScript">
   
	try { opener.document.getElementById("line_#URL.ID#").className = "hide" } catch(e) { opener.history.go() }
	 window.close()
		
</script>
</cfoutput>