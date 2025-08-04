<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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
