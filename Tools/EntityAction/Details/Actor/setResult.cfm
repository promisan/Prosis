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


<cfquery name="Actor" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	SELECT      UserAccount, AccessLevel, FirstName, LastName
	FROM        OrganizationObjectActionAccess A INNER JOIN System.dbo.UserNames U ON A.UserAccount = U.Account
	WHERE       ObjectId   = '#url.ObjectId#' 
	AND         ActionCode = '#url.ActionCode#'
</cfquery>

<cfset totalyes = 0>
<cfset totalno = 0>

<cfloop query="Actor">

			<cfquery name="Process" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#"> 
				SELECT     TOP 1 *
				FROM       OrganizationObjectActionAccessProcess
				WHERE      ObjectId     = '#ObjectId#' 
				AND        ActionCode   = '#ActionCode#'
				AND        UserAccount  = '#useraccount#'
				ORDER BY   Created DESC
			</cfquery>	
			
			<cfif Process.Decision eq "3">
			
				<CFSET totalyes = totalyes + 1>
				
			<cfelseif Process.Decision eq "9">
			
				<CFSET totalno = totalno + 1>
			
			</cfif>

</cfloop>

<cfoutput>
<table>
   <tr>
  
   <td class="labelmedium2" style="font-size:35px">#totalYes#</td>
    <td class="labelmedium2" style="padding-top:12px;font-size:20px">:<cf_tl id="Endorsed"></td>
	<td class="labelmedium2" style="padding-left:20px;font-size:35px;color:red">#totalNo#</td>
    <td class="labelmedium2" style="padding-top:12px;font-size:20px">:<cf_tl id="Not endorsed"></td>
   </tr>
</table>
</cfoutput>