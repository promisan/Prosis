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
<cfparam name="url.account"     default="">
<cfparam name="url.profileid"   default="">

<cfquery name="Function" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   Account, 
	         LastName, 			 
			 Remarks,
			 (SELECT count(*) 
			  FROM   System.dbo.UserNamesGroup 
			  WHERE  Account = '#url.account#'
			  AND    AccountGroup = S.Account) as Member
    FROM     MissionProfileGroup M INNER JOIN System.dbo.UserNames S ON M.AccountGroup = S.Account
	WHERE    M.ProfileId = '#url.ProfileId#'	 	
	AND      S.Disabled = 0
	ORDER BY M.ListingOrder	
</cfquery>

<cfset cnt = 0>
<table style="width:100%">
<cfoutput query="Function">
	<cfset cnt = cnt + 1>
    <cfif cnt eq "1">
	<tr class="labelmedium2 linedotted">
	</cfif>
	 <td style="padding-left:20px;padding-right:20px">
	     <input type="checkbox" class="radiol" name="AccountGroup" <cfif Member gte "1">checked</cfif> value="#UserAccount#"></td> 
	 <td style="width:97%">#LastName# : #Remarks#</td>
	 
	 <cfif cnt eq "1">
	 <cfset cnt = 0>
	</tr>
	</cfif>
</cfoutput>
</table>
