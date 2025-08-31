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
<cfquery name="getNames" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     UserRequest UR
			 INNER JOIN UserRequestNewAccount NA
             ON UR.RequestId = NA.RequestId
	WHERE    UR.RequestId = '#object.ObjectKeyValue4#'
</cfquery>
	 
<div id="div_submit">
	 
<table width="900px" align="left" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td height="15" colspan="3"></td></tr>

<cfquery name="getNamesRequested" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   U.*
	FROM     UserNames U
			 INNER JOIN UserRequestNames URN
             ON URN.Account = U.Account
	WHERE    URN.RequestId = '#object.ObjectKeyValue4#'
</cfquery>

<cfif getNamesRequested.recordCount gt 0>
	<tr><td colspan="3" class="labelmedium"><cf_tl id="Existing accounts">:</td></tr>
	<tr><td height="5"></td></tr>
</cfif>

<cfoutput query="getNamesRequested">
	<tr>
		<td colspan="3">
			<a style="color:##0D9FEE;" href="javascript:ptoken.open('#session.root#/System/Access/User/UserDetail.cfm?ID=#account#');">#LastName#, #FirstName# (#Account#)</a>				
		</td>
	</tr>
</cfoutput>

<cfform name="newAccount">

	<cfoutput query="getNames">
	
	<tr>
		<td  colspan="3">
			<font size="2">
			<cf_tl id="New account for">: <b>#LastName#, #FirstName#</b>
			</font>
		</td>
	</tr>
	
	<tr><td class="linedotted"  colspan="3"></td></tr>
	
	<tr>
		<td height="20" style="padding-left:20px;"><cf_tl id="IndexNo">:</td>
		<td colspan="2">
			<table cellspacing="0" cellpadding="0">
		    <tr>
			
				<td>
					<cfinput class="regular" type="text" name="indexno" id="indexno" value="#IndexNo#" size="10" maxlength="20" readonly>
					<input type="hidden" name="personno" id="personno">
				</td>
				<td>
				
					<button name="Search" id="Search" type="button" class="button10s" style="height:18"
					 onClick="selectperson('webdialog','personno','indexno','lastName','firstName')">		
					 <cfoutput><img align="absmiddle" src="#SESSION.root#/Images/locate.gif" height="12" width="13" border="0"></cfoutput>
	 			    </button>
					
				 </td>
			 
			 </tr>
			 </table>
		</td>
	</tr>
	
	<tr>
		<td height="20" width="100px" style="padding-left:20px;"><cf_tl id="Account">:</td>
		<td width="100px"> 
			 <cfinput 
			 	class="regular" 
			 	type="text" 
		 	 	onkeyup="ColdFusion.navigate('#SESSION.root#/System/AccessRequest/Workflow/ValidateAccount.cfm?acc='+this.value,'accValidation')"
				value=""
		 	 	name="account" 
		 	 	id="account"
				message="Please enter account"
				required="yes">
	    </td>
		<td id="accValidation"> </td>
	</tr>
	
	<tr>
		<td height="20" style="padding-left:20px;"><cf_tl id="LastName">:</td>
		<td colspan="2">
		 <cfinput 
			 	class="regular" 
			 	type="text" 
				value="#LastName#"
		 	 	name="lastName" 
		 	 	id="lastName"
				message="Please enter last name"
				required="yes">
		</td>
	</tr>
	
	<tr>
		<td height="20" style="padding-left:20px;"><cf_tl id="FirstName">:</td>
		<td colspan="2">
			 <cfinput 
			 	class="regular" 
			 	type="text" 
				value="#FirstName#"
		 	 	name="firstName" 
		 	 	id="firstName"
				message="Please enter first name"
				required="yes">
		</td>
	</tr>
	
	<tr>
		<td height="20" style="padding-left:20px;"><cf_tl id="Gender">:</td>
		<td colspan="2">#Gender#</td>
	</tr>
	
	<tr>
		<td height="20" style="padding-left:20px;"><cf_tl id="Telephone">:</td>
		<td colspan="2">#Telephone#</td>
	</tr>
	
	<tr>
		<td height="20" style="padding-left:20px;"><cf_tl id="Email Address">:</td>
		<td colspan="2">#eMailAddress#</td>
	</tr>

	<tr>
		<td height="20" style="padding-left:20px;"><cf_tl id="Ldap Account">:</td>
		<td colspan="2">#MailServerAccount#</td>
	</tr>
	
	
	<tr>
		<td height="20" style="padding-left:20px;"><cf_tl id="Organization">:</td>
		<td colspan="2">#AccountMission#</td>
	</tr>
	
	
	</cfoutput>
	
	<tr><td colspan="3" height="4"></td></tr>
	<tr><td colspan="3" class="linedotted"></td></tr>
	<tr><td colspan="3" height="4"></td></tr>
	
	<cfif getNames.recordcount gt 0>
	<tr>
	<td colspan="3" align="center">
		<cf_tl id="Create" var="1">
		<cfoutput>
			<input class="button10g" type="button" name="Create" id="Create" value=" #lt_text# " onclick="createAccount()">
		</cfoutput>
	</td>
	</tr>
	</cfif>

</cfform>

<tr>
<td colspan="3" height="20"></td>
</tr>

<tr><td colspan="3" ></td></tr>

</table>

</div>