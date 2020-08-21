
<!--- reset password  --->


<cfparam name="attributes.mode"   default="0">
<cfparam name="attributes.source" default="backoffice">

<cfquery name="Check" 
datasource="AppsSystem">
	SELECT  *
	FROM    UserNames 
	WHERE   Account = '#SESSION.acc#' 
</cfquery>

<cfquery name="System" 
	datasource="AppsInit">
	SELECT *
	FROM   Parameter
	WHERE  Hostname = '#CGI.HTTP_HOST#' 
</cfquery>


<cfif System.SystemContactEMail neq "">
	<cfset eMail = System.SystemContactEMail>
<cfelse>
    <cfset eMail = Client.eMail>
</cfif>	
	
<cfif System.PasswordReset eq "0">
	<cfset act = "Request">
<cfelse>
	<cfset act = "Temporary">
</cfif>		
	
<cfset expiry = dateAdd("h","12",now())>

<cf_assignid>

<cfquery name="insert" 
	datasource="AppsSystem">
		INSERT INTO UserPasswordAction
		(ActionId,Account,ActionCode,ActioneMail,ActionExpiration,ActionRedirect)
		VALUES (
			'#rowguid#',
			'#Check.account#',
			'#act#',
			'#Check.eMailAddress#',
			#expiry#,
			'#attributes.Source#')				 
</cfquery>	

<cfif System.PasswordReset eq "1">

	<cfinvoke component      = "Service.Authorization.PasswordCheck"  
		      method         = "generateRandomPassword"
	          returnvariable = "newPassword">	
				  
	<cfset Random = newPassword>

	<cftry>
				
		<cfquery name="Logging" 
			datasource="AppsSystem">
			INSERT INTO UserPasswordLog
				(Account,PasswordExpiration,Password)
			VALUES
				('#SESSION.acc#',getdate(),'#check.password#')	
		</cfquery>
		
		<cfcatch></cfcatch>
	
	</cftry>
	
	<cfquery name="Reset" 
		datasource="AppsSystem">
		UPDATE  UserNames
		SET     Password           = '#random#',
		        PasswordResetForce = 1
		WHERE   Account            = '#SESSION.acc#'
	</cfquery>
	
</cfif>

<cfif Check.eMailAddress neq "">   <!--- and Check.DisableNotification eq "0" --->
		
	   <cfoutput>
	   
	   	<cfif System.PasswordReset eq "1">
					
		<cfset vTitle ="User Account Creation">
		<cfset vPreHeader = "You have a new Prosis account for #session.welcome#">	
	
		<cfsavecontent variable="vBody">
                  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;" width="100%">
                    <tr>
                      <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top;" valign="top">
                        <p style="font-family: Helvetica, sans-serif; font-size: 24px; font-weight: normal; margin: 0; margin-bottom: 16px;">Prosis Password Recovery Request</p>
                          <p style="color:##3c4043;font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;">You have requested a new password for your <strong>Prosis</strong> Account with <strong>#session.welcome#</strong>.<br><br>Please sign in to your account to access the Prosis services your organization provides using the following credentials:</p>
                          <p style="font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;"><strong>Username:</strong> #Check.account#</p>
                            <p style="font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;"><strong>Temporary Password:</strong> #random#</p><br>
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
		
		<cfelse>	  
	     	
	<cfset vTitle ="Prosis | User Account Creation">
	<cfset vPreHeader = "You have a new Prosis account for #session.welcome#">
		
	<cfsavecontent variable="vBody">
                  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;" width="100%">
                    <tr>
                      <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top;" valign="top">
                        <p style="font-family: Helvetica, sans-serif; font-size: 24px; font-weight: normal; margin:16px 0;text-align: center">Password Recovery Request</p>
                          <p style="color:##3c4043;font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;text-align: center;">You have requested a new password for your <strong>Prosis</strong> Account with <strong>#session.welcome#</strong>.</p><br>
                          <p style="font-family: Helvetica, sans-serif; font-size: 18px; font-weight: normal; margin: 0; margin-bottom: 18px;text-align: center;"><strong>Username:</strong> #Check.account#</p><br>
                          <p style="font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;color:##3c4043;text-align: center;"><strong><cf_tl id="Click on this link to create a new password"></strong><br>
                          <table border="0" cellpadding="0" cellspacing="0" class="btn btn-primary" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; box-sizing: border-box; min-width: 100% !important;" width="100%">
                          <tbody>
                            <tr>
                              <td align="center" style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top; padding-bottom: 16px;" valign="top">
                                <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: auto;">
                                  <tbody>
                                    <tr>
                                      <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top; background-color: ##3498db; border-radius: 4px; text-align: center;" valign="top" bgcolor="##3498db" align="center"> <a href="#system.applicationroot#/PasswordRequest.cfm?actionid=#rowguid#" target="_blank" style="display: inline-block; color: ##ffffff; background-color: ##3498db; border: solid 2px ##3498db; border-radius: 4px; box-sizing: border-box; cursor: pointer; text-decoration: none; font-size: 14px; font-weight: bold; margin: 0; padding: 12px 24px; text-transform: capitalize; border-color: ##3498db;">Set New Password &raquo;</a> </td>
                                    </tr>
                                  </tbody>
                                </table>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                        <br>
                        <p style="font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;text-align: center;"><cf_tl id="If you have <b>NOT</b> requested this password recovery" var="1">#trim(lt_text)#,<br><cf_tl id="you must contact"> <b>#System.Systemcontact#</b> <cf_tl id="immediately" var="1">#trim(lt_text)#.</p><br>
                      </td>
                    </tr>
                  </table>
		
	</cfsavecontent>
	
	<cfsavecontent variable="vFooter" >
          <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;" width="100%">
            <tr>
              <td class="content-block" style="font-family: Helvetica, sans-serif; vertical-align: top; padding: 0 15px 24px; font-size: 12px; color: ##999999; text-align: justify;" valign="top" align="center">
                  <br><br>
                  <img src="cid:logo-gray" width="126" height="35"><br>
                  <span style="color: ##999999; font-size: 12px; text-align: center;">Powered by <a href="https://www.promisan.com" style="color: ##F7531B; font-size: 12px; font-weight: bold; text-align: center; text-decoration: none;">Promisan</a></span><br>
                  <span style="color: ##777777; font-size: 11px; text-align: center;">
                      <strong>Netherlands</strong> | Vd. Valk Boumanlaan 17, 3446 GE Woerden, The Netherlands | <a href="tel:+31653956277" style="color: ##F7531B; font-size: 11px; font-weight: bold; text-align: center; text-decoration: none;">+31 6 539 56277</a><br>
                      <strong>United States</strong> | 1103 Hickory Way, Weston, Florida 33327 | <a href="tel:+19548269070" style="color: ##F7531B; font-size: 11px; font-weight: bold; text-align: center; text-decoration: none;">+1 954 826 9070</a><br>
                      <strong>Guatemala</strong> | 6th avenue 6-63, zone 10 Sixtino 1 Office 901, Guatemala City, 01010 | <a href="tel:+50222698000" style="color: ##F7531B; font-size: 11px; font-weight: bold; text-align: center; text-decoration: none;">+502 2269-8000</a><br>
                      <a href="mailto:information@promisan.com" style="color: ##F7531B; font-size: 11px; font-weight: bold; text-align: center; text-decoration: none;">information@promisan.com</a><br>
                  </span>
             
              </td>
            </tr>
            </table>
	</cfsavecontent>	

	<cfsavecontent variable="body">
		<cfinclude template="MailContent.cfm">
            
	</cfsavecontent>
		  
		</cfif>  
					  
		</cfoutput>
		
		<cf_assignid>

		<cf_tl id="Notification" var="1">
		<cfset vSubject = "#session.welcome# ** #lt_text# **">
		
		<cfmail TO          = "#Check.eMailAddress#"	       	
	   			FROM        = "#email#"
				SUBJECT     = "#vSubject#"
				FAILTO      = "#System.SystemContactEMail#"
				mailerID    = "#SESSION.welcome#"
				TYPE        = "html"
				spoolEnable = "Yes"
				wraptext    = "100">			
				
				<cfoutput>#body#</cfoutput>
				
				<br><br><br>
				<!--- disclaimer --->
				<cf_maildisclaimer context="password" id="mailid:#rowguid#">
				
				<cfmailparam file="#SESSION.root#/Images/prosis-logo-300.png" contentid="logo" disposition="inline"/>
            	<cfmailparam file="#SESSION.root#/Images/prosis-logo-gray.png" contentid="logo-gray" disposition="inline"/>
		
				<!--- log mail --->
			
				<cfquery name="Insert" 
				datasource="AppsSystem">
					INSERT INTO UserMail
					   (Account, 
					    MailId,
						Source, 
					    Reference, 
						MailAddress, 
						MailAddressFrom, 
						MailSubject, 
						MailBody, 
						MailStatus)
					VALUES ('#Check.Account#',
					       '#rowguid#',
					       'Security',
						   'Password Recovery',
						   '#Check.eMailAddress#',
						   '#System.Systemcontact#',
						   '#vSubject#', 
						   '#body#',
						   '1')
				</cfquery>
														
		</cfmail>			
		
</cfif>			


	