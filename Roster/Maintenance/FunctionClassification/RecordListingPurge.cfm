
<cfquery name="Delete" 
    datasource="AppsSelection" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_FunctionClassificationParent
	 WHERE Code = '#URL.Code#'
</cfquery>

<cfinclude template="RecordListingDetail.cfm">
