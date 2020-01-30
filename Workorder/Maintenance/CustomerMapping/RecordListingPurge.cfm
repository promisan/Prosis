
<cfquery name="Delete" 
    datasource="AppsWorkOrder" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM stCustomerMapping
	WHERE TransactionId = '#URL.ID#'
</cfquery>

<cfinclude template="RecordListingDetail.cfm">
