
<cfquery name="Delete" 
    datasource="AppsCaseFile" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 DELETE FROM Ref_ElementSection
	 WHERE Code = '#URL.Code#'
</cfquery>

<cfinclude template="RecordListingDetail.cfm">
