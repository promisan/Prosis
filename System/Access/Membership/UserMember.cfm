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
	<td height="100%" valign="top" style="padding-left:4px;padding-right:4px">		
		<cf_securediv style="height:100%" bind="url:#SESSION.root#/System/Access/Membership/RecordListingDetail.cfm?mod=#URL.id#&row=member" id="member">	
	</td>
	</tr>


<cfelse>
			
	<tr>
	<td height="100%" valign="top">		
		<cf_securediv style="height:100%" bind="url:#SESSION.root#/System/Access/Membership/UserMemberList.cfm?id=#URL.id#" id="member">	
	</td>
	</tr>

</cfif>

</table>
	