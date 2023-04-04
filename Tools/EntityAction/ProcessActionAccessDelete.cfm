
<cfparam name="URL.account"      default="">
<cfparam name="URL.ActionDelete" default="#URL.ActionCode#">

<cfif url.account neq "">
	
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

</cfif>

<cfinclude template="ActionListingActor.cfm">
