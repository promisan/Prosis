<cfparam name="Attributes.userAccount" 	default="">

<!--- reset password --->

<cfquery name="Check" 
	datasource="AppsSystem">
		SELECT  *
		FROM    UserNames 
		WHERE   Account = '#Attributes.userAccount#' 
</cfquery>

<cfquery name="System" 
	datasource="AppsInit">
		SELECT  *
		FROM    Parameter
		WHERE   HostName = '#CGI.HTTP_HOST#' 
</cfquery>


<cfif Check.eMailAddress neq "">   <!--- and Check.DisableNotification eq "0" --->
	
   <cfoutput>
   
      <cfsavecontent variable="body">

      	<style>
			body {
				font-size: 130%;
				font-family:  -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,Ubuntu,Cantarell,"Helvetica Neue",sans-serif;
			}
        </style>
   
 		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">	  
			<tr>
				<td colspan="2">
					<table width="100%" style="border-bottom:1px solid silver">								
						<tr>
							<td width="5%">						
								<img src="cid:logo" width="50" height="50" border="0" align="absmiddle" style="display:block">
							</td>
							<td style="padding-left:10px;">
								<table>
									<tr><td><font face="calibri" size="5" color="003059"><b>#SESSION.welcome# - <cf_tl id="Security Agent"></b></font></td></tr>
									<tr><td><font size="3" face="calibri" color="black"><cf_tl id="User Account Recovery Request"></font></td></tr>
									<tr><td><font face="calibri" size="2" color="1562a4"><cf_tl id="This request has been recorded"></font></td></tr>
								</table>
							</td>	
						</tr>
					</table>
				</td>
			</tr>
	 		<tr>
				<td valign="top" style="padding-top:8px">						
					<table width="96%"  cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td height="25" colspan="2" style="background-color:##F9F9F9;">
								<font size="3" color="003059"><b><cf_tl id="Action details"></b></font>
							</td>
						</tr>
						<tr>
							<td height="20" width="20%"><font size="2" color="1562a4"><cf_tl id="Account">:</font></td>
							<td><font size="2" color="black">#Check.Account#</font></td>
						</tr>
						<tr>
							<td height="20"><font size="2" color="1562a4"><cf_tl id="Account Name">:</font></td>
							<td><font size="2" color="black">#Check.FirstName# #Check.LastName#</font></td>
						</tr>						
					</table>
				</td>
			</tr>		
			<tr><td height="20"></td></tr>
			<tr>
				<td valign="top" style="padding-top:8px; padding-left:2%; padding-right:2%;">
					<font size="2" color="808080">
						<cf_tl id="Now you can go to"> <b>#SESSION.welcome#</b> <cf_tl id="and login using this account and your password">.
						<br>
						<cf_tl id="If you do not remember your password, you can reset it using this account">.
						<br>
						<cf_tl id="If reseting your password is necessary, you will receive more instructions upon reset submission">.
					</font>
				</td>
			</tr>		
		</table>
   
      </cfsavecontent>
	  
	</cfoutput>
	
	<cf_assignid>
	<cf_tl id="Notification" var="1">
	<cfset vSubject = "#SESSION.welcome# ** #lt_text# **">
			
	<cfmail TO          = "#Check.eMailAddress#"	       	
   			FROM        = "#System.Systemcontact#  <#System.SystemContactEMail#>"
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
			
			<cfmailparam file="#SESSION.root#/Images/password.gif" contentid="logo" disposition="inline"/>
	
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
	