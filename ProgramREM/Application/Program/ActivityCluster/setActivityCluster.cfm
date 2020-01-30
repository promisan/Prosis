
<cfoutput>

<cfquery name="set" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE  ProgramActivity
		<cfif url.activityclusterid eq "">
		SET   ActivityClusterId = NULL
		<cfelse>		
		SET   ActivityClusterId = '#url.activityclusterid#'
		</cfif>		
		WHERE ActivityId = '#url.activityid#'		
</cfquery>

<script>
	try { opener.document.getElementById('progressrefresh').click(); } catch(e) {  }
</script>

</cfoutput>		