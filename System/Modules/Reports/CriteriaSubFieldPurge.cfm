
<cfquery name="Delete" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_ReportControlCriteriaField
		 WHERE ControlId = '#URL.ID#' and CriteriaName = '#URL.ID1#'
		 AND FieldName = '#URL.ID2#'
</cfquery>

<cfinclude template="CriteriaSubField.cfm">
