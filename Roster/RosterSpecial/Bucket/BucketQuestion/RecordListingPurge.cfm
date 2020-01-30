
<cfquery name="Delete" 
    datasource="AppsSelection" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM FunctionOrganizationTopic
	 WHERE TopicId = '#URL.TopicId#'
	 AND   FunctionId = '#url.idfunction#'
</cfquery>

<cfinclude template="RecordListingDetail.cfm">
