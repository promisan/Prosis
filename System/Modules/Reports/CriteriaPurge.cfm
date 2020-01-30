
<cfquery name="Delete" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_ReportControlCriteria
		 WHERE ControlId = '#URL.ID#' and CriteriaName = '#URL.ID1#'
</cfquery>

<cf_uiupdate controlid = "#URL.ID#">

<script>
	 <cfoutput>
	 window.location = "Criteria.cfm?Status=#URL.Status#&ID=#URL.ID#"
	 </cfoutput> 
</script>	