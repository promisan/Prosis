
<cfparam name="Form.Selected" default="">

<cfif Form.Selected neq "">

<cfquery name="Delete" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM UserReport 
		 WHERE ReportId IN (#preserveSingleQuotes(Form.selected)#) 
</cfquery>

</cfif>

<cfinclude template="SelfServiceExtendedContent.cfm">
