
<cfquery name="Delete" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_EntityUsage
		 WHERE ObjectUsage = '#URL.ID2#'
		 AND EntityCode = '#URL.EntityCode#'
</cfquery>

<cfset url.id2 = "new">
<cfinclude template="ActionUsage.cfm">
