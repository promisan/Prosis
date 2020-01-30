
<cfquery name="Delete" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM FunctionRequirementLineField
		 WHERE ExperienceFieldId = '#URL.id2#'
</cfquery>

<cfquery name="Delete" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_Experience
		 WHERE ExperienceFieldId = '#URL.id2#'
</cfquery>

<cfset url.id2 = "">
<cfinclude template="List.cfm">
