
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
WHERE HostName = '#CGI.HTTP_HOST#'  
</cfquery>

<cfif System.SystemContactEMail neq "">
	<cfset eMail = System.SystemContactEMail>
<cfelse>
    <cfset eMail = Client.eMail>
</cfif>	

<cfif System.AccountNotification eq "1">

	<cfif FileExists ("#SESSION.rootPATH#Custom\#System.ApplicationServer#\AccountCreationNotification.cfm")>

		<cfinclude template="../../../Custom/#System.ApplicationServer#/AccountCreationNotification.cfm">

	<cfelse>
	
		<cfoutput>
		<cfset vTitle ="Prosis | User Account Creation">
		<cfset vPreHeader = "You have a new Prosis account for #session.welcome#">
		<cfsavecontent variable="vBody">
				
 		        <cfif Client.LanPrefix eq "ESP">
		
			         <table border="0" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;" width="100%">
	                    <tr>
	                      <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top;" valign="top">
	                        <p style="font-family: Helvetica, sans-serif; font-size: 24px; font-weight: normal; margin: 0; margin-bottom: 16px;">Bienvenido a #session.Welcome#</p>
	                          <p style="color:##3c4043;font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;">Usted tiene una nueva cuenta<strong>Prosis</strong> con <strong>#session.welcome#</strong>.<br><br>Por favor, inicie sesión en su cuenta para acceder a los servicios de Prosis que su organización proporciona utilizando las siguientes credenciales:</p>
	                          <p style="font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;"><strong>Nombre de usuario:</strong> #Check.account#</p>
	                            <p style="font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;"><strong>Contraseña temporal:</strong> #attributes.password#</p><br>
	                          <p style="font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;color:##3c4043;text-align: center;"><strong>Por favor, inicie sesión para acceder a su cuenta</strong><br>(Se le pedirá que cree una nueva contraseña)</p><br>
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
				  				  
				  <cfelse>		
		
	                  <table border="0" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;" width="100%">
	                    <tr>
	                      <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top;" valign="top">
	                        <p style="font-family: Helvetica, sans-serif; font-size: 24px; font-weight: normal; margin: 0; margin-bottom: 16px;">Welcome to #session.Welcome#</p>
	                          <p style="color:##3c4043;font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;">You have a new <strong>Prosis</strong> Account with <strong>#session.welcome#</strong>.<br><br>Please sign in to your account to access the Prosis services your organization provides using the following credentials:</p>
	                          <p style="font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;"><strong>Username:</strong> #Check.account#</p>
	                            <p style="font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;"><strong>Temporary Password:</strong> #attributes.password#</p><br>
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
				  
				  </cfif>

		</cfsavecontent>
		</cfoutput>
	</cfif>

	<cfoutput>
		<cfsavecontent variable="body">
			<cfinclude template="MailContent.cfm">
		</cfsavecontent>
	</cfoutput>

	
	<cf_assignid>

	<cf_tl id="user account" var="1">
	<cfset vSubject = "#SESSION.welcome# #lt_text#">

	<cfmail TO  = "#Check.eMailAddress#"
    	FROM        = "#email#"
		SUBJECT     = "#vSubject#"
		FAILTO      = "#CLIENT.eMail#"
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
					   'Account Creation',
					   '#Check.eMailAddress#',
					   '#System.Systemcontact#',
					   '#vSubject#', 
					   '#body#',
					   '1')
			</cfquery>
			
	</cfmail>
	
</cfif>	