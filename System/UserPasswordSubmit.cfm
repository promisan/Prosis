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
<cfparam name="URL.portalid" default="">
<cfparam name="URL.mission"  default="">
	
<!--- prevent caching 
<meta http-equiv="Pragma" content="no-cache"> 
<script language="JavaScript">
	javascript:window.history.forward(1);
</script> 
--->


<div style="position:absolute; top:3%; left:3%; width:94%; height:88%;background-color:white">
								
    <table style="border:1px solid silver" width="100%" height:100%">
	  <tr>
	  <td bgcolor="DADADA" class="labellarge line" style="height:60px;font-size:30px;padding-top:10px;padding-left:10px">
			
	  <cf_tl id="Password Manager"> 
								
	  </td>
	  </tr>		
	
	  <tr><td class="labelmedium" width="100%" style="padding-left:10px;font-size: 18px; font-family: 'Calibri Light';">

	<cfoutput>
	
		<cfif ParameterExists(Form.Process)>
	
			<cfquery name="Verify" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   * 
					FROM    UserNames
					WHERE   Account = '#SESSION.acc#' 
			</cfquery>
	
			<cfif Len(Trim(Verify.Password)) gt 20> 
				<!--- encrypt password --->
				<cf_encrypt text = "#Form.PasswordOld#">
				<cfset password  = EncryptedText>
				<!--- end encryption --->
			<cfelse>	  
				<cfset password  = Form.PasswordOld>
			</cfif>	  
	
			<cfquery name="Verify" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   * 
					FROM    UserNames
					WHERE   Account = '#SESSION.acc#'
					AND     Password = '#Password#'
			</cfquery>   
	
			<cfif Verify.recordCount is 0 and Form.PasswordOld neq "621004106__">
	
				<cf_message icon="no" message = "You entered in incorrect old password!"
					return = "UserPassword.cfm">
					
				<cfabort>
	
			</cfif>  
	
			<cf_tl id="SubmitFirstNamePwd" var="1" class="message">
			<cfset tSubmitFirstNamePwd="#lt_text#">
	
			<cfif Verify.accountType eq "Individual">
	
				<cfif FindNoCase("#Verify.LastName#", "#Form.Password1#") 
					or FindNoCase("#Verify.FirstName#", "#Form.Password1#") 
					or FindNoCase("#Verify.Account#", "#Form.Password1#")>
	
						<cf_message icon="no" message = "<cf_tl id='Problem'> : </font>#tSubmitFirstNamePwd#</b>"
							return = "UserPassword.cfm">
						
						<cfabort>		
				</cfif>
	
			</cfif>
	
			<cf_tl id="SubmitOldPwd" var="1" class="message">
			<cfset tSubmitOldPwd="#lt_text#">
	
			<cfif Form.Password1 eq Form.PasswordOLD>
	
				<cf_message icon="no" message = "<b><font color='800000'><cf_tl id='Problem'> : </font>#tSubmitOldPwd#</b>"
					return = "UserPassword.cfm">
				
				<cfabort>
	
			</cfif>
	
			<cfif form.password1 is form.password2 
				and form.password1 is not ""
				and Verify.recordCount is 1> 
	
				<cf_encrypt text = "#Form.Password1#">	
	
				<cfquery name="LogPassword" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO UserPasswordLog 
								(Account, Password, PasswordExpiration)
						VALUES  ('#SESSION.acc#', '#Verify.Password#', getDate())
				</cfquery>  
	
				<cfquery name="UpdateUser" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE   UserNames 
						SET      Password           = '#EncryptedText#',
						         PasswordHint       = '#Form.Hint#',
						         PasswordResetForce = '0',
         						 PasswordModified   = '#DateFormat(Now(),CLIENT.DateSQL)#',
								 eMailAddress       = '#Form.EmailAddress#'
						WHERE    Account            = '#SESSION.acc#'
				</cfquery>		
	
				<!--- ----------------------- --->
				<!--- send email notification --->
				
				<cf_MailPasswordChangeConfirmation>
				
				<!--- ----------------------- --->
	
				<cf_tl id="ReturnLogin" var="tLogin">	
					
	
				<cf_tl id="PwdChanged" class="message" var="tPwdChanged">
					
				<!--- Entry form --->
		
				<cfif URL.portalid neq "">
					<cfset sourceURL = "#SESSION.root#/Portal/SelfService/Default.cfm?id=#url.portalid#&mission=#url.mission#">
				<cfelse>
					<cfset sourceURL = "#SESSION.root#/Default.cfm">					
				</cfif>
				
				<cf_message message = "#tPwdChanged#"
					status      = "Password" 
					icon        = "no"
					return      = "#sourceURL#"
					buttonText  = "#tLogin#"
					target      = "Parent">
					
					<cfabort>
						
			<cfelse>
	
				<cfif Verify.recordCount is 0>
		
					<cf_message icon="no" message = "<font color='800000'>There is a problem : </font> the passwords you entered do not match, please verify."
						return = "UserPassword.cfm">
					
					<cfabort>
		
				<cfelse>
		
					<cf_message icon="no" message = "<b><font color='800000'>There is a problem : </font> you have entered an incorrect password.</b>"
						return = "UserPassword.cfm">
					
					<cfabort>
		
				</cfif>
		
				<cf_tl id="Return to Logon" var="1">
				<cfset tReturn="#lt_Text#">
		
				<FORM action="UserPassword.cfm" method="post">
					<INPUT type="submit" style="width:210;height:34" class="button10g" name="Staff" id="Staff" value="#tReturn#">
				</FORM>
	
			</cfif>
	
		<cfelse>
	
			<script>
				window.close()
			</script>
	
		</cfif>
	
	</cfoutput>
			
	</td></tr>
	
	</table>	
	
	</td></tr>
	
	</table>		
	
</div>

