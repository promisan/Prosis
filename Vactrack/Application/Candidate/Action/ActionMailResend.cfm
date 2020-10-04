
<!--- save action
      save and submit the eMail
	  and refresh listing --->
	  
<cfquery name="Action" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT      *				
	FROM        Ref_EntityAction
	WHERE       ActionCode = '#url.actionCode#'	
</cfquery>	  
	
<cfquery name="Entity" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT      *				
	FROM        Ref_Entity
	WHERE       EntityCode = '#Action.EntityCode#'	
</cfquery>

<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT      *				
	FROM        OrganizationObject
	WHERE       EntityCode      = '#Action.EntityCode#'
	AND         ObjectkeyValue1 = '#url.documentno#'
	AND         Operational = 1	
</cfquery>

<cfquery name="get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     OrganizationObjectActionMail
	WHERE    ThreadId = '#url.ActionId#'									
	ORDER BY SerialNo DESC
</cfquery>

<cfparam name="Form.MailTo" default="#get.MailTo#">
<cfparam name="Form.MailSubject" default="#get.MailSubject#">
<cfparam name="Form.MailBody" default="#get.MailBody#">
<cfparam name="Form.MailAttachment" default="">

<cfif Object.recordcount eq "1" and Form.MailTo neq "">

			<cfmail  FROM   = "#Entity.MailFromAddress#"
				TO          = "#Form.MailTo#"
				CC          = ""
				BCC         = ""								
				SUBJECT     = "RESEND: #Form.MailSubject#"										
				mailerID    = "#SESSION.welcome# Mail Engine"
				TYPE        = "html"
				replyto     = "#client.eMail#"
				priority    = "1"
				spoolEnable = "Yes"			
				wraptext    = "100">											
				#Form.MailBody#		
				
				<!--- disclaimer --->
				<br><br>
				<cf_maildisclaimer context="recruitment" id="mailid:#get.ThreadId#">		
				
				<cfif form.Mailattachment neq "">
				
					<cfquery name="Att" 
					datasource="appsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
						SELECT      *
						FROM        Attachment
						WHERE       DocumentPathName = 'VacDocument' 
						AND         Reference = '#Object.objectid#'	
						AND         AttachmentId IN (#preserveSingleQuotes(form.MailAttachment)#)		
					</cfquery>																										
					
					<cfloop query="Att">						
						<cfmailparam file = "#session.rootdocumentpath##att.ServerPath#\#att.FileName#">						
					</cfloop>		
					
				</cfif>				
																													
				</cfmail>							
						
				<cfquery name="checked" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   TOP 1 SerialNo
					FROM     OrganizationObjectActionMail
					WHERE    ThreadId = '#url.ActionId#'									
					ORDER BY SerialNo DESC
				</cfquery>
						
				<cfset next = get.serialno+1> 
								
				<cfset addcc = "">				
									
				<cfquery name="qCheck" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">					
						SELECT * 
						FROM   OrganizationObjectActionMail
						WHERE  ThreadId = '#url.ActionId#' 
						AND    SerialNo = '#next#'
				</cfquery>
								
				<cfif qCheck.recordCount eq 0>
							
						<cfquery name="Insert" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">					
							INSERT INTO OrganizationObjectActionMail (
										ThreadId,
										SerialNo,
										ObjectId,
										ActionCode,
										ActionId, 
										MailUserAccount,
										MailType,
										MailTo, 
										MailCc,
										MailSubject, 
										MailBody, 
										Priority,											
										OfficerUserId, 
										OfficerLastName, 
										OfficerFirstName)
								VALUES ('#url.ActionId#',
										'#next#', 
										'#Object.ObjectId#',
										'#url.ActionCode#',
										'#url.ActionId#', 	
										'#SESSION.acc#',
										'activity',			   
										'#Form.MailTo#',
										'#addcc#',
										'#form.MailSubject#',
										'#form.MailBody#',
										'1',											
										'#SESSION.acc#',
										'#SESSION.last#',
										'#SESSION.first#')
					    </cfquery>	
						
						<!--- record attachement 								
						
						<cfloop index="att" from="1" to="10" step="1">
										   
						   <cfparam name="mailatt[#Att#][1]" default="none">
						   <cfparam name="mailatt[#Att#][2]" default="none">									   
						   <cfparam name="mailatt[#Att#][3]" default="none">											   
						   
						   <cfif mailatt[att][1] neq "none">	
						   									           										
								<cfquery name="Insert" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">					
									INSERT INTO OrganizationObjectActionMailAttach (ThreadId,SerialNo,AttachmentNo,AttachmentPath,AttachmentDisposition,AttachmentName)
									VALUES ('#Attributes.ActionId#','#next#','#att#','#mailatt[att][1]#','#mailatt[att][2]#','#mailatt[att][3]#')
								</cfquery>													
									
							</cfif>
															   				  			   
					    </cfloop>	
						
						--->									
			    
			    </cfif>				   										 
	</cfif>	 
	 	  
<cfoutput>  
	<script>   
		ProsisUI.closeWindow('activitybox');
		_cf_loadingtexthtml='';	
		ptoken.navigate('#session.root#/Vactrack/Application/Candidate/Action/ActionListing.cfm?documentNo=#url.documentno#&PersonNo=#url.PersonNo#&actioncode=#url.actioncode#','boxaction#url.PersonNo#')
	</script>	
</cfoutput>	  