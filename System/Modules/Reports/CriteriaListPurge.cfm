
<cfquery name="Delete" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_ReportControlCriteriaList
		 WHERE ControlId    = '#URL.ID#' 
		   AND CriteriaName = '#URL.ID1#'
		   AND ListValue    = '#URL.ID2#'
</cfquery>

<script>
	 <cfoutput>
		 window.location = "CriteriaList.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1=#URL.ID1#"
	 </cfoutput> 
</script>	