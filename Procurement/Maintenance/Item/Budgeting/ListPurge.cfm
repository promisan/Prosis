
<cfquery name="Delete" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM ItemMasterList
		 WHERE  ItemMaster     = '#URL.Code#'
		 AND    TopicValueCode = '#URL.id2#'
</cfquery>

<cfset url.id2 = "">
<cfinclude template="List.cfm">
