

<cfquery name="Delete" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE UserReport 
		 SET ShowPopular = '#URL.St#'
		 WHERE ReportId = '#URL.ID#'
</cfquery>

<cfinclude template="RecordListing.cfm">
