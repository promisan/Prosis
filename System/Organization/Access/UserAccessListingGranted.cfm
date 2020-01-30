			
<cfquery name="Granted" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT OfficerUserId, 
	                OfficerLastName, 
					OfficerFirstName, 
					Last, Entries
	FROM            skUserGrant
	WHERE           UserAccount = '#URL.ID#'			
</cfquery>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">
<tr><td height="20" colspan="4" class="labelmedium"><b>Access granted to this user by the following administrators:</b></td></tr>		
<tr class="labelit linedotted">
   <td class="labelheader">Account</td>
   <td class="labelheader">Name</td>
   <td class="labelheader">Last Entry</td>
   <td class="labelheader">No of Entries</td>
   <td></td>
</tr>

<cfoutput query="Granted">
<tr class="labelmedium linedotted navigation_row">
   <td>#OfficerUserId#</td>
   <td>#OfficerFirstName# #OfficerLastName#</td>
   <td>#dateformat(last,CLIENT.DateFormatShow)#</td>
   <td>#entries#</td>
   <td><a href="javascript:purge('#officerUserid#')"><font color="red">Revoke access</a></td>
</tr>	

</cfoutput>	
</table>
	
	