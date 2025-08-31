<!--
    Copyright © 2025 Promisan B.V.

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
  maxrows=1 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT *
	  FROM   OrganizationAuthorizationDeny
	  WHERE  AccessId = '#URL.accessID#'
</cfquery>

<!--- provision to remove any possible manual records here, as they would conflict the group --->

<cftransaction>

	<!--- logging of the restore action --->
	
	<cf_assignId>
	
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
		AND GroupParameter = '#Restore.GroupParameter#'
		AND Source         = 'Manual'
	</cfquery>
							
	<cfquery name="Instance" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO UserAuthorizationAction
		        (ProfileActionId, 
				 UserAccount, 
				 Memo,
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName)
		VALUES  ('#rowguid#',
		         '#Restore.UserAccount#',
				 'Reinstate Group Access',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')
	</cfquery>
	
	<cfquery name="Log" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
			INSERT INTO UserAuthorizationActionLog
			        (ProfileActionId, 
					 ActionStatus, 
					 AccessId, 
					 Mission, 
					 OrgUnit, 
					 UserAccount, 
					 Role, 
					 ClassParameter, 
					 GroupParameter, 
					 ClassisAction, 
					 AccessLevel, 
					 Source, 
			         OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName, 
					 Created)								 
					 
			SELECT   '#rowguid#',
			         '1',
			         AccessId,
					 Mission, 
					 OrgUnit, 
					 UserAccount,
					 Role, 
					 ClassParameter, 
					 GroupParameter, 
					 ClassIsAction, 
			         AccessLevel, 
					 Source, 
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName, 
					 getDate()
					 
			FROM    OrganizationAuthorizationDeny
			WHERE   AccessId = '#URL.AccessID#'					 							 		 		
	</cfquery>
	
	<cfquery name="Insert" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO OrganizationAuthorization
		SELECT * 
		FROM   OrganizationAuthorizationDeny
		WHERE  AccessId = '#URL.accessID#'
	</cfquery>
	
	<!--- we remove all entries of any group that might have been effective here --->
	
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

</cftransaction>

<!--- logging of the reinstate action --->

<cfinclude template="OrganizationListing.cfm">
