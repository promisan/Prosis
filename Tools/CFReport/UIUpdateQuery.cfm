
<cfquery name="Criteria" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE Ref_ReportControlCriteria 
	 SET _UIBox = '#Box#', _UIPosition = '#cnt#'
	 WHERE CriteriaName = '#CriteriaName#'
	 AND   ControlId = '#Attributes.ControlID#' 
</cfquery>