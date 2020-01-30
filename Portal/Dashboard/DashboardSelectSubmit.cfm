<!--- Create Criteria string for query from data entered thru search form --->

<HTML>

<HEAD>

<TITLE>Save dashboard</TITLE>
	
</HEAD>

<cfif #URL.ID# neq "">

<cfquery name="Settings" 
 datasource="AppsSystem" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 UPDATE UserDashboard
   SET ReportId = '#URL.ID#', 
       ReportType = '#URL.Type#'
 WHERE Account = '#SESSION.acc#'
 AND DashboardFrame = '#frm#'
</cfquery>

<cfif #URL.Type# eq "Topic">

<cftry>

	<cfquery name="Settings" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	INSERT UserModule
	(Account,SystemFunctionId, Status)
	VALUES ('#SESSION.acc#', '#URL.ID#','9')
	</cfquery>

	<cfcatch></cfcatch>

</cftry>

</cfif>

<cfelse>

<cfquery name="Settings" 
 datasource="AppsSystem" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 UPDATE UserDashboard
   SET ReportId = NULL, 
       ReportType = '#URL.Type#'
 WHERE Account = '#SESSION.acc#'
 AND DashboardFrame = '#frm#'
</cfquery>

</cfif>

<script language="JavaScript">
 window.close()
 opener.history.go()
</script>