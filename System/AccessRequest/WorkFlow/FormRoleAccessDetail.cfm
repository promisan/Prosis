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
<cf_compression>

<cfquery name="getDetails" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	
	SELECT   U.Created,
	         AU.Mission, 
	         AU.OrgUnit, 
			 AU.UserAccount, 
			 AU.ActionStatus,
			 AU.Role, 
			 R.Description, 
			 AU.GroupParameter, 
			 AU.ClassParameter, 
			 AU.AccessLevel, 
			 AU.Source
	FROM     UserAuthorizationActionLog AU INNER JOIN
             UserAuthorizationAction U ON AU.ProfileActionId = U.ProfileActionId INNER JOIN
             Ref_AuthorizationRole R ON AU.Role = R.Role
	WHERE    U.RequestId   = '#url.requestid#'
	AND      U.UserAccount = '#url.account#'
	
	ORDER BY AU.Mission, AU.Role, AU.ClassParameter, GroupParameter,  AU.Created
		
</cfquery>

<cfif getDetails.recordcount eq "0">

<cfelse>
				 
	<table width="98%" align="center" bgcolor="ffffef" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr><td height="4"></td></tr>
	
	<tr><td height="5" colspan="6" class="line"></td></tr>
	<tr><td height="5" class="labellarge" colspan="6" align="center">Access Granted</td></tr>
	<tr><td height="5" colspan="6" class="line"></td></tr>
		
	<cfoutput query="getDetails" group="Mission">

	    <cfif mission eq "">
		
		<tr class="labelmedium">	
			<td colspan="6" style="padding-left:5px"><b>Global</td>
		</tr>
		<cfelse>
		
		<tr class="labelmedium">	
			<td colspan="6" style="padding-left:5px"><b>#Mission#</td>
		</tr>
		
		</cfif>
	
		<cfoutput>
			
				<cfquery name="RoleScope" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM    Ref_AuthorizationRole 
						WHERE   Role = '#role#'
					</cfquery>	
					
				<cfif actionstatus eq "9">
				   <cfset decor = "color: B22222;text-decoration: line-through;">
				<cfelse>
				  <cfset  decor = "">
				</cfif>	
						
				<tr class="labelmedium">
				    <td style="#decor#;padding-left:10px">#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>
					<td style="#decor#;padding-left:10px">#Description#</td>	
					<td style="#decor#;padding-left:10px">#OrgUnit#</td>							
					<td style="#decor#;">#GroupParameter#</td>
					<td style="#decor#;">
					<cfif rolescope.Parameter eq "Entity">
					
						<cfquery name="Action" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM    Ref_EntityAction
							WHERE   ActionCode = '#ClassParameter#'
						</cfquery>	
						
						#Action.ActionDescription#
					
					<cfelse>
					
						#ClassParameter#
						
					</cfif>
					
					</td>
					<td style="#decor#;">							
					
					<cfset no = RoleScope.AccessLevels>
					<cfset label = ListToArray(RoleScope.AccessLevelLabelList)>											
					<cftry>#label[accesslevel+1]# <cfcatch>Level #accesslevel#</cfcatch></cftry>											
					
					</td>				
				</tr>
				
		</cfoutput>
		
		<tr><td height="4"></td></tr>
				
	</cfoutput>
		
	
	</table>

</cfif>