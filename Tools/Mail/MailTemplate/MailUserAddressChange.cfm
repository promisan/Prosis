
<cfparam name="attributes.account" default="#SESSION.acc#">

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

<cfif isValid("email", eMail)>
    
<cfoutput>
    
        <cfif Check.eMailAddressExternal neq "">
    <cfset vTitle ="Secondary Email Updated">
        

        <cfset vPreHeader = "Secondary Email Updated.">


        <cfsavecontent variable="vBody">
            <cfoutput>
                <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;" width="100%">
                        <tr>
                          <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top;" valign="top">
                            <p style="font-family: Helvetica, sans-serif; font-size: 24px; font-weight: normal; margin: 0; margin-bottom: 16px;text-align: center;">Secondary Email Updated</p>
                              <p style="color:##3c4043;font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;text-align: center;">Hello #Check.FirstName# #Check.LastName#,<br><br>
                                  You have added a secondary email address on your  <strong>Prosis</strong> Account with <strong>#session.welcome#</strong>.<br><br>
                                  <strong>Your Account:  (#Check.Account#)</strong><br>
                                  <strong>New Address: #Check.eMailAddressExternal#</strong><br><br>

                                  You're getting this email to make sure it was you. <cf_tl id="If you have <b>NOT</b> added this address to your account" var="1">#trim(lt_text)#, <cf_tl id="you must contact"> <b>#System.Systemcontact#</b> <cf_tl id="immediately" var="1">#trim(lt_text)#.</p><br>
                              <table border="0" cellpadding="0" cellspacing="0" class="btn btn-primary" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; box-sizing: border-box; min-width: 100% !important;" width="100%">
                              <tbody>
                                <tr>
                                  <td align="center" style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top; padding-bottom: 16px;" valign="top">
                                    <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: auto;">
                                      <tbody>
                                        <tr>
                                          <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top; background-color: ##3498db; border-radius: 4px; text-align: center;" valign="top" bgcolor="##3498db" align="center"> <a href="mailto:#system.SystemContactEMail#" target="_blank" style="display: inline-block; color: ##ffffff; background-color: ##3498db; border: solid 2px ##3498db; border-radius: 4px; box-sizing: border-box; cursor: pointer; text-decoration: none; font-size: 14px; font-weight: bold; margin: 0; padding: 12px 24px; text-transform: capitalize; border-color: ##3498db;">Contact Administrator &raquo;</a> </td>
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
        </cfoutput>		 		
        </cfsavecontent>
    <cfelse>
	
        <cfset vTitle ="Secondary Email Removed">
        <cfset vPreHeader = "Secondary Email Removed">

        <cfsavecontent variable="vBody">
            <cfoutput>
                <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;" width="100%">
                        <tr>
                          <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top;" valign="top">
                            <p style="font-family: Helvetica, sans-serif; font-size: 24px; font-weight: normal; margin: 0; margin-bottom: 16px;text-align: center;">Secondary Email Removed</p>
                              <p style="color:##3c4043;font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 18px;text-align: center;">Hello #Check.FirstName# #Check.LastName#,<br><br>
                                  You have removed your secondary email address on your <strong>User</strong> Account with <strong>#session.welcome#</strong> (#Check.Account#).<br><br>
                                 
                                  You're getting this email to make sure it was you. <cf_tl id="If you did <b>NOT</b> remove this address from your account" var="1">#trim(lt_text)#, <cf_tl id="you must contact"> <b>#System.Systemcontact#</b> <cf_tl id="immediately" var="1">#trim(lt_text)#.</p><br>
                              <table border="0" cellpadding="0" cellspacing="0" class="btn btn-primary" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; box-sizing: border-box; min-width: 100% !important;" width="100%">
                              <tbody>
                                <tr>
                                  <td align="center" style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top; padding-bottom: 16px;" valign="top">
                                    <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: auto;">
                                      <tbody>
                                        <tr>
                                          <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top; background-color: ##3498db; border-radius: 4px; text-align: center;" valign="top" bgcolor="##3498db" align="center"> <a href="mailto:#system.SystemContactEMail#" target="_blank" style="display: inline-block; color: ##ffffff; background-color: ##3498db; border: solid 2px ##3498db; border-radius: 4px; box-sizing: border-box; cursor: pointer; text-decoration: none; font-size: 14px; font-weight: bold; margin: 0; padding: 12px 24px; text-transform: capitalize; border-color: ##3498db;">Contact Administrator &raquo;</a> </td>
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
        </cfoutput>		 		
        </cfsavecontent>        
    </cfif>    

	<cfsavecontent variable="body">
		<cfinclude template="MailContent.cfm">		
	</cfsavecontent>
	   
</cfoutput>
		
		<!--- send mail --->	
		
		<cf_assignid>
		<cf_tl id="user account" var="1">
		<cfset vSubject = "#SESSION.welcome# #lt_text#">
		
		<cfmail TO  = "#Check.eMailAddress#"
    	FROM        = "#System.Systemcontact#  <#System.SystemContactEMail#>"
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
			VALUES ('#attributes.account#',
			       'Security',
				   'EMailAddress',
				   '#Check.eMailAddress#',
				   '#System.Systemcontact#',
				   '#vSubject#', 
				   '#body#',
				   '1')
		</cfquery>	
							
	</cfmail>
	
</cfif>	

