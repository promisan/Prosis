
<cfquery name="Delete" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_PersonGroupList
		 WHERE GroupCode = '#URL.Code#'
		 AND   GroupListCode = '#URL.id2#'
</cfquery>

<cfset url.id2 = "">
<cfinclude template="List.cfm">
