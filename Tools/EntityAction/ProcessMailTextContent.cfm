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
		
		    <table><tr><td height="20"></td></tr></table>
			<table width="550" align="center" border="0" cellspacing="0" cellpadding="0" style="margin:auto;background: ##ffffff;font-family:Helvetica,sans-serif;color:##555555;font-size:15px;">	  
				<tr>
					<td colspan="2" style="padding-top:8px">
						<table width="100%" height="50px" style="border-bottom:1px solid ##cccccc;padding:10px 20px 20px;">								
							<tr>
								
								<td style="padding-left:10px;">
									<h1 style="margin:0;color:##555555;font-weight:400;">
									<cfif attributes.accesslevel eq "1">
                                        #SESSION.welcome# <cf_tl id="Action"><br> 
                                        <cfelse>
                                        #SESSION.welcome# <cf_tl id="Notification"><br>
                                        </cfif>
                                        <h2 style="margin:15px 0 0;font-size:16px;"><cf_tl id="An action is pending your review."></h2>
                                    </h1>
		
								</td>
		                        <td style="height:70px;height:70px">						
									<img src="cid:alarm" width="50" height="50" border="0" align="absmiddle" style="display:block">
								</td>
							</tr>
						</table>
					</td>
				</tr>
		        <tr height="10"><td></td></tr>
		 		<tr>
					<td valign="top" style="padding-top:8px">						
						<table width="96%" align="center">
							<tr><td height="20" align="center" class="header" colspan="2"><h3><cf_tl id="Requested by"></h3></td></tr>
							<tr><td height="20" align="right" width="39%"><b><cf_tl id="Name">: </b></td><td height="20" style="padding-left:10px" width="59%">#Last.OfficerFirstName# #Last.OfficerLastName#</td></tr>
							<tr><td height="20" align="right"><b><cf_tl id="On">: </b></td><td height="20" style="padding-left:10px">#dateformat(now(),"#CLIENT.DateFormatShow#")# #timeformat(now(),"HH:MM")# <td></tr>
							<!---
							<tr>
								<td height="20" align="right"><b><cf_tl id="UserId">: </b></td><td height="20" align="left">&nbsp; #Last.OfficerUserId#</td>
							</tr>
							--->
							<tr><td height="20" align="right"><b><cf_tl id="eMail">: </b> </td><td height="20" style="padding-left:10px"><a href = "mailto:#Mail.eMailAddress#">#Mail.eMailAddress#</a></td></tr>
							<tr><td height="20" align="right"><b><cf_tl id="Report problems to">: </b></td><td height="20" style="padding-left:10px"><a href = "mailto:#Parameter.SystemContactEMail#">#Parameter.SystemContactEMail#</a></td></tr>								
							<tr><td height="20"></td></tr>							
							<tr><td height="20" colspan="2" align="center"><h3><cf_tl id="Action details"></h3></td></tr>
							<tr><td class="line" colspan="2"></td></tr>							
							<tr><td height="20" align="right"><b><cf_tl id="Subject">: </b></td><td height="20" style="padding-left:10px">#qObject.EntityDescription#</td></tr>					
							<tr><td height="20" align="right"><b><cf_tl id="Action">: </b></td><td height="20" style="padding-left:10px">#ucase(Action.ActionDescription)#</td></tr>
							<tr><td height="20" align="right"><b><cf_tl id="Reference">: </b></td><td height="20" style="padding-left:10px">#qObject.ObjectReference#</td></tr>
							
							<cfif qObject.PersonNo neq "" and qObject.Mission neq "">
							
								<cfquery name="OnBoard" 
									 datasource="AppsEmployee"
									 username="#SESSION.login#" 
									 password="#SESSION.dbpw#">
									 SELECT   P.*, O.OrgUnitName, O.OrgUnitNameShort
									 FROM     PersonAssignment PA, Position P, Organization.dbo.Organization O
									 WHERE    PersonNo   = '#qObject.PersonNo#' 
									 AND      PA.PositionNo      = P.PositionNo
									 AND      PA.DateEffective   <= getdate()	 
									 AND      P.OrgUnitOperational = O.OrgUnit
									 AND      P.Mission = '#qObject.mission#'						
									 AND      PA.DateExpiration  >= getDate()						 
									 AND      PA.AssignmentStatus IN ('0','1')
									 <!---
									 AND      PA.AssignmentClass = 'Regular'
									 --->
									 AND      PA.AssignmentType  = 'Actual'
									 ORDER BY Incumbency DESC						
								 </cfquery>  
								 
								 <cfif OnBoard.recordcount gte "1">
							 
								 <tr><td height="20" align="right"><b><cf_tl id="Unit">: </b></td><td height="20" style="padding-left:10px">#OnBoard.OrgUnitNameShort#</td></tr>
								 		 							 
								 
									 <cfquery name="OnAssignment" 
										 datasource="AppsEmployee"
										 username="#SESSION.login#" 
										 password="#SESSION.dbpw#">
										 SELECT   O.OrgUnitName, O.OrgUnitNameShort
										 FROM     PersonAssignment PA, Organization.dbo.Organization O
										 WHERE    PersonNo   = '#qObject.PersonNo#' 
										 AND      PA.DateEffective   <= getdate()	 
										 AND      PA.OrgUnit = O.OrgUnit
										 AND      O.Mission = '#qObject.mission#'						
										 AND      PA.DateExpiration  >= getDate()						 
										 AND      PA.AssignmentStatus IN ('0','1')
										 <!---
										 AND      PA.AssignmentClass = 'Regular'
										 --->
										 AND      PA.AssignmentType  = 'Actual'
										 ORDER BY Incumbency DESC						
									 </cfquery>  
									 
									 <cfif OnAssignment.recordcount gte "1" and OnAssignment.OrgUnitNameShort neq OnBoard.OrgUnitNameShort>
									 
									   <tr><td height="20" align="right"><b><cf_tl id="Assignment">: </b></td><td height="20" style="padding-left:10px">#OnAssignment.OrgUnitNameShort#</td></tr>								
									 
									 </cfif>	
								 
								 </cfif>								
							
							</cfif>
														
							<tr><td height="20" align="right"><b><cf_tl id="Subject">: </b></td><td height="20" style="padding-left:10px">#qObject.ObjectReference2#</td></tr>
							
							<cfquery name="qMemo" 
							 datasource="AppsOrganization"  
							 username="#SESSION.login#" 
							 password ="#SESSION.dbpw#"> 
								SELECT       TOP (1) ActionMemo
								FROM         OrganizationObjectAction
								WHERE        ObjectId = '#qObject.ObjectId#'
								ORDER BY     OfficerDate DESC
							</cfquery>
							
							<cfif qMemo.actionMemo neq "">
							 <tr><td height="20" align="right"><b><cf_tl id="Comment">: </b></td><td height="20" style="padding-left:10px">#qMemo.ActionMemo#</td></tr>							
							</cfif>
														
		                    <tr style="height:30px"><td></td></tr>
																	
							<cfif attributes.accesslevel eq "1">					
							
							<tr>
								<td align="center" colspan="2">
									<a style="box-shadow: inset 0 -4px 0 0 rgba(0, 0, 0, 0.2);background: ##3b97d3;	color: ##fafafa;height: 50px;padding: 20px 28px 18px;border-radius: 5px;font-size: 18px;font-weight: 600; text-transform: uppercase; line-height: 46px;text-decoration: none;" 
									   href="#SESSION.root#/ActionView.cfm?id=#qObject.Objectid#&actioncode=#Action.ActionCode#&target=#Action.NotificationTarget#">
									<cfif client.languageid eq "ENG">
										Process &raquo;
									<cfelseif client.languageid eq "ESP">
										Procesar &raquo;
									</cfif>
									</a>
								</td>
							</tr>
		                   
							<cfelse>	
											
							<tr>
								<td style="font-size:16px" height="20" align="center" colspan="2"><cf_tl id="Link">:<br>&nbsp;<a href="#SESSION.root#/ActionView.cfm?id=#qObject.Objectid#&actioncode=#Action.ActionCode#&target=#Action.NotificationTarget#">Press here to process</a></td>
							</tr>
		                    <tr style="height:30px"><td></td></tr>
							
							</cfif>					
											
						</table>
					</td>
				</tr>		
				
				<!---
				<tr style="border-top:1px solid silver;height:30px">
					<td colspan="2" align="center"><font size="1" color="silver"><cf_tl id="Paste link">: <br /> #SESSION.root#/ActionView.cfm?id=#qObject.Objectid#&actioncode=#Action.ActionCode#&target=#Action.NotificationTarget#</td>
				</tr>
		        <tr height="40px"><td></td></tr>
				--->
			</table>
								    					
			<cf_MailDefaultFooter disclaimer="HideSignature" datasource="appsOrganization" context="workflow" id="#qObject.ObjectId#" displaylogo="0">			
						
		</body>
		</html>
		
		<cfmailparam file="#SESSION.rootpath#\Images\SVG\alarm.png" contentid="alarm" disposition="inline"/>

		<!---
    	<cfmailparam file="#SESSION.root#/Images/SVG/alarm.png"        contentid="alarm"     disposition="inline"/>		    
		--->
												
	</cfmail>
		
</cfoutput>