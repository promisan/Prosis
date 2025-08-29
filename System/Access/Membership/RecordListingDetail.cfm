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
<cfparam name="URL.Mode" default="Full">

<cfquery name="SearchResult"
		datasource="AppsSystem"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT     Usr.*,
				   
				   (SELECT count(*) 
				    FROM Organization.dbo.OrganizationAuthorizationDeny
					WHERE UserAccount = Usr.Account
					AND   Source  = '#URL.Mod#') as Denials,
			       
				   (SELECT LastConnection 
				    FROM skUserLastLogon 
					WHERE account = Usr.Account) as LastConnection,
				   
				   Grp.Created as Joined
				   
		FROM       UserNamesGroup Grp,UserNames Usr
		WHERE      Grp.Account = Usr.Account
		AND        Grp.AccountGroup = '#URL.Mod#'
		ORDER BY   Usr.LastName, Usr.FirstName
</cfquery>

<cfquery name="ProfileAssigned"
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT     *
		FROM       MissionProfile B INNER JOIN MissionProfileGroup A ON B.ProfileId = A.ProfileId
		WHERE      A.AccountGroup  = '#URL.Mod#'		
</cfquery>

<cfquery name="RoleAssigned"
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT     DISTINCT A.Mission, R.*, A.AccessLevel
		FROM       OrganizationAuthorization A,
				   Ref_AuthorizationRole R,
        		   System.dbo.Ref_SystemModule S
		WHERE      A.UserAccount  = '#URL.Mod#'
		AND        A.Role         = R.Role
		AND        R.SystemModule = S.SystemModule
		AND        S.Operational  = 1
		AND        R.OrgUnitLevel != 'Fly'
		ORDER BY   R.SystemModule, R.Role, A.Mission
</cfquery>

<cfquery name="Function"
	datasource="AppsSystem"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT     *
		FROM       Ref_ModuleControl M
		WHERE      M.SystemFunctionId IN (SELECT SystemFunctionId FROM Ref_ModuleControlUserGroup WHERE Account = '#URL.Mod#')
		AND        M.Operational = 1
		ORDER BY   M.SystemModule
</cfquery>

<cfoutput>

	<table width="100%" align="center">

		<tr><td height="1" bgcolor="white" colspan="9"></td></tr>

		<cfif URL.Mode eq "Full">
	
				<tr>
				<td colspan="9">
	
				<table width="100%" style="padding:3px;">
				<tr><td>
	
				<table>
				<tr>
				<td height="22" class="labelmedium2" style="padding-left:4px">
	
				<cfset link = "UserMemberSubmit.cfm?id=group||id1=#url.mod#||id2=#url.row#">
	
					<cf_selectlookup
					box          = "s#url.row#"
					title        = "Add User to group"
					link         = "#link#"
					button       = "No"
					iconheight   = "25"
					icon         = "finger.gif"
					close        = "No"
					class        = "user"
					des1         = "acc">
	
				</td>
	
				<td style="padding-left:5px;padding-right:5px">|</td>
				<td style="padding-left:5px;padding-right:5px"><img src="#SESSION.root#/Images/mail.gif" alt="" border="0" align="absmiddle"></td>
				<td style="padding-left:5px;padding-right:5px" class="labelmedium2" title="Send a broadcast mail to the members of this group">
					<a href="javascript:broadcast('#url.mod#')"><cf_tl id="Mail Broadcast"></a>
				</td>
	
			<cfoutput>
	
					<td style="padding-left:5px;padding-right:5px">|</td>
					<td align="right" style="padding-left:5px;padding-right:5px" title="Re-synchronize role authorization of members with user group role profile">
						<img src="#SESSION.root#/Images/sweeper3_sm.gif" id="sync#URL.Mod#" alt="" border="0" align="absmiddle">
					</td>
					<td align="left" class="labelmedium2" title="Re-synchronize role authorization of members with user group role profile">
					<a href="javascript:syncgroup('#URL.Mod#','#url.row#')"><cf_tl id="Synchronize"></a>
					</td>
	
			</cfoutput>
					
					<td style="width:200;padding-left:10px" class="labelmedium2" width="1" id="a#URL.Mod#"></td>
			</tr>
	
			</table>
			</td>
			</tr>
			</table>
			</td>
			</tr>
	
		</cfif>
		
		<cfif profileassigned.recordcount gte "1" and url.row neq "member">
				
			<tr>
			<td id="#URL.Mod#Profile" class="regular">
	
				<table width="100%" class="navigation_table" align="center">
										
						<tr class="labelmedium2 line fixlengthlist" style="height:29px">		
	   	    				<td width="17">&nbsp;</td>				
							<TD><cf_tl id="Entity"></TD>
							<TD width="80%"><cf_tl id="Profile name"></TD>
							<TD width="10%"><cf_tl id="Created"></TD>						
						</TR>
					
					<cfloop query="profileassigned">
			
						<tr bgcolor="white" class="navigation_row line labelmedium2 fixlengthlist" style="height:20px">
						<TD style="min-width:30px;padding-left:3px">#currentRow#.</TD>								
						<td>#Mission#</td>
						<td>#FunctionName#</td>
						<td>#dateformat(created,client.dateformatshow)#</td>
						</TR>
					
					</cfloop>
			
				</table>
	
			</td></tr>		
			
			<tr><td></td></tr>		
				
		</cfif>
		
		<tr>
		<td id="#URL.Mod#Member" class="regular">

			<table width="100%" class="navigation_table" align="center">
			
				<cfif searchresult.recordcount eq "0">
						<tr class="labelmedium"><td align="center" height="40"><font color="FF0000">Attention:</font> There are no members defined for this group.</font></td></tr>
				<cfelse>
		
					<tr class="labelmedium2 line fixlengthlist" style="height:29px">
						<td>&nbsp;</td>
						<TD><cf_tl id="Member"></TD>
						<TD><cf_tl id="UserId"></TD>
						<TD><cf_tl id="AccountNo"></TD>
						<TD><cf_tl id="LDAP"></TD>
						<TD><cf_tl id="eMail"></TD>
						<TD><cf_tl id="Last logon"></TD>
						<TD align="center" style="padding-left:4px;padding-right:4px"><cf_tl id="Denials"></TD>
						<TD align="center"><cf_tl id="Active"></TD>
						<TD align="center"></TD>
					</TR>
		
				</cfif>
		
				<cfloop query="SearchResult">
		
					<cfif Disabled eq "1">
						<tr bgcolor="FBE0D9" class="navigation_row line labelmedium2 fixlengthlist" style="height:20px">
					<cfelse>
						<tr bgcolor="white" class="navigation_row line labelmedium2 fixlengthlist" style="height:20px">
					</cfif>
					<TD style="min-width:30px;padding-left:3px">#currentRow#.</TD>
			
					<TD><a href="javascript:ShowUser('#URLEncodedFormat(Account)#')"><cfset vJoined = Dateformat(Joined, "#CLIENT.DateFormatShow#")>
						<cf_UItooltip tooltip="Created: #vJoined#">#LastName#, #FirstName#</cf_UItooltip></a></TD>
					<td>#Account#</td>
					<td>#AccountNo#</td>
					<td><cfif MailServerDomain neq "">#MailServerDomain#\</cfif>#lcase(MailServerAccount)#</td>
					<TD title="#eMailAddress#"><a href="javascript:email('#emailaddress#')">#eMailAddress#</a></TD>
					<TD>
					<cfif LastConnection eq ""><font color="FF0000">Never</font><cfelse>#Dateformat(LastConnection, "#CLIENT.DateFormatShow#")#</cfif>
					</TD>
					<TD align="center" style="padding-left:4px;padding-right:4px">
					<cfif Denials gte "1"><font title="Has one or more corrections on the granted access through a usergroup" color="FF0000">Yes<cfelse>--</font></cfif>
					</TD>
					<TD align="center" style="padding-left:4px;padding-right:4px">
					<cfif Disabled eq "1"><font color="FF0000">No</font><cfelse></cfif>
					</TD>
					<TD align="center" style="padding-top:2px;padding-right:30px">
					<cfif URL.Mode eq "Full">
						 <cf_img icon="delete" onclick="purgemember('#URL.Mod#','#account#','#url.row#')">
					</cfif>
					</TD>
					</TR>
		
					<cfif accounttype eq "group">
							<tr><td colspan="9" bgcolor="FFCCCC" align="center">You may not assign a usergroup to another usergroup. Please remove above membership!</td></tr>
					</cfif>
		
				</CFloop>
		
			</table>

		</td></tr>

	<cfif url.mode eq "Full" and url.row neq "member">

		<tr><td><cf_tableToggle size="100%" line="0" border="0" color="ffffff" mode="regular" header="Roles and Functions assigned to group" id="#URL.Mod#Roles" class="regular"></td></tr>
	
		<tr><td bgcolor="EAFBFD" class="hide" id="#URL.Mod#Roles" style="border-top:1px solid silver">
	
		<table width="100%">
	
		<tr>
		<td colspan="9" align="left">
	
			<table width="100%">
		
			<tr class="labelmedium2 line fixlengthlist" bgcolor="E9E9E9">
				<td width="3%" align="left"></td>
				<td width="5%" align="left"></td>
				<td><cf_tl id="Module"></td>
				<td><cf_tl id="Role"></td>
				<td><cf_tl id="Code"></td>
				<td><cf_tl id="Level"></td>
				<td><cf_tl id="Context"></td>
				<td style="padding-right:5px"><cf_tl id="Mission"></td>
			</tr>
	
			<cfif RoleAssigned.recordcount eq "0">
					<tr>
						<td colspan="8" align="center" class="labelit"><b>Attention:</b> There are no roles assigned to this group</b></td>
					</tr>
			</cfif>
	
			<cfloop query="RoleAssigned">
			
				<cf_assignid>
	
				<tr class="line labelmedium2 fixlengthlist">
					<td>#CurrentRow#.</td>
					<td align="center" style="padding-top:2px" onClick="<cfif #OrgUnitLevel# eq 'Global'>showroleG('#Role#')<cfelse>showrole('#Role#','#Mission#')</cfif>">
						<cf_img icon="open">
					</td>
					<td>#SystemModule#</td>
					<td>#Description#</td>
					<td>#Role#</td>
					<td style="padding-left:3px">#AccessLevel#</td>
					<td>#Parameter#</td>
					<td style="padding-right:10px"><a href="javascript:ProsisUI.createWindow('useraccess', 'Access', '',{x:100,y:100,height:document.body.clientHeight-120,width:document.body.clientWidth-120,modal:true,center:true});ptoken.navigate('#session.root#/system/access/MemberShip/getDetailAccess.cfm?useraccount=#url.mod#&mission=#mission#&role=#role#&access=#accesslevel#','useraccess')">#Mission#</a></td>
				</tr>
					
			</cfloop>
	
			<!--- direct functions --->
	
			<cfif Function.recordcount gt "0">
	
					<tr class="line labelmedium2" bgcolor="E9E9E9">
						<td></td>
						<td></td>
						<td colspan="2">Function name</td>
						<td colspan="4">Memo</td>
					</tr>
	
				<cfloop query="Function">
	
					<tr class="line labelmedium2">
						<td align="center">#CurrentRow#.</td>
						<td align="center">
						<cf_img icon="edit" onClick="supportconfig('#systemfunctionid#')">
						</td>
						<td colspan="2">#FunctionName#</td>
						<td colspan="4">#FunctionMemo#</td>
					</tr>
	
				</cfloop>
	
			</cfif>
	
			</table>
		</td>
		</tr>

		</table>

	</cfif>

		<tr><td height="3"></td></tr>

	</table>

</cfoutput>

<cfset ajaxonload("doHighlight")>

