<input type="hidden" name="action" id="action" value="1">

<table width="98%" height="100%" align="center">

<cfquery name="User" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
	    FROM UserNames
	    WHERE Account = '#URL.ID#'
</cfquery>

<cfif User.AccountType eq "Group">

	<tr>
	   <td height="20" align="center" class="labelit">User Groups may not be associated to another group (recurrent membership)</b></td>
	</tr>

<cfelse>
			
	<tr>
	<td height="100%" valign="top">		
		<cfdiv style="height:100%" bind="url:#SESSION.root#/System/Access/Membership/UserMemberList.cfm?id=#URL.id#" id="member"/>	
	</td>
	</tr>

</cfif>

</table>
	