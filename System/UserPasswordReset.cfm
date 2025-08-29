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

<table width="100%" align="center" class="formpadding">
<tr><td height="10"></td></tr>

<tr><td colspan="2" height="20" class="labelmedium2"><font color="gray">Password has been reset for the following user:</td></tr>

<tr><td height="5"></td></tr>
<tr class="labelmedium2">
	<td style="width:200px"><cfoutput>Account:</td>
	<td>#url.id#</cfoutput></b></td>
</tr>
<tr class="labelmedium2">
	<td width="100"><cfoutput>Name:</td>
	<td>#User.FirstName# #User.LastName#</cfoutput></b></td>
</tr>
<tr class="labelmedium2">
<TD><cf_tl id="Temporary Password">:</td>
<td><font color="0080FF"><b><cfoutput>#random#</cfoutput></b></font></TD>
</tr>
<tr><td height="5"></td></tr>
<tr><td colspan="2" class="line"></td></tr>
<tr><td height="5"></td></tr>
<tr>
<td colspan="2" class="labelmedium2">
Request the user to logon with this temporary password. <br> <br>He/she will be forced to assign a new password
</td>
</tr>
<tr><td height="5"></td></tr>

<tr><td colspan="2" class="line"></td></tr>

</table>

<cf_MailUserAccountEnable
		account="#URL.ID#">