
<cfquery name="User" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   UserNames
	WHERE  Account = '#URL.ID#'
</cfquery>

<cfinvoke component = "Service.Authorization.PasswordCheck"  
		  method    = "generateRandomPassword"
	 returnvariable = "newPassword">	

<cfset Random = newPassword>

<cfquery name="Archive" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT  UserPasswordLog(
	Account,PasswordExpiration,Password,OfficerUserId,OfficerLastName,OfficerFirstName)
	VALUES
	('#URL.ID#', getDate(),'#user.Password#','#session.acc#','#session.last#','#session.first#')

</cfquery>

<cfquery name="setPassword" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  UserNames
	SET     Password           = '#random#',
	        PasswordResetForce = 1
	WHERE   Account = '#URL.ID#'
</cfquery>

<table width="100%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td height="10"></td></tr>

<tr><td colspan="2" height="20" class="labelmedium"><font color="gray">Password has been reset for the following user:</td></tr>

<tr><td height="5"></td></tr>
<tr class="labelit">
	<td width="100"><cfoutput>Account:</td>
	<td>#url.id#</cfoutput></b></td>
</tr>
<tr class="labelit">
	<td width="100"><cfoutput>Name:</td>
	<td>#User.FirstName# #User.LastName#</cfoutput></b></td>
</tr>
<tr class="labelit">
<TD><cf_tl id="Temporary Password">:</td>
<td><font color="0080FF"><b><cfoutput>#random#</cfoutput></b></font></TD>
</tr>
<tr><td height="5"></td></tr>
<tr><td colspan="2" class="line"></td></tr>
<tr><td height="5"></td></tr>
<tr>
<td colspan="2" class="labelmedium">
Request the user to logon with this temporary password. <br> <br>He/she will be forced to assign a new password
</td>
</tr>
<tr><td height="5"></td></tr>

<tr><td colspan="2" class="line"></td></tr>

</table>

