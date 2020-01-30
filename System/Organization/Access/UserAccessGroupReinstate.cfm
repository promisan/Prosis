
<cfquery name="Restore" 
  datasource="AppsOrganization"  
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT TOP 1 *
  FROM   OrganizationAuthorizationDeny
  WHERE  AccessId = '#URL.accessID#'
</cfquery>

<cfquery name="RemoveManual" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM OrganizationAuthorization
	WHERE UserAccount  = '#Restore.UserAccount#'
	<cfif Restore.OrgUnit neq "">
	AND OrgUnit        = '#Restore.OrgUnit#'
	</cfif>
	<cfif Restore.Mission neq "">
	AND Mission        = '#Restore.Mission#'
	</cfif>
	AND Role           = '#Restore.Role#'
	AND ClassParameter = '#Restore.ClassParameter#'
	AND Source         = 'Manual' 
</cfquery>

<cfquery name="RestoreData" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO OrganizationAuthorization
	SELECT * 
	FROM   OrganizationAuthorizationDeny
	WHERE  AccessId = '#URL.accessID#'
</cfquery>

<cfquery name="RemoveDeny" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM OrganizationAuthorizationDeny
	
	WHERE UserAccount  = '#Restore.UserAccount#'
	<cfif Restore.OrgUnit neq "">
	AND OrgUnit        = '#Restore.OrgUnit#'
	</cfif>
	<cfif Restore.Mission neq "">
	AND Mission        = '#Restore.Mission#'
	</cfif>
	AND Role           = '#Restore.Role#'
	AND ClassParameter = '#Restore.ClassParameter#'
	AND GroupParameter = '#Restore.GroupParameter#'
	
</cfquery>

<cfinclude template="UserAccessListingDetail.cfm">
