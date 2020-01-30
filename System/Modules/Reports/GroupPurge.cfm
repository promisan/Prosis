
<cfquery name="Delete" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_ReportControlUserGroup
		 WHERE ControlId = '#URL.ID#' and Account = '#URL.ID1#'
</cfquery>

<cfset url.id1 = "">

<cfinclude template="Group.cfm">