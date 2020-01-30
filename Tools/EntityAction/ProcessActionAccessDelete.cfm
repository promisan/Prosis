
<cfparam name="URL.ActionDelete" default="#URL.ActionCode#">

<!--- remove role --->

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM OrganizationObjectActionAccess 
	WHERE UserAccount = '#URL.account#'
	 AND  ObjectId    = '#URL.ObjectID#'
	 AND  ActionCode  = '#URL.ActionDelete#' 
</cfquery>

<cfinclude template="ActionListingActor.cfm">
