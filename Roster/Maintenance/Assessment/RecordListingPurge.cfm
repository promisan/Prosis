
<cfquery name="Delete" 
    datasource="AppsSelection" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_AssessmentCategory
	 WHERE Code = '#URL.Code#'
</cfquery>

<cfinclude template="RecordListingDetail.cfm">
