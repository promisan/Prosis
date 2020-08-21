<cfquery name="Error" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  UR.*, UN.FirstName, UN.LastName, UN.EmailAddress
	FROM    UserError UR
	INNER   JOIN UserNames UN
	 	    ON UR.Account = UN.Account
	WHERE   ErrorId = '#attributes.errorid#'
</cfquery>

<cfif Error.EnableProcess eq 1>
		
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

	<cfoutput>

	<cfsavecontent variable="body">

		<style>
			body {
				font-size: 130%;
				font-family:  -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,Ubuntu,Cantarell,"Helvetica Neue",sans-serif;
			}
	    </style>
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td colspan="2" valign="top">
								<table cellpadding="0" cellspacing="0" border="0" width="100%" style="border-bottom:1px solid silver">
									<tr>
										<td width="5%">						
											<img src="cid:logo" width="50" height="50" border="0" align="absmiddle">				
										</td>
										<td valign="middle" style="padding-left:10px;">
											<table>
												<tr><td><font size="5" color="003059"><b>#SESSION.welcome# <cf_tl id="Support Agent"></b></font></td></tr>
												<tr><td><font size="3" color="black"><cf_tl id="New Ticket"></font></td></tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td height="10"></td></tr>
						<tr>
							<td height="20" width="20%">
								<font size="2" color="1562a4"><cf_tl id="Account">:</font>
							</td>
							<td>
								<font size="2" color="black">#Error.Account#</font>
							</td>
						</tr>   
						<tr>
							<td height="20">
								<font size="2" color="1562a4"><cf_tl id="Name">:</font>
							</td>
							<td>
								<font size="2" color="black">#Error.FirstName# #Error.LastName#</font>
							</td>
						</tr>   
						<tr>
							<td height="20">
								<font size="2" color="1562a4"><cf_tl id="TicketNo">:</font>
							</td>
							<td>
								<font size="2" color="black">#Error.ErrorNo#</font>
							</td>
						</tr>
						<tr>
							<td height="20">
								<font size="2" color="1562a4"><cf_tl id="Date"> - <cf_tl id="Time">:</font>
							</td>
							<td>
								<font size="2" color="black">#DateFormat(Error.ErrorTimeStamp,Client.DateSQL)# - #TimeFormat(Error.ErrorTimeStamp,"hh:mm:ss")#</font>
							</td>
						</tr>
						<tr><td colspan="2" height="10"></td></tr>
						<tr>
							<td height="20"></td>
							<td>
								<font size="2" color="black">
									#SESSION.welcome# <cf_tl id="has detected an unexpected problem">.<br>
									<cf_tl id="A support ticket was created for you under"> #Error.HostServer#/#Error.ErrorNo#
								</font>
							</td>
						</tr>
						
						<tr><td colspan="2" height="20"></td></tr>
						
						<tr>
							<td width="100%" colspan="2" align="center">
								<font size="3" color="black">
									<cfif System.ErrorMailToOwner neq "9">
										<cf_tl id="You can check the status of the ticket in the following link">:  
										<a name="Support Portal"
                                        id="Support Portal"
                                        href="#SESSION.root#/Portal/Selfservice/Default.cfm?ID=support"
                                        target="support"> <font size="4" color="6688AA">#Error.ErrorNo#</font></a>
									</cfif>
								</font>
							</td>
						</tr>

					</table>
				</td>
			</tr>
		</table>
	
	</cfsavecontent>

	</cfoutput>
	
	<cf_assignid>

	<cf_tl id="support ticket" var="1">
	<cfset vSubject = "#SESSION.welcome# #lt_text# #Error.ErrorNo#">

	<cfmail TO  = "#Error.eMailAddress#"
    	FROM        = "#eMail#"
		SUBJECT     = "#vSubject#"
		FAILTO      = "#System.Systemcontact#"
		mailerID    = "#SESSION.welcome#"
		TYPE        = "html"
		spoolEnable = "Yes"
		wraptext    = "100">	
			
			<cfoutput>#body#</cfoutput>
			
			<br><br><br>
			<!--- disclaimer --->
			<cf_maildisclaimer context="password" id="mailid:#rowguid#">
			
			<cfmailparam file="#SESSION.root#/Images/features.png" contentid="logo" disposition="inline"/>
			
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
				VALUES ('#Error.Account#',
				       'Support',
					   'Support Ticket',
					   '#Error.eMailAddress#',
					   '#Error.eMailAddress#',
					   '#vSubject#', 
					   '#body#',
					   '1')
			</cfquery>
			
	</cfmail>
	

</cfif>