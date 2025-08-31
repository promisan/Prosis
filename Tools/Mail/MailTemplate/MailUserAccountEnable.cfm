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
<cfquery name="Check" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    UserNames 
	WHERE   Account = '#attributes.account#'
</cfquery>

<cfquery name="System" 
datasource="AppsInit">
	SELECT  *
	FROM    Parameter
	WHERE   HostName = '#CGI.HTTP_HOST#' 
</cfquery>

<cfif System.SystemContactEMail neq "">
	<cfset eMail = System.SystemContactEMail>
<cfelse>
    <cfset eMail = Client.eMail>
</cfif>	

<cfif Len(Trim(check.Password)) gt 20> 
 	<cf_decrypt text = "#check.Password#">
	<cfset vTemporaryPassword = Decrypted>
<cfelse>
      <cfset vTemporaryPassword = check.Password> 	  
</cfif>

<cfif System.AccountNotification eq "1">
	
	<cfif Check.eMailAddress neq "">
	
		<cfoutput>		
			
			<cfset vTitle ="User Account Creation">
			<cfset vPreHeader = "You have a new user account for #session.welcome#">
				
			<cfsavecontent variable="vBody">
		    
				  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;" width="100%">
                    <tr>
                      <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top;" valign="top">
                        <p style="font-family: Helvetica, sans-serif; font-size: 24px; font-weight: normal; margin: 0; margin-bottom: 16px;">Welcome back to <strong>#session.Welcome#</strong></p>
                          <p style="color:##3c4043;font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;">Hello #Check.FirstName# #Check.LastName#,<br><br>
                              Your <strong>User</strong> Account with <strong>#session.welcome#</strong> has been reactivated.<br><br>Please sign in to your account to access the Prosis services your organization provides using the following credentials:</p>
                          <p style="font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;"><strong>Username:</strong> #Check.account#</p>
                            <p style="font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;"><strong>Temporary Password:</strong> #vTemporaryPassword#</p><br>
                          <p style="font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;color:##3c4043;text-align: center;"><strong>Please sign in to access your account</strong><br>(You will be required to create a new password)</p><br>
                          <table border="0" cellpadding="0" cellspacing="0" class="btn btn-primary" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; box-sizing: border-box; min-width: 100% !important;" width="100%">
                          <tbody>
                            <tr>
                              <td align="center" style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top; padding-bottom: 16px;" valign="top">
                                <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: auto;">
                                  <tbody>
                                    <tr>
                                      <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top; background-color: ##3498db; border-radius: 4px; text-align: center;" valign="top" bgcolor="##3498db" align="center"> <a href="#SESSION.root#/Default.cfm" target="_blank" style="display: inline-block; color: ##ffffff; background-color: ##3498db; border: solid 2px ##3498db; border-radius: 4px; box-sizing: border-box; cursor: pointer; text-decoration: none; font-size: 14px; font-weight: bold; margin: 0; padding: 12px 24px; text-transform: capitalize; border-color: ##3498db;">Sign in &raquo;</a> </td>
                                    </tr>
                                  </tbody>
                                </table>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                        <br>
                      </td>
                    </tr>
                  </table>
				
			</cfsavecontent>
			
			<cfsavecontent variable="body">
				<cfinclude template="MailContent.cfm">		
			</cfsavecontent>
		
		</cfoutput>
		
		<cf_assignid>

		<cf_tl id="user account" var="1">
		<cfset vSubject = "#SESSION.welcome# #lt_text#">
		
		<cfmail to      = "#Check.eMailAddress#"
	        from        = "#eMail#"
	        subject     = "#vSubject#"
	        type        = "HTML"
	        FAILTO      = "#CLIENT.eMail#"
	        mailerID    = "#SESSION.welcome#"
	        spoolEnable = "Yes"
	        wraptext    = "100">

			<cfoutput>#body#</cfoutput>
			
			<br><br><br>
			
			<!--- disclaimer --->
			
			<cf_maildisclaimer context="password" id="mailid:#rowguid#">
			
			<cfmailparam file="#SESSION.root#/Images/prosis-logo-300.png"  contentid="logo"      disposition="inline"/>
            <cfmailparam file="#SESSION.root#/Images/prosis-logo-gray.png" contentid="logo-gray" disposition="inline"/>
		 
			 <cfquery name="Insert" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO UserMail
						(Account, 
						Source, 
					    Reference, 
						MailAddress, 
						MailAddressFrom, 
						MailSubject, 
						MailBody, 
						MailStatus)
					VALUES ('#Check.Account#',
					       'Security',
						   'Account Reinstated',
						   '#Check.eMailAddress#',
						   '#System.Systemcontact#',
						   '#vSubject#', 
						   '#body#',
						   '1')
				</cfquery>
		 
		    </cfmail>
					
	</cfif>		
	
</cfif>			

