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
<cfset portalList="">

<cfloop index="i" list="#Form.Portal#" delimiters=",">
	<cfif portalList eq "">
		<cfset portalList = "'#i#'">
	<cfelse>
		<cfset portalList = "#portalList#,'#i#'">
	</cfif>
</cfloop>

<cfquery name="PortalAccess" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
	
		SELECT *
		FROM   UserModule P
		INNER  JOIN #client.lanPrefix#Ref_ModuleControl M
			   ON P.SystemFunctionId = M.SystemFunctionId
		WHERE  P.Account = '#url.acc#'
		<cfif portalList neq "">
			AND    P.SystemFunctionId IN (#PreserveSingleQuotes(portalList)#)
			AND	   P.Status = '1'
		<cfelse>
			AND  1=0
		</cfif>
		ORDER  BY M.MenuOrder
				
</cfquery>

<!--- Group access --->
<cfset groupList="">

<cfloop index="i" list="#Form.AccountGroup#" delimiters=",">
	<cfif groupList eq "">
		<cfset groupList = "'#i#'">
	<cfelse>
		<cfset groupList = "#groupList#,'#i#'">
	</cfif>
</cfloop>

<cfquery name="GroupAccess" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
	
		SELECT U.LastName
		FROM   UserNamesGroup UNG
		INNER  JOIN   UserNames U
			   ON     UNG.AccountGroup = U.Account
		WHERE  UNG.Account = '#url.acc#'
		<cfif groupList neq "">
		AND    UNG.AccountGroup IN (#PreserveSingleQuotes(groupList)#)
		<cfelse>
		AND    1=0
		</cfif>
			
</cfquery>


<!--- Role access --->
<cfset roleList="">

<cfloop index="i" list="#Form.SystemRole#" delimiters=",">
	<cfif roleList eq "">
		<cfset roleList = "'#i#'">
	<cfelse>
		<cfset roleList = "#roleList#,'#i#'">
	</cfif>
</cfloop>

<cfquery name="RoleAccess" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
	
		SELECT DISTINCT R.*
		FROM   Ref_AuthorizationRole R
		INNER  JOIN Organization.dbo.OrganizationAuthorization OA
		       ON R.Role = OA.Role AND OA.UserAccount = '#url.acc#'
		<cfif roleList neq "">
		WHERE  R.Role IN (#PreserveSinglequotes(roleList)#)
		<cfelse>
		WHERE 1=0
		</cfif>
			
				
</cfquery>

<cfif  PortalAccess.recordcount gt 0 or GroupAccess.recordcount gt 0 or RoleAccess.recordcount gt 0>

<table>
	<tr valign="top">
		<td><img src="<cfoutput>#SESSION.root#</cfoutput>/images/join.gif"></td>
		<td style="padding-left:5px;">

		<table width="100%">
		
			<cfif PortalAccess.recordcount gt 0>
			<tr bgcolor="pink">
				<td class="labelit"> User already has access to portals:	</td>
				<td style="padding-left:8px;">
					<cfoutput query="PortalAccess">	
						<cfif FunctionMemo neq ""> #FunctionMemo#, <cfelse> #FunctionName#, </cfif>
					</cfoutput>
				</td>
				
            </tr>
			</cfif>
			
			<cfif GroupAccess.recordcount gt 0>
			<tr bgcolor="pink">
				<td class="labelit"> User already has access to groups: </td>
				<td style="padding-left:8px;"> 	<cfoutput query="GroupAccess">	 #LastName#, </cfoutput> </td>
			</tr>		
			</cfif>

			<cfif RoleAccess.recordcount gt 0>			
			<tr bgcolor="pink">
				<td class="labelit"> User already has access to roles:</td>
				<td style="padding-left:8px;"> <cfoutput query="RoleAccess">	#Mission# - #Description# </cfoutput> </td>
			</tr>
			</cfif>
			
		</table>

		</td>
	</tr>
</table>

<cfelse>

<cf_compression>

</cfif>