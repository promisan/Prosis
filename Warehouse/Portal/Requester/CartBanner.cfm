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
<tr><td colspan="3" bgcolor="ffffff" valign="top">
	
	<cfoutput>
	
	<cfquery name="User" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
	    FROM UserNames
	    WHERE Account = '#SESSION.acc#'
	</cfquery>
	
	<cfquery name="Unit" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 *
	    FROM  UserMission U, Organization.dbo.Organization O
		WHERE U.OrgUnit = O.OrgUnit
		AND   U.Account = '#SESSION.acc#'   
	</cfquery>
		
	<cfquery name="Parent" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM  Organization 
	WHERE OrgUnitCode = '#Unit.ParentOrgUnit#'  
	AND  Mission = '#Unit.Mission#'
	AND  MandateNo = '#Unit.MandateNo#'
	</cfquery>
	
	<cfparam name="CLIENT.Category" default="">

	<!--- claim owner --->
	<table width="100%" cellspacing="0" cellpadding="0"">
		
		<tr>
		   <td>
		   <table width="97%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
			   <tr>			  
				   <td height="20" width="60"><b><cf_tl id="Name">:</b></td>
				   <td>#User.FirstName# #User.LastName#</td>
				   <cfif user.PersonNo neq "">
				   <td width="100"><b><cf_tl id="Employee No">:</b></td>
				   <td>#User.PersonNo#</td>
				   <cfelse>
				   <td></td><td></td>
				   </cfif>
				   <td><b><cf_tl id="E-Mail">:</td>
				   <td>#User.EMailAddress#</td>
				   <td><b><cf_tl id="Organization">:</td>
				   <td>
				   
				   <cfif Unit.OrgUnitName eq "">Internal
				   <cfelseif Parent.OrgUnitName neq "">
				   #Parent.OrgUnitName#
				   <cfelse>			   
				   #Unit.OrgUnitName#</cfif>&nbsp;
				   </td>			  
			   </tr>
		   </table>
		   </td>
		</tr>
		
	</table>
	
	</cfoutput>
	
</td></tr>