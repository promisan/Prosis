
<!--- draft workflow --->
<cfquery name="Delete" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_EntityClassAction
		 WHERE ActionCode = '#URL.ID2#'
</cfquery>

<!--- library --->
<cfquery name="Delete" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_EntityAction
		 WHERE ActionCode = '#URL.ID2#'
</cfquery>

<!--- access --->
<cfquery name="DeleteSync" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM OrganizationAuthorization
		 WHERE ClassParameter = '#URL.ID2#'
		 AND ClassisAction = '1'
</cfquery>

<cfinclude template="ActionRecords.cfm">
