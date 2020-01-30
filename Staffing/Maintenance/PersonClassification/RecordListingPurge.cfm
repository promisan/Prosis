
<cfquery name="Delete" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_PersonGroup
	 WHERE Code = '#URL.Code#'
</cfquery>

<cfinclude template="RecordListingDetail.cfm">
