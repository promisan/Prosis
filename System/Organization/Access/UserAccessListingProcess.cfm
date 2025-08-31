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
<!--- steps
1. Create action record
2. Register access records under log
3. Update status if deleted = 9
3. if delete, remove from Organization action
 --->

<cf_AssignId>

<cftransaction>

<cfquery name="Instance" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO UserAuthorizationAction
        (ProfileActionId, UserAccount, OfficerUserId, OfficerLastName, OfficerFirstName)
VALUES  ('#rowguid#','#URL.ID#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
</cfquery>

<cfquery name="UI" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   A.AccessId
FROM     OrganizationAuthorization A INNER JOIN
         Ref_AuthorizationRole R ON A.Role = R.Role LEFT OUTER JOIN
         Organization Org ON A.OrgUnit = Org.OrgUnit
WHERE    A.UserAccount = '#URL.ID#' 
AND      A.AccessId NOT IN (SELECT AccessId 
                            FROM UserAuthorizationActionLog
							WHERE ActionStatus IN ('1','9'))
<cfif SESSION.isAdministrator eq "No">
AND     R.RoleOwner IN (SELECT ClassParameter 
                        FROM OrganizationAuthorization
						WHERE Role = 'AdminUser'
						AND  AccessLevel = '2'
						AND  UserAccount = '#SESSION.acc#')
AND     R.SystemModule != 'System'						
</cfif>
ORDER BY R.SystemModule, R.Description,A.AccessId 
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
	         A.AccessId,
			 A.Mission, 
			 A.OrgUnit, 
			 A.UserAccount,
			 A.Role, 
			 A.ClassParameter, 
			 A.GroupParameter, 
			 A.ClassIsAction, 
	         A.AccessLevel, 
			 A.Source, 
			 A.OfficerUserId, 
			 A.OfficerLastName, 
			 A.OfficerFirstName, 
			 A.Created
	FROM     OrganizationAuthorization A INNER JOIN
	         Ref_AuthorizationRole R ON A.Role = R.Role LEFT OUTER JOIN
	         Organization Org ON A.OrgUnit = Org.OrgUnit
	WHERE    A.UserAccount = '#URL.ID#' 
	AND      A.AccessId NOT IN (SELECT AccessId 
	                            FROM UserAuthorizationActionLog
								WHERE ActionStatus IN ('1','9')) 
	<cfif SESSION.isAdministrator eq "No">
	AND     R.RoleOwner IN (SELECT ClassParameter 
	                        FROM OrganizationAuthorization
							WHERE Role = 'AdminUser'
							AND  AccessLevel = '2'
							AND  UserAccount = '#SESSION.acc#')
	AND     R.SystemModule != 'System'						
	</cfif>
	ORDER BY R.SystemModule, R.Description
</cfquery>

<cfoutput query="UI">

<cftry>

<cfif evaluate("Form.a#currentRow#") eq "9">

	<!--- set status in log --->
	
	<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE UserAuthorizationActionLog
	SET    ActionStatus = '9' 
	WHERE  ProfileActionId = '#rowguid#'
	AND    AccessId = '#AccessId#'
	</cfquery>
	
	<!--- remove entry --->
	
	<cfquery name="Delete" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM OrganizationAuthorization
	WHERE  AccessId = '#AccessId#'
	</cfquery>

</cfif>

<cfcatch></cfcatch>

</cftry>

</cfoutput>

</cftransaction>

<cfinclude template="UserAccessListingPendingLines.cfm">


