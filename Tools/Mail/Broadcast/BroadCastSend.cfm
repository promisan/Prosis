	
	<cfquery name="Broadcast" 
	   datasource="AppsSystem" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		SELECT * 
		FROM   Broadcast 
		WHERE  BroadcastId = '#URL.BroadcastId#'  
	</cfquery>
	
	<cfquery name="BroadcastSet" 
	   datasource="AppsSystem" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		 UPDATE  Broadcast 
		 SET     BroadcastSent      = getDate(),		 
		 	     BroadcastStatus    = '1'		  
		 WHERE   BroadcastId = '#URL.BroadcastId#'  
	</cfquery>
	
	<cfquery name="BroadcastLog" 
	   datasource="AppsSystem" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		  INSERT INTO BroadcastDelivery
		  (BroadcastId,BroadCastDelivery,OfficerUserId,OfficerLastName,OfficerFirstName)
		  VALUES
		  ('#URL.BroadcastId#',getDate(),'#SESSION.acc#','#SESSION.last#','#SESSION.first#')
	</cfquery>
	
	<!--- record the action mail in UserMail with link to broadcast --->
	
	<!--- send the mail to multiple to --->
	
	<cfquery name="Recipient" 
	   datasource="AppsSystem" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		 SELECT DISTINCT BR.RecipientId, 
		       BR.eMailAddress, 
			   BR.RecipientCode, 
			   BR.RecipientName
			   			    
		 FROM  BroadcastRecipient BR
		 WHERE BroadcastId = '#URL.BroadcastId#' 
		 AND   Selected = '1'		 
	</cfquery>
	
	<!--- context sensitive --->
	
	<cfif BroadCast.systemFunctionId neq "">
	
		<!--- prepares dynamic fields to be parsed --->
		<cfinclude template="BroadCastContext.cfm">
				
	</cfif>	
			
	<cfset to  = "">
	<cfset bcc = "">
	
	<cfset recip = "0">
	
	<cfdirectory action="LIST"
	    directory = "#SESSION.rootDocumentPath#\Broadcast\#URL.BroadcastId#"
	    name      = "att"
	    filter    = "*.*"
        sort      = "DateLastModified DESC"
        type      = "all"
        listinfo  = "name">			
		
	<cfif recip eq "1">
			
			<cfloop query="Recipient">
			 
			  	<cfif isValid("email", "#eMailAddress#") AND BroadCast.BroadcastReplyTo neq "">
				
						<cfif BroadCast.systemFunctionId eq "">
						
								<!--- default mode --->					
								<cfset body = BroadCast.BroadcastContent>
								
						<cfelse>					
							
								<!--- loop through the fields  --->					
								<cfset body = BroadCast.BroadcastContent>					
								<cfinclude template="BroadCastParse.cfm">
												
					   </cfif>	
		  			
					   <cftry>
					   			   
						   <cfset vSubject = "#BroadCast.BroadcastSubject# #RecipientName#">	
													   
						   <cfmail to       = "#eMailAddress#"						
								from        = "#BroadCast.BroadcastReplyTo#"				
						        subject     = "#vSubject#"
						        replyto     = "#BroadCast.BroadcastReplyTo#"
						        priority    = "#BroadCast.BroadcastPriority#"
						        failto      = "#BroadCast.BroadcastFailto#"
						        mailerid    = "#SESSION.welcome#"
						        type        = "HTML"
								spoolEnable = "Yes">
								
								<table width="100%">
								<tr><td>#body#</td></tr>
								
								<tr><td height="1" bgcolor="silver"></td></tr>												
								<tr>
								 <td align="center">
								 <font face="Verdana" size="1" color="black">
								 This message, including any attachments, contains confidential information intended for a specific individual and purpose, and is protected by law. If you are not the intended recipient, please contact the sender immediately by reply e-mail and destroy all copies. You are hereby notified that any disclosure, copying, or distribution of this message, or the taking of any action based on it, is strictly prohibited.
								 </font>
								 </td>
								</tr>
														
								</table>						
															
								<cfloop query="att">
								     <cfmailparam file = "#SESSION.rootDocumentPath#\Broadcast\#URL.BroadcastId#\#name#">
								</cfloop>
								
								<!--- content sensitive attachments --->
																						
								<cfdirectory action="LIST"
								    directory = "#SESSION.rootDocumentPath#\Broadcast\#URL.BroadcastId#\#RecipientCode#"
								    name      = "contextattach"
								    filter    = "*.*"						   
								    type      = "all"
								    listinfo  = "name">		
														
								<cfloop query="contextattach">										
									
									 <cfmailparam file = "#SESSION.rootDocumentPath#\Broadcast\#URL.BroadcastId#\#Recipient.RecipientCode#\#name#">
														
								</cfloop>
								
		
						    </cfmail>
							
							 <cfquery name="Update" 
								datasource="AppsSystem" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#"> 	
								UPDATE BroadCastRecipient
								SET    RecipientMailBody = '#body#',
								       RecipientMailSent = 1
								WHERE  BroadCastId = '#Broadcast.BroadCastId#'
								AND    RecipientId = '#recipientid#' 							
							</cfquery>
							
							<cfif URL.SourcePath neq "">
								<cfset URL.OrgUnit = Recipient.OrgUnit>
								<cfset URL.RecipientId = recipientid>
								<cfset URL.BroadCastId = Broadcast.BroadCastId>
								<cfset URL.eMailAddress = eMailAddress>
								<cfset URL.SubmissionEdition = Broadcast.BroadcastReference>
								<cfinclude template="../../../Custom#Trim(URL.SourcePath)#MailConfirmation.cfm">	
							</cfif>											
						
						<cfcatch>
						
							<cfquery name="Update" 
								datasource="AppsSystem" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#"> 	
								UPDATE BroadCastRecipient
								SET    RecipientMailSent = 0
								WHERE  BroadCastId = '#Broadcast.BroadCastId#'
								AND    RecipientId = '#recipientid#' 							
							</cfquery>					
						
						</cfcatch>
										
						</cftry>
						
				<cfelse>		
				
					<cfquery name="Update" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#"> 	
						UPDATE BroadCastRecipient
						SET    RecipientMailSent = 0
						WHERE  BroadCastId = '#Broadcast.BroadCastId#'
						AND    RecipientId = '#recipientid#' 							
					</cfquery>					
							
			    </cfif>
					  
			</cfloop>	
		
	</cfif>	
						
	
			
		
	<!--- confirmation eMail --->
	
	<cfif BroadCast.BroadcastBCC eq "1" and (BroadCast.BroadCastCC neq "" or BroadCast.BroadcastReplyTo neq "")>	
	
		 <cfset sendcc  = replaceNoCase(BroadCast.BroadCastCC," ","ALL")>
	     <cfset replyto = replaceNoCase(BroadCast.BroadcastReplyTo," ","ALL")>
		
		 <cfmail to     = "#sendcc#;#replyto#;vanpelt@promisan.com"						
				from        = "#replyto#"				
		        subject     = "Broadcast mail delivery confirmation"
		        replyto     = "#replyto#"
		        priority    = "#BroadCast.BroadcastPriority#"
		        failto      = "#BroadCast.BroadcastFailto#"
		        mailerid    = "#SESSION.welcome#"
		        type        = "HTML"
				spoolEnable = "Yes">
						
			<cf_screentop label="Broadcast mail confirmation" mail="yes" layout="webapps" width="900" html="No">				
				
			    <table width="100%">
					<tr>
						<td height="8"></td></tr>
					<tr>
						<td>
							<table width="900px" bgcolor="white" cellpadding="10" cellspacing="10" style="padding-left:10px;border:0px dotted silver">
							
								<tr>
									<td>
										<table width="730" align="center" class="formpadding">
										
											<cfoutput>
											<tr><td colspan="3" align="left" valign="middle" height="70">
												<table width="100%">
													<tr>
														<td>&nbsp;&nbsp;&nbsp;<img src="#SESSION.root#/Images/Logos/Broadcast/Broadcast.png" height="64" width="64" alt="" align="absmiddle" border="0"></td>
														<td style="padding-left:10px" valign="middle" width="85%">
														<font size="7" face="calibri" color="##002149">#SESSION.welcome# Broadcast Confirmation</font></td>
													</tr>
												</table>
												</td></tr>
											</cfoutput>
											
											<tr><td height="15"></td></tr>
											<tr><td colspan="3" class="line"></td></tr>											
											<tr><td height="15"></td></tr>
														
											<tr>
											   <td width="30"></td>
											   <td style="padding-left:15px" width="150" align="left"><font face="calibri" size="3" color="##1562bf">Sent by:</td>
											   <td width="85%"><font face="calibri" size="3" color="black">#SESSION.first# #SESSION.last#</td>
											</tr>
											
											<tr>
											   <td width="30"></td>
											   <td style="padding-left:15px" width="150" align="left"><font face="calibri" size="3" color="##1562bf">Timestamp:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
											   <td><font face="calibri" size="3" color="black">#dateformat(now(),CLIENT.DateFormatShow)# #timeformat(now(),"HH:MM")#</td>
											</tr>											
																						
											<tr>
											   <td width="30"></td>
											   <td style="padding-left:15px" width="150" align="left"><font face="calibri" size="3" color="##1562bf">Subject:</td>
											   <td><font face="Verdana" size="2" color="black">#BroadCast.BroadcastSubject#</td>
											</tr>
											
											<cfif att.recordcount gte "1">
											<tr>
											<td width="30"></td>
											<td style="padding-left:15px"><font face="calibri" size="3" color="##1562bf">Attachment:</td>
											<td><font face="Verdana" size="2" color="black"><cfloop query="att">#name#;</cfloop></td>
											</tr>	
											</cfif>		
																							
											<tr>
											<td width="30"></td>
											<td style="padding-left:15px" colspan="2" align="left"><font face="calibri" size="3" color="##1562bf">Mail Body</td>
											</tr>	
											<tr><td colspan="3" style="border-bottom:1px solid silver"></td></tr>						
											<tr>
											    <td colspan="3" bgcolor="white">
												
												<table width="96%" align="center" bgcolor="white">
													<tr><td style="padding:10px"><font face="Verdana" color="black">
													<cfif BroadCast.BroadcastContent eq "">[no body]<cfelse>#BroadCast.BroadcastContent#</cfif></td></tr>
												</table>
												
												</td>
											</tr>		
											
											<tr><td height="15"></td></tr>
											
											<tr bgcolor="F0F2CC">
											    <td width="30"></td>
												<td colspan="2" valign="top">
												<table style="width:100%">
												<tr><td height="10"></td></tr>
												<tr><td style="padding-left:15px" align="left"><font face="calibri" size="3" color="##1562bf">Recipients:</td></tr>
												</table>
												</td>
											</tr>
											
											<tr bgcolor="F0F2CC">	
											    <td width="30"></td>
												<td colspan="2">
													<table width="100%">	
													
													<cfquery name="Recipient" 
													   datasource="AppsSystem" 
													   username="#SESSION.login#" 
													   password="#SESSION.dbpw#">
														 SELECT   RecipientId, 
														          eMailAddress, 
															      RecipientCode, 
															      RecipientLastName,
															      RecipientFirstName,
															      RecipientName,
															      RecipientMailSent
														 FROM     BroadcastRecipient
														 WHERE    BroadcastId = '#URL.BroadcastId#' 
														 AND      Selected = '1'
														 ORDER BY RecipientLastName,RecipientFirstName,RecipientName ASC
													</cfquery>
																	
													<cfloop query="Recipient">
														<cfif RecipientMailSent eq "1">
															<tr><td style="padding-right:4px"><font face="Verdana" size="1" color="black">#currentrow#.</td>
															    <td width="95%"><font face="Verdana" size="2" color="black">#RecipientName# [#eMailAddress#]</td>
															</tr>
														<cfelse>
															<tr><td style="padding-right:4px"><font face="Verdana" size="1" color="black">#currentrow#.</td>
															    <td width="95%"><font face="Verdana"  size="2" color="FF0000">#RecipientName# [#eMailAddress#]</td>
															</tr>
														</cfif>
													</cfloop>
													</table>
												</td>
											</tr>
											
											<tr><td colspan="3" style="border-bottom:1px solid silver"></td></tr>		
											
											<tr><td height="15"></td></tr>
											
											<tr>
											 <td colspan="3" align="center">
											 <font face="Verdana" size="1" color="black">
											 This message, including any attachments, contains confidential information intended for a specific individual and purpose, and is protected by law. If you are not the intended recipient, please contact the sender immediately by reply e-mail and destroy all copies. You are hereby notified that any disclosure, copying, or distribution of this message, or the taking of any action based on it, is strictly prohibited.
											 </font>
											 </td>
											</tr>		
											
										</table>
									</td>
								</tr>
								
							</table>
						</td>
					</tr>
				</table>
									
			<cfloop query="att">
			     <cfmailparam file = "#SESSION.rootDocumentPath#\Broadcast\#URL.BroadcastId#\#name#">
			</cfloop>

			<cf_screenbottom layout="webapp" mail="yes">
		
	    </cfmail>			  
		  
	</cfif>	 
		
			  
    <cfif broadcast.BroadcastRecipient eq "Applicant">
		    
		<cfquery name="clear" 
		   datasource="AppsSystem" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   
		   DELETE FROM   Applicant.dbo.ApplicantMail
		   WHERE  MailId IN (
		                    SELECT R.RecipientId
		   			        FROM   BroadCast B INNER JOIN
		                           BroadCastRecipient R ON B.BroadcastId = R.BroadcastId
              			    WHERE  B.BroadcastId = '#URL.BroadcastId#' 
			                AND     Selected = '1'		
						    )	  			
		</cfquery>	
		
		<cfquery name="Recipient" 
		   datasource="AppsSystem" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   INSERT INTO Applicant.dbo.ApplicantMail
		 			  (MailId, PersonNo, FunctionId, MailAddress, MailAddressFrom, MailSubject, MailBody)
		   SELECT    R.RecipientId, 
		             R.RecipientCode, 
					 B.BroadcastId, 
					 R.eMailAddress, 
					 B.BroadcastFrom, 
					 B.BroadcastSubject, 
					 B.BroadcastContent
			FROM     BroadCast B INNER JOIN
		             BroadCastRecipient R ON B.BroadcastId = R.BroadcastId
			 WHERE   B.BroadcastId = '#URL.BroadcastId#' 
			 AND     Selected = '1'		    
		</cfquery>
		
	<cfelseif broadcast.BroadcastRecipient eq "Edition">	
	
		<cfquery name="update" 
		   datasource="AppsSystem" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   UPDATE Applicant.dbo.Ref_SubmissionEditionPublishMail
		   SET    ActionStatus = '1' 
		   WHERE  SubmissionEdition = '#BroadCast.BroadcastReference#'
		   AND    OrgUnit IN (SELECT RecipientCode 
		                      FROM   BroadCastRecipient 
					 		  WHERE  Selected = 1 
						 	  AND    RecipientMailSent = 1 
							  AND    BroadcastId = '#URL.BroadcastId#')			
		</cfquery>	
		
		<cftry>
				
		<cfquery name="Recipient" 
		   datasource="AppsSystem" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   INSERT INTO Applicant.dbo.Ref_SubmissionEditionPublishMail
		 			(RecipientId, 
					 BroadCastId,
					 RecipientName,
					 SubmissionEdition, 					
					 eMailAddress, 
					 EditionSent,
					 OrgUnit, 
					 ActionStatus,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
		   SELECT    R.RecipientId, 
		             '#URL.BroadcastId#',
					 R.RecipientLastName,
		             B.BroadcastReference, 					
					 R.eMailAddress, 
					 getDate(),
					 R.RecipientCode,
					 '1',
					 '#SESSION.acc#',
					 '#SESSION.last#',
					 '#SESSION.first#'
			FROM     BroadCast B INNER JOIN
		             BroadCastRecipient R ON B.BroadcastId = R.BroadcastId
			 WHERE   B.BroadcastId = '#URL.BroadcastId#' 
			 AND     Selected = '1'		
			 AND     RecipientMailSent = 1    
		</cfquery>	
		
		<cfcatch></cfcatch>
		
		</cftry>
					
	<cfelseif broadcast.BroadcastRecipient eq "User">
	
		<cfquery name="clear" 
		   datasource="AppsSystem" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   
		   DELETE FROM   UserMail
		   WHERE  MailId IN (
		                    SELECT R.RecipientId
		   			        FROM   BroadCast B INNER JOIN
		                           BroadCastRecipient R ON B.BroadcastId = R.BroadcastId
              			    WHERE  B.BroadcastId = '#URL.BroadcastId#' 
			                AND    Selected = '1'		
						    )	  			
		</cfquery>	
		  
		<cfquery name="Recipient" 
			   datasource="AppsSystem" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   INSERT INTO UserMail
			   (MailId, Account, Source, SourceId, MailAddress, MailAddressFrom, MailSubject, MailBody, MailDateSent)
			   SELECT    R.RecipientId, 
			             R.RecipientCode, 
						 'Broadcast',
						 B.BroadcastId, 
						 R.eMailAddress, 
						 B.BroadcastFrom, 
						 B.BroadcastSubject, 
						 B.BroadcastContent,
						 getDate()
				FROM     BroadCast B INNER JOIN
			             BroadCastRecipient R ON B.BroadcastId = R.BroadcastId
				 WHERE   B.BroadcastId = '#URL.BroadcastId#' 
				 AND     Selected = '1'		    
		</cfquery>
			    
	</cfif>
	  
  <script>
   alert("Broadcast is delivered to mail (smtp) server.")
   // parent.window.location = "BroadCastView.cfm?mode=#url.mode#&ts="+new Date().getTime()+"&id=#url.broadcastid#"
  </script>
 
