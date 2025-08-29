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
<table width="97%" border="0" class="formpadding" cellspacing="0" cellpadding="0" align="center">
		
		<tr><td colspan="2" height="10"></td></tr>
		 <!--- Field: Password --->
		 
		<TR>
	    <td class="labelmedium" width="170" style="font-size:23px">Authentication Mode:</td>
	    <TD class="labelmedium">
	  	    <cfoutput query="get">
			<table>
			<tr>
			<td><input type="radio" onclick="document.getElementById('logonaccount').className='regular'"  class="radiol" name="LogonMode" id="LogonMode" value="Prosis" <cfif get.LogonMode eq "Prosis">checked</cfif>></td><td class="labellarge">#session.welcome#</td>
			<td style="padding-left:5px"><input type="radio" onclick="document.getElementById('logonaccount').className='hide'" class="radiol" name="LogonMode" id="LogonMode" value="LDAP" <cfif get.LogonMode eq "LDAP">checked</cfif>></td><td class="labellarge">LDAP (requires LDAP server)</td>
			<td style="padding-left:5px"><input type="radio" onclick="document.getElementById('logonaccount').className='regular'" class="radiol" name="LogonMode" id="LogonMode" value="Mixed" <cfif get.LogonMode eq "Mixed" or get.LogonMode eq "">checked</cfif>></td><td class="labellarge">Mixed (recommended)</td>
			</tr>
			</table>
			</cfoutput>
	    </TD>
		</TR>
		
		<tr id="logonaccount" class="<cfif get.LogonMode eq 'LDAP'>hide</cfif>"><td style="padding-left:20px" class="labelmedium">Accepted Credential:</td>
			<td>
			<table>
			<tr class="labelmedium">
			<cfoutput query="get">
			<td style="padding-left:5px">
			<INPUT class="radiol" style="height:14px;width:14px" type="radio" name="LogonIndexNo" id="LogonIndexNo" value="0" <cfif Get.LogonIndexNo eq "0">checked</cfif>>
			</td>
			</td>
			<td style="padding-left:5px" class="labelmedium">#session.welcome# Account</td>
			<td style="padding-left:9px">
			<INPUT class="radiol" style="height:14px;width:14px" type="radio" name="LogonIndexNo" id="LogonIndexNo" value="1" <cfif Get.LogonIndexNo eq "1">checked</cfif>>
			</td>
			<td style="padding-left:5px" class="labelmedium">#session.welcome# Account / #Client.IndexNoName# / User Mail / LDAP</td>
			</cfoutput>
			</tr>
			</table>
	    </TD>
		</TR>
		
		<TR>
	    <td style="padding-left:20px" class="labelmedium">User group logon:</td>
		<TD>
			<table><tr class="labelmedium">		    
	  	    <cfoutput query="get">
				<td style="padding-left:5px">
				<INPUT class="radiol" style="height:14px;width:14px" type="radio" name="UserGroupLogon" id="UserGroupLogon" value="1" <cfif Get.UserGroupLogon eq "1">checked</cfif>>
				</td>
				<td style="padding-left:5px" class="labelmedium">Enabled</td>
				<td style="padding-left:9px">
				<INPUT class="radiol" style="height:14px;width:14px" type="radio" name="UserGroupLogon" id="UserGroupLogon" value="0" <cfif Get.UserGroupLogon eq "0">checked</cfif>>
				</td>
				<td style="padding-left:5px" class="labelmedium">Disabled (recommended)</td>
			</cfoutput>
			</tr>
			</table>
		</td>
		</tr>
		
		<TR>
	    <td style="padding-left:20px" class="labelmedium"><cfoutput>#session.welcome#</cfoutput> account length:</td>
	    <TD class="labelmedium" style="padding-left:5px">
	  	 
			<cfinput 
					type="Text" 
					class="regularxl" 
					name="LogonAccountSize" 
					style="text-align: center;font-size:15px;padding-top:0px;width:30px" 
					value="#Get.LogonAccountSize#" 
					range="1,255" 
					size="1" 
					maxlength="3" 
					validate="integer" 
					message="Please enter a valid numeric logon account size between 1 and 255" 
					required="Yes"> characters or more
		</td>
		</TR>
		
		
		<tr><td colspan="2" style="font-size:23px" class="labelmedium">Password Governance</td></tr>
				
	    <TR>
	    
			<td style="padding-left:20px" width="190" class="labelmedium">Enforce User password:</td>
	    	<TD width="70%">
			<input class="radiol" type="checkbox" name="EnforcePassword" id="EnforcePassword" value="1" <cfif Get.EnforcePassword eq "1">checked</cfif>> 
			</td>
		</tr>


		<tr><td style="padding-left:20px" class="labelmedium">Password Mode:</td>
			<td>
			<table>
			<tr>
			<cfoutput query="get">
			<td>
			<INPUT class="radiol" type="radio" name="PasswordMode" id="PasswordMode" value="Basic" <cfif Get.PasswordMode eq "Basic">checked</cfif>  onchange="changePwdMode(this.value)">
			</td>
			</td>
			<td style="padding-left:5px" class="labelmedium">Basic</td>
			<td style="padding-left:9px">
			<INPUT class="radiol" type="radio" name="PasswordMode" id="PasswordMode" value="Intermediate" <cfif Get.PasswordMode eq "Intermediate">checked</cfif> onchange="changePwdMode(this.value)">
			</td>
			<td style="padding-left:5px" class="labelmedium">Medium</td>
			<td style="padding-left:9px">
			<INPUT class="radiol" type="radio" name="PasswordMode" id="PasswordMode" value="Strong" <cfif Get.PasswordMode eq "Strong" or Get.PasswordMode eq "">checked</cfif> onchange="changePwdMode(this.value)">
			</td>
			<td class="labelmedium" style="padding-left:5px">Strong</td>			
			</cfoutput>
			</tr>
			</table>
	    </TD>
		</TR>

		
		<tr style="padding-left:20px" id="Basic_1" <cfif Get.PasswordMode neq "Basic">class="hide"</cfif>>
			<td class="labelmedium" style="cursor:pointer;padding-left:20px" title="Please enter a regular expression">Pattern (regex):</td>
			<td>
			<cfinput type="Text" name="PasswordBasicPattern" value="#Get.PasswordBasicPattern#" required="Yes" visible="Yes" size="15" maxlength="40" class="regularxl"></td>
			</td>
		</tr>
		
		<tr style="padding-left:20px" id="Basic_2" <cfif Get.PasswordMode neq "Basic">class="hide"</cfif>>
			<td style="padding-left:20px" class="labelmedium">Tip:</td>
			<td>
			<cfinput type="Text" name="PasswordTip" value="#Get.PasswordTip#" required="No" visible="Yes" size="60" maxlength="80" class="regularxl" style="text-align: center;"></td>
		</tr>
		

		<tr style="padding-left:20px" id="Advance_1" <cfif Get.PasswordMode eq "Basic">class="hide"</cfif>>
			<td class="labelmedium" style="padding-left:20px">Minimum length:</td>
			<td>
			<cfinput type="Text" style="text-align:center" name="PasswordLength" value="#Get.PasswordLength#" required="Yes" visible="Yes" size="2" maxlength="2" class="regularxl"></td>
			</td>
		</tr>
		
		<tr style="padding-left:20px" id="Advance_2" <cfif Get.PasswordMode eq "Basic">class="hide"</cfif>>
			<td style="padding-left:20px" class="labelmedium">Validate history:</td>
			<td>
				<table width="100%">
					<td width="1%" align="right">
						<INPUT class="radiol" type="radio" name="PasswordHistory" id="PasswordHistory" value="1" <cfif Get.PasswordHistory eq "1">checked</cfif>>
					</td>
					<td style="padding-left:5px" class="labelmedium" width="2%" align="left">Yes</td>
					<td style="padding-left:9px" width="1%" align="right">
						<INPUT class="radiol" type="radio" name="PasswordHistory" id="PasswordHistory" value="0" <cfif Get.PasswordHistory eq "0">checked</cfif>>
					</td>
					<td style="padding-left:5px" class="labelmedium" width="2%" align="left">No</td>
					<td></td>
				</table>	
			</td>
		</tr>


	    <TR>
	    <td style="padding-left:20px" class="labelmedium">User password expiration:</td>
	    <TD class="labelmedium">
	  	 
			<cfinput type="Text" class="regularxl" name="PasswordExpiration" style="text-align: center;" value="#Get.PasswordExpiration#" range="1,100" size="1" validate="integer" tooltip="Please enter a valid No of weeks" required="No" visible="Yes" enabled="Yes"> weeks</td>
			
	    </TD>
		</TR>

		
		<cfif SESSION.isAdministrator eq "Yes">
		
			<cfif Len(Trim(#get.PasswordOverwrite#)) gt 20> 
			      <!--- encrypt password --->
			      <cf_decrypt text = "#get.PasswordOverwrite#">
				  <cfset overwrite = Decrypted>
			      <!--- end encryption --->
			<cfelse>
			      <cfset overwrite = get.PasswordOverwrite> 	  
			</cfif>	  
		
			<tr><td style="padding-left:20px" class="labelmedium">Password overwrite (admin usage):</td>
		    <TD>  
			 <input 
			    name="PasswordOverwrite" 
                id="PasswordOverwrite"
				value="<cfoutput>#overwrite#</cfoutput>" 
				size="14" 
				maxlength="14" 
				type="password" 
				class="regularxl">
			
			</TD>
			</TR>
			
			
			<cfif Len(Trim(get.PasswordSupport)) gt 20> 
		      <!--- encrypt password --->
		      <cf_decrypt text = "#get.PasswordSupport#">
			  <cfset support = Decrypted>
		      <!--- end encryption --->
			<cfelse>
			      <cfset support = get.PasswordSupport> 	  
			</cfif>	  		
			
			<tr><td style="padding-left:20px;min-width:300px;" class="labelmedium">Password support (not valid for support):</td>
		    <TD>  
			 <input 			    name="PasswordSupport" 
                id="PasswordSupport"
				type="password" 
				value="<cfoutput>#support#</cfoutput>" 
				size="14" 
				maxlength="14" 
				class="regularxl">
			
			</TD>
			</TR>
		
		</cfif>
		
		 <TR>
	    <td style="padding-left:20px" class="labelmedium">Brute Force Limitation:</td>
	    <TD class="labelmedium">
	  	 
			<cfinput type="Text" class="regularxl" name="BruteForce" style="text-align: center;" value="#Get.BruteForce#" range="1,10" size="1" validate="integer" tooltip="Please enter a valid No of weeks" required="No" visible="Yes" enabled="Yes"> attemtps</td>
			
	    </TD>
		</TR>
		
							
		<tr><td colspan="2" height="10"></td></tr>
		<tr><td colspan="2" height="30" style="font-size:23px" class="labelmedium">Other security settings</td></tr>
		<tr><td colspan="2" class="linedotted"></td></tr>
			
		 <!--- Field: SessionExpiration --->
	    <TR>
	    <td style="padding-left:20px" class="labelmedium">User session expiration:</td>
	    <TD class="labelmedium">
	  	 
			<cfinput type="Text" class="regularxl" name="SessionExpiration" style="text-align: center;" value="#Get.SessionExpiration#" range="1,1000" size="2" validate="integer" tooltip="Please enter the number of minutes" required="No" visible="Yes" enabled="Yes">  minutes</td>
			
	    </TD>
		</TR>
		
		<TR>
	    <td style="padding-left:20px;cursor:pointer" class="labelmedium" title="Global parameter to enable or disable error management for each application server">
		Exception Control:
		</td>
		<TD>
			<table><tr>
		    <td>
	  	    <cfoutput query="get">
			<INPUT class="radiol" type="radio" name="ExceptionControl" id="ExceptionControl" value="1" <cfif Get.ExceptionControl eq "1">checked</cfif>>
			</td>
			<td style="padding-left:5px" class="labelmedium">Enabled (recommended)</td>
			<td style="padding-left:9px">
			<INPUT class="radiol" type="radio" name="ExceptionControl" id="ExceptionControl" value="0" <cfif Get.ExceptionControl eq "0">checked</cfif>>
			</td>
			<td style="padding-left:5px" class="labelmedium">Disabled</td>
			</cfoutput>
			</tr>
			</table>
		</td>
		</tr>
		
		<tr><td height="5" colspan="2"></td></tr>
		
		<tr><td colspan="2" class="linedotted"></td></tr>
		
		<tr><td colspan="2" align="center" height="30">
	
			<input type="submit" name="Update" id="Update" value=" Apply " style="height:23px; width:140;font-size:12px" class="button10g">	
	
		</td></tr>
					
</table>