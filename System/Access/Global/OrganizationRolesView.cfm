
<cfquery name="Role" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM    Ref_AuthorizationRole
	WHERE   Role = '#URL.Class#' 
</cfquery>

<cfoutput>
	
	<cfset url.id4 = URL.Class>
	<cfset url.context = "1">
	<cfinclude template="OrganizationListing.cfm">

</cfoutput>


