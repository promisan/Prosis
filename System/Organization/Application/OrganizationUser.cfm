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

	<table height="100%" width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
					
		<cfset link = "#SESSION.root#/system/organization/application/OrganizationUserList.cfm?orgunit=#Organization.Orgunit#">
				
		<tr><td valign="top" align="left" style="padding-top:3px;padding-right:20px;border-right:1px solid silver" class="labelmedium">
		
		   <cf_selectlookup
			    class    = "User"
			    box      = "user"
				title    = "Add"
				link     = "#link#"						
				dbtable  = "System.dbo.UserMission"
				des1     = "Account">
					
		</td>
						
	    <td height="100%" valign="top" width="100%" style="padding-left:4px">		
			<cf_securediv bind="url:#link#" id="user">		
		</td>
		
		</tr>  		
	
    </table>
      
</cfoutput>