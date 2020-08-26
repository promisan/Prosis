
<cfparam name="Attributes.acc" 		default="">
<cfparam name="Attributes.welcome"	default="">
<cfparam name="Attributes.root"		default="">
<cfparam name="Attributes.newPwd"	default="">
<cfparam name="Attributes.refEmail"	default="">

<cfif trim(Attributes.acc) eq "" AND isDefined("SESSION.acc")>
	<cfset Attributes.acc = SESSION.acc>
</cfif>

<cfif trim(Attributes.welcome) eq "" AND isDefined("SESSION.welcome")>
	<cfset Attributes.welcome = SESSION.welcome>
</cfif>

<cfif trim(Attributes.root) eq "" AND isDefined("SESSION.root")>
	<cfset Attributes.root = SESSION.root>
</cfif>

<cfquery name="Check" 
datasource="AppsSystem">
	SELECT  *
	FROM    UserNames 
	WHERE   Account = '#Attributes.acc#'
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


<cfif System.AccountNotification eq "1">

	<cfif Check.eMailAddress neq "" and Check.DisableNotification eq "0">
		
	   <cfoutput>
	   	
	<cfset vTitle     = "#session.welcome# Password reset">
	<cfset vPreHeader = "The pasword for your User Account has been reset.">
					
	<cfsavecontent variable="vBody">
    
	        <table style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;" width="100%">
                    <tr>
                      <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top;" valign="top">
                        <p style="font-family: Helvetica, sans-serif; font-size: 24px; font-weight: normal; margin: 0; margin-bottom: 16px;text-align: center;"><strong>#session.welcome#</strong> Password reset</p>
                          <p style="color:##3c4043;font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;text-align: center;">
						  	Hello #Check.FirstName# #Check.LastName#,<br><br>
                            The pasword for your User Account with <strong>#Attributes.welcome#</strong> (#Check.Account#) was reset. You're getting this email to make sure it was you. <cf_tl id="In case you have <b>NOT</b> changed this password yourself" var="1">#trim(lt_text)#, <cf_tl id="you must contact"> <b>#System.Systemcontact#</b> <cf_tl id="immediately" var="1">#trim(lt_text)#.
						  </p><br>
						  <cfif trim(attributes.newPwd) neq "">
							<p style="color:##3c4043;font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;text-align: center;">
                              Your new password for #trim(Attributes.refEmail)# is: <span style="font-weight:bold; font-size:125%;">#attributes.newPwd#</span>.
						  	</p><br>
							<p style="color:##3c4043;font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;text-align: center;">
                              We recommend you to change your password on your next login.
						  	</p><br>
						  </cfif>
                          <table border="0" cellpadding="0" cellspacing="0" class="btn btn-primary" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; box-sizing: border-box; min-width: 100% !important;" width="100%">
                          <tbody>
                            <tr>
                              <td align="center" style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top; padding-bottom: 16px;" valign="top">
                                <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: auto;">
                                  <tbody>
                                    <tr>
                                      <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top; background-color: ##3498db; border-radius: 4px; text-align: center;" valign="top" bgcolor="##3498db" align="center"> 
									  <a href="mailto:#System.SystemContactEMail#" target="_blank" style="display: inline-block; color: ##ffffff; background-color: ##3498db; border: solid 2px ##3498db; border-radius: 4px; box-sizing: border-box; cursor: pointer; text-decoration: none; font-size: 14px; font-weight: bold; margin: 0; padding: 12px 24px; text-transform: capitalize; border-color: ##3498db;">Contact Administrator &raquo;</a> </td>
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

		<cf_tl id="password change" var="1">
		<cfset vSubject = "#Attributes.welcome# #lt_text#">
		
		<!--- #System.Systemcontact#  <#System.SystemContactEMail#> --->
		
		
		<cfmail TO          = "#Check.eMailAddress#"
	   			FROM        = "#eMail#"
				SUBJECT     = "#vSubject#"
				FAILTO      = "#System.SystemContactEMail#"
				mailerID    = "#Attributes.welcome#"
				TYPE        = "html"
				spoolEnable = "Yes"
				wraptext    = "100">

				<cfoutput>#body#</cfoutput>
				
				<br><br><br>
				<!--- disclaimer --->
				<cf_maildisclaimer context="password" id="mailid:#rowguid#">
				
				<!---
				<cfmailparam file="#Attributes.root#/Images/prosis-logo-300.png" contentid="logo" disposition="inline"/>
				--->
	            <cfmailparam file="#Attributes.root#/Images/prosis-logo-gray.png" contentid="logo-gray" disposition="inline"/>
											
				<!--- log mail --->
			
				<cfquery name="Insert" 
				datasource="AppsSystem">
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
						   'Password Change',
						   '#Check.eMailAddress#',
						   '#System.Systemcontact#',
						   '#vSubject#', 
						   '#body#',
						   '1')
				</cfquery>
												
		</cfmail>
				
	</cfif>			
	
</cfif>		