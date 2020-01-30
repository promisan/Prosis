

<cfoutput>

<cfquery name="Candidate" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
   		DELETE FROM Applicant
   		WHERE  PersonNo = '#URL.PersonNo#'   		
   	</cfquery>

<script>
	parent.window.location = "#SESSION.root#/Roster/Candidate/Details/PHPView.cfm?ID=#URL.PersonNo#&mode=Manual"
</script>

</cfoutput>