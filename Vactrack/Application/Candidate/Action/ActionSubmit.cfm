
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
	  
<cfif url.actionid eq "00000000-0000-0000-0000-000000000000">

	<cf_assignId>
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.ActionDateStart#">
	<cfset STR = dateValue>	
	<cfset STR = dateAdd("H",Form.ActionHourStart,STR)>
	<cfset STR = dateAdd("N",Form.ActionMinuteStart,STR)>
	
	<cfquery name="Insert" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO DocumentCandidateReviewAction
				 (ActionId,
				  DocumentNo, 
				  PersonNo,		  
				  ActionCode,
				  DocumentId,
				  ActionMemo,
				  ActionDateStart, 							  
				  ActionStatus,							 
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName)
		  VALUES ('#rowguid#', 
				  '#url.documentNo#',
				  '#url.PersonNo#',		  
				  '#url.ActionCode#',
				  '#Form.DocumentId#',
				  '#Form.ActionMemo#',
				  #STR#,
				  '0',
				  '#SESSION.acc#',
				  '#SESSION.last#',		  
				  '#SESSION.first#')
		</cfquery>
		
		<cfset url.actionid = rowguid>
		
	<!--- send and record mail on the organization object --->

<cfelse>

		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.ActionDateStart#">
		<cfset STR = dateAdd("H",Form.ActionHourStart,STR)>
		<cfset STR = dateAdd("N",Form.ActionMinuteStart,STR)>
		<cfset STR = dateValue>

		<cfquery name="UpdateCandidate" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE DocumentCandidateReviewAction
			SET   ActionDateStart        = #STR#,
			      ActionMemo             = '#Form.actionMemo#'
			WHERE ActionId = '#url.actionid#'				
	    </cfquery>	
	
</cfif>	 

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

<cfparam name="Form.MailTo" default="">
<cfparam name="Form.MailAttachment" default="">

	<cfif Object.recordcount eq "1" and Form.MailTo neq "">

				<cfmail  FROM   = "#Entity.MailFromAddress#"
					TO          = "#Form.MailTo#"
					CC          = ""
					BCC         = ""								
					SUBJECT     = "#Form.MailSubject#"										
					mailerID    = "#SESSION.welcome# Mail Engine"
					TYPE        = "html"
					replyto     = "#client.eMail#"
					priority    = "1"
					spoolEnable = "Yes"			
					wraptext    = "100">											
					#Form.MailBody#		
					
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
							
					<cfif checked.serialno eq "">
					 <cfset next = 1>
					<cfelse>
					 <cfset next = checked.serialno+1> 
					</cfif>		
					
					<!---		
														
					<cfif len(sendcc) gte "200">
					  <cfset addcc = "#left(sendcc, 198)#..">
					<cfelse>
					  <cfset addcc = sendcc>  
					</cfif>		
					
					--->
					
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