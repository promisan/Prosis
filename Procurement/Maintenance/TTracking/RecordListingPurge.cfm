
<cfquery name="Delete" 
    datasource="AppsPurchase" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_Transport
	 WHERE Code = '#URL.Code#'
</cfquery>

<cfinclude template="RecordListingDetail.cfm">
