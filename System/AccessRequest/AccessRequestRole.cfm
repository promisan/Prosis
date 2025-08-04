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
<cfparam name="url.requestid" default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.mode"      default="new">


<cfquery name="SystemRole" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  R.*, RA.Role as AccessRole
		FROM    Ref_AuthorizationRole R
		<cfif url.mode eq "view">
			INNER  JOIN     System.dbo.UserRequestAccess RA
		<cfelse>
	        LEFT OUTER JOIN System.dbo.UserRequestAccess RA
		</cfif>
		ON	    R.Role = RA.Role  AND RA.RequestId = '#url.requestid#'
		WHERE   SystemModule IN (
					SELECT SystemModule
					FROM   System.dbo.Ref_ApplicationModule
					WHERE  Code = '#url.application#'
				)
		ORDER By SystemModule, Listingorder
</cfquery>


<input type="hidden" name="SystemRole" id="SystemRole" value=""> <!--- So the field exists even if no role is selected --->

<cfif SystemRole.recordcount gt 0>

<table width="100%" cellspacing="0" cellpadding="0">
	<cfset cnt = "0">
	
	<cfoutput query="SystemRole" group="SystemModule">
	
		<cfquery name="RoleRequested" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					SELECT SystemModule FROM Ref_AuthorizationRole
					WHERE  Role IN( SELECT Role 
					                FROM   System.dbo.UserRequestAccess RA 
									WHERE  RequestId = '#url.requestid#' )
					AND    SystemModule = '#SystemModule#'
					
		</cfquery>
		
		<tr height="25px" onclick="toggleSystemModule('#SystemModule#')" style="cursor:pointer">
			<td style="padding-left:10px"  width="10px">
				<cfif RoleRequested.recordcount gt 0>
					<img src="#SESSION.root#/images/arrowdown.gif" id="#SystemModule#_icon">
					<cfset cl = "regular">
				<cfelse>
					<img src="#SESSION.root#/images/arrowright.gif" id="#SystemModule#_icon">
					<cfset cl = "hide">
				</cfif>
			</td>
			<td colspan="3" style="padding-left:5px" align="left" width="99%" class="labelmedium">
				#SystemModule#
			</td>
		</tr>
		
		<cfset cnt = 0>
		<tr id="#SystemModule#_role" class="#cl#">
			<td colspan="4" width="100%">
			
				<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
				    <cfoutput>
						<cfset cnt = cnt+1>
						<tr class="labelit linedotted" bgcolor="<cfif cnt mod 2 is '0'>f3f3f3</cfif>">		
							 <td style="padding-left:20px" width="15px"> 
							 	<cfif url.mode neq "view">
									<input type="checkbox" class="radiol"
										   name="SystemRole" 
										   id="SystemRole" 
										   value="#Role#" 
										   onclick="updateAccountDetails();"
										   <cfif AccessRole neq "">checked="checked" </cfif>>
								</cfif>
							 </td>
							 <td width="25%" style="padding-left:4px" class="labelit">#Description#</td>
							 <td width="65%" class="labelit">#RoleMemo#</td>
							 <!--- <td class="labelit">#Role#</td> --->
						</tr>						
				    </cfoutput>
				   </table>
				   
			 </td>
		</tr>
		<tr><td colspan="4" class="linedotted"></td></tr>
		
	</cfoutput>
</table>

<cfelse>

	<table width="100%">
		<tr>
			<td align="center" height="30px" class="labelit">
			    <cfoutput>
				No roles were defined for application: <font size="3" face="calibri">#URL.application#</font>
				</cfoutput>
			</td>
		</tr>
	</table>

</cfif>