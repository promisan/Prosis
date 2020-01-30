
<cfquery name="Delete" 
    datasource="#url.alias#" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_Funding
	 WHERE FundingId = '#URL.FundingId#'
</cfquery>

<cfinclude template="RecordListingDetail.cfm">
