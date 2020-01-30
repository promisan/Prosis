
<!---
     show roles, 
     allow to open dialog screen
	 pass the requestid
	 refresh the action for review of granted access
	 allow to undo
--->


<cfquery name="getNames" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   WH.*
	FROM     UserRequestNames R INNER JOIN
             UserNames WH ON R.Account = WH.Account
	WHERE    R.RequestId = '#object.ObjectKeyValue4#'
</cfquery>

<cfquery name="getRoles" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   WH.Description, 
	         WH.Role, 
			 R.Mission, 
			 R.OrgUnit
	FROM     UserRequestAccess R INNER JOIN
             Organization.dbo.Ref_AuthorizationRole WH ON R.Role = WH.Role
	WHERE    R.RequestId = '#object.ObjectKeyValue4#'
</cfquery>
			 
<table width="98%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td height="4"></td></tr>

<cfif getRoles.recordcount eq "0">

    <tr>
	<td colspan="4" align="center" height="170"><font size="3">No Manual Role access to be applied for this request. Press <u>Continue</font></td>		
	</tr>
	
<cfelse>	
	
	<cfoutput query="getNames">
	
		<tr class="labelmedium linedotted">
			<td colspan="4">#FirstName# #LastName#</font></td>		
		</tr>
				
		<cfloop query="getRoles">
		
			<tr class="labelmedium">
				<td style="padding-left:10px">#Description#</td>
				<td>#Mission#, <cfif orgunit eq 0>All Units</cfif></td>
				<td></td>
				<td align="right" style="padding-right:10px">
				<a href="javascript:applyaccess('#object.ObjectKeyValue4#','#Mission#','#orgunit#','#role#','#getNames.account#')">
					<font color="0080C0"><cf_tl id="Grant access"></font>
				</a>
				</td>
			</tr>
			
		</cfloop>
		
		<tr><td colspan="5" style="padding-left:10px">
			<cfdiv bind="url:#SESSION.root#/System/AccessRequest/Workflow/FormRoleAccessDetail.cfm?account=#getNames.account#&requestid=#object.ObjectKeyValue4#"
			id="box#account#">
		</td></tr>
		<tr><td height="5"></td></tr>
	
	</cfoutput>

</cfif>

</table>