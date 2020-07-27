<!---#sendto#--->
<!--- CC      = "vanpelt@promisan.com"--->

<cfparam name="client.languageid" default="ENG">

 <cfquery name="getEntityMail" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	R.MailFrom,
				R.MailFromAddress
		FROM	OrganizationObject O
				INNER JOIN Ref_Entity R
					ON O.EntityCode = R.EntityCode
		WHERE	O.ObjectId = '#qObject.ObjectId#'
</cfquery>

<cfset fromName = "">
<cfif getEntityMail.recordCount gt 0 AND getEntityMail.MailFromAddress neq "">
	<cfset from = getEntityMail.MailFromAddress>
	<cfset fromName = trim(getEntityMail.MailFrom)>
<cfelseif client.eMail eq "">
    <cfset from = System.DefaultEMail>
<cfelse>
    <cfset from = client.EMail> 
</cfif>

<cfif fromName neq "">				
	<cfset fromm = "#fromName#<#from#>">
<cfelse>
	<cfset fromm = "#from#">
</cfif>

<cfoutput>
	
	<cfmail TO          = "#sendto#"        
		    FROM        = "#fromm#"
			SUBJECT     = "#Attributes.text#: #Action.ActionDescription#"	
			mailerID    = "#SESSION.welcome#"
			FAILTO      = "#from#"
			REPLYTO     = "#from#"
			TYPE        = "html"
			spoolEnable = "Yes"
			wraptext    = "100">
			
		<!--- ------------------------------- --->
		<!--- get the atachment of the object --->
		<!--- ------------------------------- --->
				
		<cfparam name="attributes.sendattobj" default="">
						
		<cfif attributes.sendAttObj eq "1" and qObject.DocumentPathName neq "">
											
			<cf_fileExist
				DocumentPath  = "#qObject.DocumentPathName#"
				SubDirectory  = "#qObject.ObjectId#" 
				Filter        = ""					
				ListInfo      = "all">		
			
			<cfif filelist.recordcount eq "0">
			
				<cf_fileExist
					DocumentPath  = "#qObject.DocumentPathName#"
					SubDirectory  = "#qObject.ObjectKeyValue4#" 
					Filter        = ""					
					ListInfo      = "all">		
								
			</cfif>		
							
			<!--- returns a query object filelist --->
			
			<cfloop query="filelist">
			
				<cfquery name="qAttachment" 
						 datasource="AppsOrganization"  
						 username="#SESSION.login#" 
						 password ="#SESSION.dbpw#"> 
							SELECT * 
							FROM   System.dbo.Attachment
							WHERE  Reference        = '#qObject.ObjectId#'
							AND    DocumentPathName = '#qObject.DocumentPathName#'
							AND    FileName         = '#name#'							
				</cfquery>
				   
				   <cfif qAttachment.fileStatus neq "9">
				   
				   	   <cfmailparam file="#directory#\#name#">						   				
													
				   </cfif>				
			
			</cfloop>					
		
		</cfif>				
			
		<!--- ---------------Hanno 17/5/2012 --------------------- --->	
		<!--- add a provsion to include attachmenta of the object --->
		<!--- --------------------------------------------------- --->	
		
		<!doctype html>

		<html>
		<head>
		
		<title>Alert Message</title>
		   <meta name="viewport" content="width=device-width" />
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			
			<style>
				td.mainheader {
				line-height:17px;
				color:##4186c9;
				}
				
				td.header {
				line-height:15px;
				color:##003b74;
				}
				
				td.description {
				line-height:15px;
				color:gray;
				}
		
		</style>
		
		</head>
		
		<body style="background:##f1f1f1;">
		
		    <table><tr><td height="40"></td></tr></table>
			<table width="600" align="center" border="0" cellspacing="0" cellpadding="0" style="margin:auto;background: ##ffffff;font-family:Helvetica,sans-serif;color:##555555;font-size:15px;">	  
				<tr>
					<td colspan="2" style="padding-top:8px">
						<table width="100%" height="50px" style="border-bottom:1px solid ##cccccc;padding:10px 20px 20px;">								
							<tr>
								
								<td style="padding-left:10px;">
									<h1 style="margin:0;color:##555555;font-weight:400;">
									<cfif attributes.accesslevel eq "1">
		                                            #SESSION.welcome# <cf_tl id="Alert"><br> 
		                                            <cfelse>
		                                            #SESSION.welcome# <cf_tl id="Notification"><br>
		                                            </cfif>
		                                            <h2 style="margin:5px 0 0;font-size:16px;"><cf_tl id="Activity for your action has been posted."></h2>
		                                        </h1>
		
								</td>
		                                    <td width="70px">						
									<img src="cid:alarm" width="60" height="60" border="0" align="absmiddle" style="display:block">
								</td>
							</tr>
						</table>
					</td>
				</tr>
		                    <tr height="10"><td></td></tr>
		 		<tr>
					<td valign="top" style="padding-top:8px">						
						<table width="96%"  cellspacing="0" cellpadding="0" align="center">
							<tr><td height="20" align="center" class="header" colspan="2"><h3><cf_tl id="Requested by"></h3></td></tr>
							<tr><td height="20" align="right" width="49%"><b><cf_tl id="Name">: </b></td><td height="20" align="left" width="49%">&nbsp; #Last.OfficerFirstName# #Last.OfficerLastName#</td></tr>
							<tr><td height="20" align="right"><b><cf_tl id="On">: </b></td><td height="20" align="left">&nbsp; #dateformat(now(),"#CLIENT.DateFormatShow#")# #timeformat(now(),"HH:MM")# <td></tr>
							<!---
							<tr>
								<td height="20" align="right"><b><cf_tl id="UserId">: </b></td><td height="20" align="left">&nbsp; #Last.OfficerUserId#</td>
							</tr>
							--->
							<tr><td height="20" align="right"><b><cf_tl id="eMail">: </b> </td><td height="20" align="left">&nbsp; <a href = "mailto:#Mail.eMailAddress#">#Mail.eMailAddress#</a></td></tr>
							<tr><td height="20" align="right"><b><cf_tl id="Report problems to">: </b></td><td height="20" align="left">&nbsp; <a href = "mailto:#Parameter.SystemContactEMail#">#Parameter.SystemContactEMail#</a></td></tr>								
							<tr><td height="20"></td></tr>							
							<tr><td height="20" colspan="2" align="center"><h3><cf_tl id="Action details"></h3></td></tr>
							<tr><td class="line" colspan="2"></td></tr>							
							<tr><td height="20" align="right"><b><cf_tl id="Subject">: </b></td><td height="20" align="left">&nbsp; #qObject.EntityDescription#</td></tr>					
							<tr><td height="20" align="right"><b><cf_tl id="Action">: </b></td><td height="20" align="left">&nbsp; #Action.ActionDescription#</td></tr>
							<tr><td height="20" align="right"><b><cf_tl id="Reference">: </b></td><td height="20" align="left">&nbsp; #qObject.ObjectReference#</td></tr>
							<tr><td height="20" align="right"><b><cf_tl id="Memo">: </b></td><td height="20" align="left">&nbsp; #qObject.ObjectReference2#</td></tr>
		                    <tr height="40px"><td></td></tr>
							
							<!---
							<cfset FileNo = round(Rand()*100)>		
							--->
										
							<cfif attributes.accesslevel eq "1">					
							
							<tr>
								<td align="center" colspan="2">
									<a style="box-shadow: inset 0 -4px 0 0 rgba(0, 0, 0, 0.2);background: ##3b97d3;	color: ##fafafa;height: 50px;padding: 20px 28px 18px;border-radius: 5px;font-size: 18px;font-weight: 600; text-transform: uppercase; line-height: 46px;text-decoration: none;" href="#SESSION.root#/ActionView.cfm?id=#qObject.Objectid#">
									<cfif client.languageid eq "ENG">
										Process &raquo;
									<cfelseif client.languageid eq "ESP">
										Procesar &raquo;
									</cfif>
									</a>
								</td>
							</tr>
		                    <tr height="40px"><td></td></tr>
							
							<cfelse>					
							<tr>
								<td height="20" align="center" colspan="2"><cf_tl id="Link">: <br />&nbsp;<a href="#SESSION.root#/ActionView.cfm?id=#qObject.Objectid#"><font color="0080FF">Press here to view</a></td>
							</tr>
		                    <tr height="40px"><td></td></tr>
							
							</cfif>					
											
						</table>
					</td>
				</tr>		
				<tr style="border-top:1px solid silver;height:30px">
					<td colspan="2" align="center"><font size="1" color="silver"><cf_tl id="Paste link">: <br /> #SESSION.root#/ActionView.cfm?id=#qObject.Objectid#</td>
				</tr>
		        <tr height="40px"><td></td></tr>
			</table>
		    
			<table><tr><td height="40"><cf_MailDefaultFooter></td></tr></table>
			
		</body>
		</html>

    	<cfmailparam file="#SESSION.root#/Images/SVG/alarm.png" contentid="alarm" disposition="inline"/>
		<cfmailparam file="#SESSION.root#/Images/prosis-logo-gray.png" contentid="logo-gray" disposition="inline"/>
												
	</cfmail>
		
</cfoutput>
	