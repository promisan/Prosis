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

<cfoutput>

	<script language="JavaScript1.2">
	
	function showrole(role)	{
		w = #CLIENT.width# - 80;
		h = #CLIENT.height# - 120;
		window.open("#SESSION.root#/System/Access/Global/OrganizationRolesView.cfm?Class=" + role, "_blank", "left=40, top=40, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes")
	
	}
	
	</script>
	
</cfoutput>

<cf_InsertRolesData>

<!--- query --->

<table width="100%" border="1" bordercolor="silver" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<cfquery name="Role" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  R.*, S.Description as ModuleName
	FROM    Ref_AuthorizationRole R, System.dbo.Ref_SystemModule S
	WHERE   R.SystemModule = S.SystemModule
	AND     S.Operational = '1'
	AND     R.OrgUnitLevel IN ('Global','Tree','Parent','All')
	<cfif SESSION.isAdministrator eq "No">
	AND     R.RoleOwner IN (SELECT ClassParameter 
	                        FROM OrganizationAuthorization
							WHERE Role = 'AdminUser'
							AND  UserAccount = '#SESSION.acc#')
	AND     R.SystemModule != 'System'						
	</cfif>
	ORDER BY R.Area, R.SystemModule, R.SystemFunction, R.Description
</cfquery>

<tr><td height="22" colspan="8" class="top4n">&nbsp;&nbsp;<b>Global system roles</b></td></tr>

<tr><td>
	<cfinclude template="../../Organization/Access/OrganizationRolesDetail.cfm">
</td></tr>

</table>
