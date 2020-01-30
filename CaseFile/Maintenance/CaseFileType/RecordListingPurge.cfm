
<cfquery name="Delete" 
    datasource="AppsCaseFile" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_ClaimTypeTab
	 WHERE Code = '#URL.Code#'
</cfquery>


<cfquery name="Delete" 
    datasource="AppsCaseFile" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_ElementClass
	 WHERE ClaimType = '#URL.Code#'
</cfquery>

<cfquery name="Delete" 
    datasource="AppsCaseFile" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_ClaimType
	 WHERE Code = '#URL.Code#'
</cfquery>



<cfinclude template="RecordListingDetail.cfm">
