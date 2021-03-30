<!--- Create Criteria string for query from data entered thru search form --->

<cfparam name="URL.Mode" default="Full">

<cfquery name="SearchResult"
		datasource="AppsSystem"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
	SELECT     Usr.*,
	(SELECT count(*) FROM Organization.dbo.OrganizationAuthorizationDeny
	WHERE UserAccount = Usr.Account
	AND   Source  = '#URL.Mod#') as Denials,
(SELECT LastConnection FROM skUserLastLogon WHERE account = Usr.Account) as LastConnection,
Grp.Created as Joined
FROM       UserNamesGroup Grp,
UserNames Usr
WHERE      Grp.Account = Usr.Account
AND        Grp.AccountGroup = '#URL.Mod#'
ORDER BY   Usr.LastName, Usr.FirstName
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
	WHERE      M.SystemFunctionId IN (SELECT SystemFunctionId
	FROM   Ref_ModuleControlUserGroup
	WHERE  Account = '#URL.Mod#')
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

			<table cellspacing="0" cellpadding="0">
			<tr>
			<td height="22" class="labelmedium" style="padding-left:4px">

			<cfset link = "UserMemberSubmit.cfm?id=group||id1=#url.mod#||id2=#url.row#">

				<cf_selectlookup
				box          = "s#url.row#"
				title        = "<font color='0080C0'>Add User</font>"
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
		<td style="padding-left:5px;padding-right:5px" class="labelmedium" title="Send a broadcast mail to the members of this group">
				<a href="javascript:broadcast('#url.mod#')"><cf_tl id="Mail Broadcast"></a>

		</td>

			<cfoutput>

					<td style="padding-left:5px;padding-right:5px">|</td>
				<td align="right" style="padding-left:5px;padding-right:5px" title="Re-synchronize role authorization of members with user group role profile">
						<img src="#SESSION.root#/Images/sweeper3_sm.gif" id="sync#URL.Mod#" alt="" border="0" align="absmiddle">
			</td>
			<td align="left" style="width:40" class="labelmedium"><a href="javascript:sync('#URL.Mod#','#url.row#')"><cf_tl id="Synchronize"></a></td>

			</cfoutput>

				</td>
					<td style="width:200;padding-left:10px" class="labelmedium" width="1" id="a#URL.Mod#"></td>
		</tr>

		</table>
		</td>
		</tr>
		</table>
		</td>
		</tr>

	</cfif>

		<tr>
				<td id="#URL.Mod#Member" class="regular" style="border-top:1px solid silver">

	<table width="100%" class="navigation_table" align="center">

		<cfif searchresult.recordcount eq "0">
				<tr class="labelmedium"><td align="center" height="40"><font color="FF0000">Attention:</font> There are no members defined for this group.</font></td></tr>
		<cfelse>

			<tr class="labelmedium line" style="height:29px">
				<td align="center" width="17">&nbsp;</td>
				<TD width="30%"><cf_tl id="Member"></TD>
				<TD width="10%"><cf_tl id="UserId"></TD>
				<TD width="10%"><cf_tl id="AccountNo"></TD>
				<TD width="22%"><cf_tl id="LDAP"></TD>
				<TD width="19%"><cf_tl id="eMail"></TD>
				<TD width="80"><cf_tl id="Last logon"></TD>
				<TD width="3%" align="center" style="padding-left:4px;padding-right:4px"><cf_tl id="Denials"></TD>
				<TD width="3%" style="padding-left:4px;padding-right:4px" align="center"><cf_tl id="Active"></TD>
				<TD width="1%" align="center"></TD>
			</TR>

		</cfif>

		<cfloop query="SearchResult">

			<cfif Disabled eq "1">
				<tr bgcolor="FBE0D9" class="navigation_row line labelmedium" style="height:20px">
			<cfelse>
				<tr bgcolor="white" class="navigation_row line labelmedium" style="height:20px">
			</cfif>
			<TD align="center" width="4%">#currentRow#.</TD>

		<TD><a href="javascript:ShowUser('#URLEncodedFormat(Account)#')"><cfset vJoined = Dateformat(Joined, "#CLIENT.DateFormatShow#")>
			<cf_UItooltip tooltip="Created: #vJoined#">#LastName#, #FirstName#</cf_UItooltip></a></TD>
		<td>#Account#</td>
		<td>#AccountNo#</td>
		<td><cfif MailServerDomain neq "">#MailServerDomain#\</cfif>#lcase(MailServerAccount)#</td>
		<TD><a href="javascript:email('#emailaddress#')">#left(eMailAddress,20)#</a></TD>
		<TD>
			<cfif LastConnection eq ""><font color="FF0000">Never</font><cfelse>#Dateformat(LastConnection, "#CLIENT.DateFormatShow#")#</cfif>
			</TD>
			<TD align="center" style="padding-left:4px;padding-right:4px">
			<cfif Denials gte "1"><font color="FF0000">Yes<cfelse>--</font></cfif>
			</TD>
			<TD align="center" style="padding-left:4px;padding-right:4px">
			<cfif Disabled eq "1"><font color="FF0000">No</font><cfelse></cfif>
			</TD>
			<TD align="center">
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

	<cfif url.mode eq "Full">

		<tr><td><cf_tableToggle size="100%" line="0" border="0" color="ffffff" mode="regular" header="Roles and Functions assigned to group" id="#URL.Mod#Roles" class="regular"></td></tr>
	
		<tr><td bgcolor="EAFBFD" class="hide" id="#URL.Mod#Roles" style="border-top:1px solid silver">
	
		<table width="100%">
	
		<tr>
		<td colspan="9" align="left">
	
		<table width="100%">
	
		<tr class="labelmedium line" bgcolor="E9E9E9">
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

			<tr class="line labelmedium">
			<td width="3%" align="center">#CurrentRow#.</td>
			<td align="center" style="padding-top:2px" onClick="<cfif #OrgUnitLevel# eq 'Global'>showroleG('#Role#')<cfelse>showrole('#Role#','#Mission#')</cfif>">
				<cf_img icon="open">
			</td>
			<td width="15%">#SystemModule#</td>
			<td width="25%">#Description#</td>
			<td width="15%">#Role#</td>
			<td width="10%" style="padding-left:3px">#AccessLevel#</td>
			<td width="10%">#Parameter#</td>
			<td style="padding-right:10px">#Mission#</td>
			</tr>

		</cfloop>

<!--- direct functions --->

		<cfif Function.recordcount gt "0">

				<tr class="line labelmedium" bgcolor="E9E9E9">
					<td></td>
					<td></td>
					<td colspan="2">Function name</td>
					<td colspan="4">Memo</td>
				</tr>

			<cfloop query="Function">

				<tr class="line labelmedium">
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

