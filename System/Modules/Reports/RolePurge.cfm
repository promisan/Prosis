<cf_compression>

<cfquery name="Delete" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_ReportControlRole 
		 WHERE ControlId = '#URL.ID#' and Role = '#URL.ID1#'
</cfquery>

<cfset url.id1 = "">

<cfinclude template="Role.cfm">
