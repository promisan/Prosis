
<cfquery name="Delete" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM UserReportCriteria
		 WHERE CriteriaId = '#URL.ID1#'
</cfquery>

<script>
	 <cfoutput>
	 window.location = "Criteria.cfm?ID=#URL.ID#&row=#URL.row#"
	 </cfoutput> 
</script>	