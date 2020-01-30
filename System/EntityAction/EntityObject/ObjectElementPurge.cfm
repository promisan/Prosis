
<cfif SESSION.isAdministrator eq "Yes">

<cfquery name="Delete" 
    datasource="AppsOrganization" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM OrganizationObjectDocument
	 WHERE DocumentId = '#URL.ID2#'	
</cfquery>

</cfif>

<cfquery name="Delete" 
    datasource="AppsOrganization" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_EntityDocument
	 WHERE EntityCode = '#URL.EntityCode#'
	 AND DocumentId = '#URL.ID2#'	
</cfquery>

<cfinclude template="ObjectElement.cfm">
