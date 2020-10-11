 <!--- query document holder determined by class --->
 
 <cfparam name="Attributes.actionId"    default="">
 <cfparam name="Attributes.mailobject"  default="">
 <cfparam name="Attributes.mailtype"    default="Action">
 <cfparam name="Attributes.mailfrom"    default="">
 
 <cfparam name="Attributes.sendTo"      default="">
 <cfparam name="Attributes.sendCc"      default="">
 <cfparam name="Attributes.sendBcc"     default="">
 
 <cfparam name="Attributes.sendSubject" default="">
 
 <!--- body text --->
 <cfparam name="Attributes.sendText"     default=""> 
 <cfparam name="Attributes.sendPriority" default="1">
 
 <cfset sendTo         = Attributes.sendTo>
 <cfset sendCc         = Attributes.sendCc>
 <cfset sendBcc        = Attributes.sendBcc>
 <cfset sendSubject    = Attributes.sendSubject>
   
 <!--- provision for the template --->   
 <cfset URL.ID       = "#Attributes.ActionId#">
 <cfset URL.ActionID = "#Attributes.ActionId#">
 
 <cfquery name="Object" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    O.*, 
	          A.ActionCode, 
			  A.TriggerActionType, 
			  A.TriggerActionId,
			  R.PersonClass,
			  AA.ActionDescription,
			  AA.ActionCompleted,
			  R.DocumentPathName,
			  R.MailFrom,
			  R.MailFromAddress,
			  R.EntityDescription,
			  C.EntityClassName,
			  R.EnableEMail,
			  C.EnableEMail as ClassMail
	FROM      OrganizationObject O, 
	          OrganizationObjectAction A,
			  Ref_EntityActionPublish AA,  
			  Ref_Entity R,
			  Ref_EntityClass C
	WHERE     O.ObjectId        = A.ObjectId 
	AND       R.EntityCode      = O.EntityCode
	AND       A.ActionPublishNo = AA.ActionPublishNo 
	AND       A.ActionCode      = AA.ActionCode
	AND       C.EntityCode      = O.EntityCode
	AND       C.EntityClass     = O.EntityClass
	AND       A.ActionId        = '#Attributes.ActionId#' 	
	
</cfquery>	

<cfquery name="Mail" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_EntityDocument
		WHERE     DocumentId = '#Attributes.MailObject#' 
</cfquery>	

<!--- run script to assign variables --->

<cfparam name="mailto"      default="#sendTo#">
<cfparam name="mailsubject" default="">
<cfparam name="mailtext"    default="">

<cfif mailto eq "">
	<cfset mailto = sendTo>
</cfif>

<cfset mailatt = ArrayNew(2)>

<cfif mail.documentTemplate neq "">

    <!--- execute template to retrieve mail attributes that are defined in the template --->	
	<!--- also sets mailatt for custom attachment set in the custom mail itself --->
	<cfinclude template="../../#mail.documentTemplate#">
	
</cfif>

<!--- THEN we also set the attachment of the object defined attachments --->
								
<cfif attributes.sendAttObj eq "1" and Object.DocumentPathName neq "">

		<cfparam name="rw" default="0">
												
		<cf_fileExist
			DocumentPath  = "#Object.DocumentPathName#"
			SubDirectory  = "#Object.ObjectId#" 
			Filter        = ""					
			ListInfo      = "all">		
				
		<cfif filelist.recordcount eq "0">
				
				<cf_fileExist
					DocumentPath  = "#Object.DocumentPathName#"
					SubDirectory  = "#Object.ObjectKeyValue4#" 
					Filter        = ""					
					ListInfo      = "all">		
									
		</cfif>		
								
		<!--- returns a query object filelist --->
				
		<cfloop query="filelist">
		
			<cfquery name="qAttachment" 
			  datasource="AppsSystem" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#"> 
				SELECT * 
				FROM   Attachment
				WHERE  Reference        = '#Object.ObjectId#'
				AND    DocumentPathName = '#Object.DocumentPathName#'
				AND    FileName         = '#name#'							
			</cfquery>
			   
			   <cfif qAttachment.fileStatus neq "9">
			   		
					<cfset rw = rw +1>
					<cfset mailatt[rw][1]="#directory#\#name#">	
					<cfset mailatt[rw][2]="normal">	
					<cfset mailatt[rw][3]="#name#">	
				
			   </cfif>				
		
		</cfloop>					
			
 </cfif>
		
<!--- ---------------------------------------------------------------- --->		
<!--- now we remove attachments that are not selected in the interface --->
<!--- ---------------------------------------------------------------- --->

<cfparam name="form.actionMailAttachment"  default="99999">

<cfif form.actionMailAttachment neq "99999">
	 
	<cfset row = 1>
	<cfloop index="att" from="1" to="#ArrayLen(mailatt)#">
			
		<cfif not find(att,form.actionMailAttachment)>	
			<cfset ArrayDeleteAt(mailatt, row)>			
		<cfelse>
			<cfset row = row+1>	
		</cfif>
	
	</cfloop>

</cfif>

<!--- we continue and complement whatever is needed here --->

<cfif Object.recordcount eq "1">

<!--- ---------------- --->
<!--- ----- FROM ----- --->
<!--- ---------------- --->
   
 <cfquery name="FromAddress" 
  datasource="AppsOrganization"
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
 	SELECT  Own.Description,
            Own.eMailAddress,
			Own.FailToMailAddress
	FROM    OrganizationObject OO INNER JOIN
            Ref_Mission R ON OO.Mission = R.Mission INNER JOIN
            Ref_AuthorizationRoleOwner Own ON R.MissionOwner = Own.Code		
	WHERE   OO.ObjectId = '#Object.ObjectId#'		
 </cfquery>	
 
 <cfquery name="Param" 
  datasource="AppsOrganization"
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
 	SELECT  *
	FROM    System.dbo.Parameter
 </cfquery>	
 
 <cfif attributes.mailfrom neq "">
    <cfset mailFromName  = "">  
	<cfset mailFrom      = "#attributes.mailfrom#">
	<cfset mailReply     = "">  
 <cfelseif Object.MailFrom neq "">
    <cfset mailFromName  = "#Object.MailFrom#">  
	<cfset mailFrom      = "#Object.MailFromAddress#">
	<cfset mailReply     = "">
 <cfelseif client.eMail neq "">
    <cfset mailFromName  = "#SESSION.first# #SESSION.last#">
 	<cfset mailFrom      = "#client.eMail#">
	<cfset mailReply     = "#mailfrom#">
 <cfelseif client.eMailExt neq "">
    <cfset mailFromName  = "#SESSION.first# #SESSION.last#">
    <cfset mailFrom      = "#client.eMailExt#">
	<cfset mailReply     = "#mailfrom#">
 <cfelseif FromAddress.EMailAddress neq "">
 	<cfset mailFromName  = "#FromAddress.Description#">
    <cfset mailfrom      = "#FromAddress.EMailAddress#">  
	<cfset mailReply     = "#mailfrom#">
 <cfelse>
    <cfset mailFromName  = "#Param.DefaultEMail#">
    <cfset mailfrom      = "#Param.DefaultEMail#">  
	<cfset mailReply     = "#mailfrom#">
 </cfif>

<!--- ---------------- --->
<!--- ----- FAIL  ----- --->
<!--- ----------------- ---> 
  
 <cfif FromAddress.FailToMailAddress eq "">
     <cfset fail = Param.DefaultEMail>
 <cfelse>
     <cfset fail = FromAddress.FailToMailAddress>  
 </cfif>
  
<!--- ---------------- --->
<!--- ----- TO   ----- --->
<!--- ---------------- --->


	<cfif sendto eq "">
		
		<cfswitch expression="#Mail.MailTo#">
		
			<cfcase value="Holder">
				
				<cfif Object.PersonEMail neq "">
			
				 	<cfset sendto = Object.PersoneMail>
		 
		 		<cfelseif Object.PersonClass eq "Employee">
		  
			      <cfquery name="Address" 
					datasource="AppsOrganization"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
			  		 SELECT  *
					 FROM    Employee.dbo.Person
					 WHERE   PersonNo = '#Object.PersonNo#' 
				  </cfquery>	
					  
				  <cfset sendto = "#Address.eMailAddress#"> 
			  
				<cfelseif Object.PersonClass eq "Candidate">
		
			 	  <cfquery name="Address" 
					datasource="AppsOrganization"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
			  		 SELECT  *  
					 FROM    Applicant.dbo.Applicant
					 WHERE   PersonNo = '#Object.PersonNo#' 
				  </cfquery>	
					  
				  <cfset sendto = "#Address.eMailAddress#">   
				 				  
			   <cfelse>
			   		
					<!--- should never occur --->	   
			      	<cfset sendto = "vanpelt@promisan.com">  
			  
			   </cfif> 	
			
			</cfcase>
			
			<!--- --------------------------------------- --->
			<!--- we obtain the recipients NEW 25/10/2014 --->
			<!--- --------------------------------------- --->
			
			<cfcase value="Recipient">
						
				<cfquery name="Recipient" 
					datasource="AppsOrganization"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
			  		 SELECT  *
					 FROM    OrganizationObjectRecipient
					 WHERE   Objectid    = '#Object.Objectid#' 					
					 AND     ActionCode  = '#Object.ActionCode#'								 
				</cfquery>	
				 			  
				<cfloop query="Recipient">
				  
				  	<cfif isValid("email", "#eMailAddress#")> 
				  
						 <cfif sendto eq "">
						  <cfset sendto = "#emailaddress#">
						 <cfelse>
						  <cfset sendto = "#sendto#,#emailaddress#">
						 </cfif> 		  
						 
					</cfif>	 
				  
				</cfloop>				  
						
			</cfcase>
			
			<cfcase value="List">
			
				<cfquery name="Address" 
					datasource="AppsOrganization"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
			  		 SELECT  *
					 FROM    Ref_EntityDocumentRecipient
					 WHERE   DocumentId = '#Mail.DocumentId#'
					 <cfif Object.Mission neq ""> 
					 AND     Mission    = '#Object.Mission#' 
					 <cfelse>
					 AND     Mission is NULL
					 </cfif>
					 AND     EntityClass is NULL
					 AND     ActionCode is NULL
					 AND     Operational = 1
					 UNION
					 SELECT  *
					 FROM    Ref_EntityDocumentRecipient
					 WHERE   DocumentId   = '#Mail.DocumentId#' 
					 <cfif Object.Mission neq ""> 
					 AND     Mission      = '#Object.Mission#'
					 <cfelse>
					 AND     Mission is NULL
					 </cfif>
					 AND     EntityClass  = '#Object.EntityClass#'
					 AND     ActionCode   = '#Object.ActionCode#'
					 AND     Operational = 1				 
				  </cfquery>	
				 			  
				  <cfloop query="Address">
				  
				  	<cfif isValid("email", "#eMailAddress#")> 
				  
						 <cfif sendto eq "">
						  <cfset sendto = "#emailaddress#">
						 <cfelse>
						  <cfset sendto = "#sendto#,#emailaddress#">
						 </cfif> 		  
						 
					</cfif>	 
				  
				  </cfloop>
				  
				  <cfif sendto eq "">
				  	<!--- should never occur --->	   
			      	<cfset sendto = "vanpelt@promisan.com"> 
				  </cfif>	 
				  				
			</cfcase>
		
			<cfcase value="Custom">
			
				 <cfquery name="CustomTo" 
					datasource="AppsOrganization"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   *
					FROM     OrganizationObjectInformation
					WHERE    DocumentId = '#Mail.DocumentId#'
					AND      ObjectId     = '#Object.ObjectId#'	  		
				  </cfquery>	
			
				  <cfif CustomTo.DocumentItemValue neq "">
				  
				  	<cfset sendto = "#CustomTo.DocumentItemValue#">  
				  
				  <cfelse>
				  
				  	<!--- should never occur --->	   
			      	<cfset sendto = "vanpelt@promisan.com">  
				  
				  </cfif>
			
			</cfcase>
		
			<cfcase value="Script">
		
				 <!--- assign the value from the assigned script mailto --->	  
				 
				 <cfset sendTo = mailTo>				 
							
			</cfcase>
			
			<cfdefaultcase>
			
				<cfif Mail.MailTo eq "fly">
				
					<cfquery name="Potential" 
						 datasource="AppsOrganization"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">			 	 	 
						 					 
							 SELECT   A.UserAccount, 
							          '1' as AccessLevel,
							          U.eMailAddress, 
									  U.eMailAddressExternal, 
									  U.Pref_WorkFlowMailAccount,
									  U.MailServerAccount,
									  U.MailServerPassword
							 FROM     OrganizationObjectActionAccess A INNER JOIN
									  System.dbo.UserNames U ON A.UserAccount = U.Account
							 WHERE    A.ObjectId      = '#Object.ObjectId#' 					
							 AND      A.AccessLevel   > '0' 
							 AND      U.Disabled = 0
											 	 				  
					</cfquery>
							
				<cfelse>
										
					<cfquery name="Potential" 
						 datasource="AppsOrganization"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">		
						 
						 SELECT Account as UserAccount, *
						 FROM   System.dbo.UserNames U	 	 	 
						 WHERE U.Account IN (
						 
				 
								 SELECT   A.UserAccount
								 FROM     OrganizationAuthorization A 
								 WHERE    A.ClassParameter = '#Object.ActionCode#' 
								 AND      A.GroupParameter = '#Object.EntityGroup#' 
								 AND      A.AccessLevel IN ('0','1')  <!--- '0' = info --->	 								
								 <cfif Object.OrgUnit eq "">
								  AND      (A.Mission = '#Object.Mission#' or A.Mission is NULL)
								 <cfelse>
								 AND     (     
								               (A.OrgUnit       = '#Object.OrgUnit#')
								            OR (A.OrgUnit is NULL and A.Mission = '#Object.Mission#')
									        OR (A.OrgUnit is NULL and A.Mission is NULL)
										 ) 
								 </cfif>		 
								
								 UNION
								 
								 SELECT   A.UserAccount
								 FROM     OrganizationObjectActionAccess A 
								 WHERE    A.ObjectId      = '#Object.ObjectId#' 
								 AND      A.ActionCode    = '#Object.ActionCode#' 
								 AND      A.AccessLevel   > '0' 								 
								 
							)	 
							
						AND U.Disabled      = 0	
										 	 				  
				  </cfquery>
				
				</cfif>
			  
			    <cfset to = "">
				
				<cfloop query="Potential">
				
				    <!--- ------------------------------------------- --->
					<!--- check if user wants to have an eMail at all --->
					<!--- ------------------------------------------- --->
							
					<cfquery name="Notify" 
						 datasource="AppsOrganization"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT   *
						 FROM     System.dbo.UserEntitySetting
						 WHERE    Account     = '#UserAccount#'  
						 AND      EntityCode = '#Object.EntityCode#'
					</cfquery>
					
					<!--- if not record exist we assume the user wants a mail --->
					
					<cfif Notify.EnableMailNotification eq "1" or Notify.recordcount eq "0">
			 
						<cfswitch expression="#Pref_WorkFlowMailAccount#">
						
							<cfcase value="Primary">
							
								<cfif emailaddress neq "">
							
									<cfif to eq "">
									   <cfset to = "#emailAddress#">
									<cfelse>
									   <cfif not find(emailaddress,to)>
									      <cfset to = "#to#, #emailAddress#">
									   </cfif>
									</cfif>  
								
								</cfif> 
							
							</cfcase>
							
							<cfcase value="Secundary">
							
								<cfif emailaddressexternal neq "">
							
									<cfif to eq "">
									   <cfset to = "#emailAddressExternal#">
									<cfelse>
									   <cfif not find(emailAddressExternal,to)>
									       <cfset to = "#to#,#emailAddressExternal#">
									   </cfif>
									</cfif>  
								
								</cfif> 
							
							</cfcase>
							
							<cfcase value="Both">
							
								<cfif emailaddress neq "">
							
									<cfif to eq "">
									   <cfset to = "#emailAddress#">
									<cfelse>
									   <cfif not find(emailaddress,to)>
									      <cfset to = "#to#,#emailAddress#">
									   </cfif>
									</cfif>  
								
								</cfif> 
								
								<cfif emailaddressexternal neq "">
							
									<cfif to eq "">
									   <cfset to = "#emailAddressExternal#">
									<cfelse>
									   <cfif not find(emailAddressExternal,to)>
										   <cfset to = "#to#,#emailAddressExternal#">
									   </cfif>
									</cfif>  
								
								</cfif> 	
							
							</cfcase>
							
						</cfswitch> 
						
				 	</cfif>
					 
				 </cfloop>
					 	
				 <cfset sendTo = To>
					
			</cfdefaultcase>
						
		</cfswitch>
	
	</cfif>
	
		
	<!--- check if user turned off the validation for this entity, 
	if not record is found let it go through --->
	
	<cfquery name="PreventMail" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     System.dbo.UserEntitySetting 
		WHERE    Account IN (SELECT Account 
		                     FROM   System.dbo.UserNames 
							 WHERE  PersonNo = '#Object.PersonNo#')
		AND      EntityCode = '#Object.EntityCode#'
		AND      EnableMailHolder = 0			
	</cfquery>	
	
	<cfquery name="User" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT Account 
		FROM   System.dbo.UserNames 
		WHERE  PersonNo = '#Object.PersonNo#'			
	</cfquery>		
	
	<cfif PreventMail.recordcount gte "1">
	
		<!--- user has EnableMailHolder = 0, the result is 1 record
		which means that mail will be bypassed --->
	
	<cfelseif PreventMail.recordcount eq "0">
	
		<!--- if user has no entry in this table or has an value EnableMailHolder = 1, the result is 0 records
		which means that mail will continued --->
			
		 <cfquery name="Entity" 
			datasource="AppsOrganization"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		  		 SELECT  *  
				 FROM    Ref_Entity
				 WHERE   EntityCode = '#Object.EntityCode#' 
		 </cfquery>	
		 
		 <!--- ----------------------------------- --->
		<!--- OVERRULE EMAIL ADDRESS WITH DEFAULT --->
		<!--- ----------------------------------- --->
		 
		 <cfif entity.MailRecipient neq "">
		 
		     <cfset sendto = entity.MailRecipient>
			 
		 </cfif>
		 
		 <!--- ----------------------------------- --->
		<!--- ------ PRIORITY -------------------- --->
		<!--- ------------------------------------ --->
		   
		 <cfif Attributes.sendPriority neq "">
		 
		     <cfset sendPriority = Attributes.sendPriority>
			 
		<cfelse>
		
			 <cfset sendPriority = Mail.MailPriority>
			 
		 </cfif>
		 
		<!--- ----------------------------------- --->
		<!--- ------------SUBJECT --------------- --->
		<!--- ----------------------------------- ---> 
		
		<cfif attributes.sendSubject neq "">
		
			<!--- user entered information at real time --->
			
			<cfset sendSubject = Attributes.sendSubject>	
		
		<cfelse>
			
			<cfswitch expression="#Mail.MailSubject#">
			
				<cfcase value="Object">
				   <cfset sendSubject = Object.ObjectReference>
				</cfcase>
				
				<cfcase value="Action">
				   <cfset sendSubject = Object.ActionDescription>
				</cfcase>
				
				<cfcase value="Custom">
				
				 <cfinvoke component = "Service.Process.System.Mail"  
				   method           = "MailContentConversion" 
				   objectId         = "#Object.ObjectId#" 	
				   actionId         = "#Object.ActionId#"
				   content          = "#Mail.MailSubjectCustom#"			  
				   returnvariable   = "subject">	  				
				
				   <cfset sendSubject = subject>
				   
				</cfcase>
				
				<cfcase value="Script">
				   <cfset sendSubject = MailSubject>
				</cfcase>
				
			</cfswitch>	
			
		</cfif>	
		
		<!--- ----------------------------------- --->
		<!--- ------------BODY    --------------- --->
		<!--- ----------------------------------- ---> 
		
		<cfif attributes.sendText neq "">
		
			<!--- user entered information at real time --->
			
			<cfset sendBody = Attributes.sendText>	
		
		<cfelse>
		
			<cfswitch expression="#Mail.MailBody#">
					
				<cfcase value="Custom">
												
				  <cfinvoke component = "Service.Process.System.Mail"  
				   method           = "MailContentConversion" 
				   objectId         = "#Object.ObjectId#" 	
				   content          = "#Mail.MailBodyCustom#"			  
				   returnvariable   = "mailtext">	  				 

				  <cfset sendBody = mailtext>
					
				</cfcase>
				
				<cfcase value="Script">
				
				   <!--- obtain from the script --->
				   <cfset sendBody = MailText>
				   
				</cfcase>
				
			</cfswitch>	
		
		</cfif>
				 
		<!--- ----------------------------------- --->
		<!--- ------------ATTACHMENTS ----------- --->
		<!--- ----------------------------------- --->
		       		
		 <cfif sendTo neq "" and sendSubject neq "">
		 
		        <cfparam name="attributes.sendattdoc" default="0">

				<cfif NOT isDefined("mailatt") or NOT isArray(mailatt)>
					<cfset mailatt = ArrayNew(2)>
					<cfset rw = 0>
				<cfelse>
					<cfset rw = ArrayLen(mailatt)>
				</cfif>						
											   
				<!--- atachment of the action --->
		 
		 	    <cfif attributes.sendAttDoc eq "1">
		 				 						
					<cfquery name="Document" 
					 datasource="AppsOrganization"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 SELECT   *
					 FROM     OrganizationObjectActionReport OAR 
					          INNER JOIN Ref_EntityDocument R ON OAR.DocumentId = R.DocumentId
					 WHERE    ActionId  = '#Attributes.ActionId#' 
					</cfquery>
					
					<cfoutput query="Document">
					
					        <cfif DocumentMode eq "AsIs" and DocumentLayout eq "PDF">
							
								<!--- attach the generated and stored PDF version of the document --->
							
								<cfif FileExists("#SESSION.rootDocumentPath#\#documentpath#")>	
							
								    <cfset rw = rw+1>		
									<!--- location of the file --->			
									<cfset mailatt[rw][1] = "#SESSION.rootDocumentPath#\#documentpath#">
									<cfset mailatt[rw][2] = "normal">
									
								</cfif>
													
							<cfelseif DocumentLayout eq "PDF">
							
								<!--- attach and or embed HTML version of the document, the embedding
								 is defined by a parameter --->
								 
								<!--- NOTE : optional we can also convert this to PDF on the fly and attach it --->  
							
								<cfset rw = rw+1>
															  
								<cfdocument format="PDF"
								filename = "#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#DocumentDescription#.pdf" 
								overwrite = "yes">#DocumentContent#</cfdocument>
								
								<!--- location of the file 
								--->			  
								<cfset mailatt[rw][1] = "#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#DocumentDescription#.pdf">
								<cfset mailatt[rw][2] = "normal">
								<cfset mailatt[rw][3] = "#DocumentDescription#.pdf">
								
							<cfelse>
							
								<!--- default on the fly we make a file and attach it --->
							
							    <cfset rw = rw+1>
								
								<cffile action="WRITE" 
						          file="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#DocumentDescription#.htm" 
								  output="#DocumentContent#" 
								  addnewline="Yes" 
								  fixnewline="No">								
								
								<cfset mailatt[rw][1] = "#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#DocumentDescription#.htm">
								<cfset mailatt[rw][2] = "normal">
								<cfset mailatt[rw][3] = "#DocumentDescription#.htm">
																
							</cfif>
					        	
					</cfoutput>
					
					<!--- attention : this was moved as this is object mail 
					
					<cfquery name="qGroup" 
					     datasource="AppsOrganization" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#"> 
						    SELECT   R.DocumentCode		
						    FROM     Ref_EntityDocument R,
								     Ref_EntityActionDocument R1
						    WHERE    R1.ActionCode IN (	SELECT ActionCode
														FROM   OrganizationObjectAction
														WHERE  ObjectId='#Object.ObjectId#'
														AND    ActionId = '#Attributes.ActionId#' )
							AND      R.DocumentId    = R1.DocumentId
							AND      R.DocumentType  = 'Attach'
							AND      R.DocumentMode  = 'Step'
							AND      R.Operational   = 1
							<!--- enabled attachments for for object --->
							AND      R.DocumentId IN (SELECT DocumentId 
							                          FROM   OrganizationObjectDocument
													  WHERE  ObjectId = '#Object.ObjectId#'
													  AND    Operational = 1) 
							ORDER BY DocumentOrder
					</cfquery>					
		
					<cfloop query = "qGroup">
						
						<cfquery name="qAttachments" 
						 datasource="AppsSystem" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#"> 
							SELECT * 
							FROM   Attachment
							WHERE  Reference = '#Object.ObjectId#'
							AND    FileName LIKE '#qGroup.DocumentCode#_%'
							AND    FileStatus ! = '9'
						</cfquery>
					
						<cfloop query="qAttachments">
						
							<cfset rw = rw +1>
							<cfset mailatt[rw][1]="#qAttachments.Server#\#qAttachments.ServerPath#\#qAttachments.FileName#">
	
						</cfloop>
						
					</cfloop>	
					
					--->			
				
				</cfif>
								
				<!--- --------------------------------------------------------------------------------------------------------------- --->
				<!--- get the atachment of the object : MOVED pro-actively in the form of the mail itself ProcessActionMailForm.cfm-- --->
				<!--- -------------------------------------------Oct 5th 2020-------------------------------------------------------- 
				
				<cfparam name="attributes.sendattobj" default="">
								
				<cfif attributes.sendAttObj eq "1" and Object.DocumentPathName neq "">
													
					<cf_fileExist
						DocumentPath  = "#Object.DocumentPathName#"
						SubDirectory  = "#Object.ObjectId#" 
						Filter        = ""					
						ListInfo      = "all">		
					
					<cfif filelist.recordcount eq "0">
					
					<cf_fileExist
						DocumentPath  = "#Object.DocumentPathName#"
						SubDirectory  = "#Object.ObjectKeyValue4#" 
						Filter        = ""					
						ListInfo      = "all">		
										
					</cfif>		
									
					<!--- returns a query object filelist --->
					
					<cfloop query="filelist">
					
						<cfquery name="qAttachment" 
						  datasource="AppsSystem" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#"> 
							SELECT * 
							FROM   Attachment
							WHERE  Reference        = '#Object.ObjectId#'
							AND    DocumentPathName = '#Object.DocumentPathName#'
							AND    FileName         = '#name#'							
						</cfquery>
						   
						   <cfif qAttachment.fileStatus neq "9">
						   				
								<!--- was not deleted so we attach it to the array  --->
								<cfset rw = rw +1>
								<cfset mailatt[rw][1]="#directory#\#name#">	
							
						   </cfif>				
					
					</cfloop>					
				
				</cfif>
				
				--->
								
				<cfset fromm = "#mailfrom#">
				
				<cfif fromm eq "">
					<cfset fromm = client.eMail>
				</cfif>	

				<cfif mailfromName neq "">				
					<cfset fromm = "#mailfromName# <#mailFrom#>">
				<cfelse>
					<cfset fromm = "#mailfrom#">
				</cfif>
							
				<!--- adjusted the failto for Exchange issue at promisan --->
				
				<!--- Disabling the mailreply address if the system parameter is 0---->
				<cfif Param.ReplyTo eq "0">
					  <cfset mailreply = "">
				</cfif>
				
				<!--- Provision when users separate email addresses with semicolon (;) --->
				<cfset sendTo = replace(sendTo,";",",","ALL")>
				<cfset sendTo = replace(sendTo," ","","ALL")>
				<cfset mailto = sendTo>
				
				<cfset SendCC = replace(SendCC,";",",","ALL")>
				<cfset SendCC = replace(SendCC," ","","ALL")>
				
				<cfset SendBCC = replace(SendBCC,";",",","ALL")>
				<cfset SendBCC = replace(SendBCC," ","","ALL")>
				
								
				<!--- ----------- --->
				<!--- now we send --->
				<!--- ----------- --->
				
				<cfif Mail.MailTo eq "Recipient">
				
					<cfquery name="Recipient" 
					datasource="AppsOrganization"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
			  		 SELECT  *
					 FROM    OrganizationObjectRecipient
					 WHERE   Objectid    = '#Object.Objectid#' 					
					 AND     ActionCode  = '#Object.ActionCode#'								 
				    </cfquery>	
				   
				    <!--- clear if a record already exists for a draft version --->
						
					<cfquery name="Clear" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						DELETE FROM OrganizationObjectActionMail
						WHERE  ObjectId   = '#Object.ObjectId#'
						AND    ActionCode = '#Object.ActionCode#'
						AND    ActionStatus = '9'			
					</cfquery>	
				 			  
					<cfloop query="Recipient">
					  
					  	<cfif isValid("email", "#eMailAddress#")> 
						
							<cfif Reference neq "" and Mail.MailBody eq "script">
							
								<!--- execute template to retrieve localised
								 attributes that are defined in the template based on the reference --->	
								<cfinclude template="../../#mail.documentTemplate#">
								<cfset sendBody    = MailText>
								<cfset sendSubject = MailSubject>
							</cfif> 	
							
							<cfsavecontent variable="sendbody">
								<cfoutput>
									#salutation# #RecipientName#<br>
									#sendBody#
								</cfoutput>
							</cfsavecontent>		
								

							<cfmail  FROM   = "#fromm#"
										TO          = "#eMailAddress#"
										CC          = "#SendCC#"
										BCC         = "#SendBCC#"								
										SUBJECT     = "#sendSubject#"										
										mailerID    = "#SESSION.welcome# Mail Engine"
										TYPE        = "html"
										replyto     = "#fromm#"
										priority    = "#sendPriority#"
										spoolEnable = "Yes"			
										wraptext    = "100">											
										#sendBody#																												
										<!--- try to attach possible documents --->
										
										<cftry>
											 		
											<cfloop index="att" from="1" to="10" step="1">
													   
											   <cfparam name="mailatt[#Att#][1]" default="none">
											   <cfparam name="mailatt[#Att#][2]" default="normal">									   
											   <cfparam name="mailatt[#Att#][3]" default="">											   
											   
											   <cfif mailatt[att][1] neq "none">	
											   	
										            <cfif mailatt[att][2] eq "inline">
													    <cfmailparam file = "#mailatt[att][1]#" contentid="#mailatt[att][3]#" disposition="inline">
													<cfelse>									 
												        <cfmailparam file = "#mailatt[att][1]#">
													</cfif>	
														
												   </cfif>
																		   				  			   
											    </cfloop>
												
											<cfcatch>
											</cfcatch>
											
										</cftry>
																											
							</cfmail>							
							
							<cfquery name="checked" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT   TOP 1 SerialNo
								FROM     OrganizationObjectActionMail
								WHERE    ThreadId = '#Attributes.ActionId#'									
								ORDER BY SerialNo DESC
							</cfquery>
							
							<cfif checked.serialno eq "">
							 <cfset next = 1>
							<cfelse>
							 <cfset next = checked.serialno+1> 
							</cfif>				
														
							<cfif len(sendcc) gte "200">
							  <cfset addcc = "#left(sendcc, 198)#..">
							<cfelse>
							  <cfset addcc = sendcc>  
							</cfif>						
										
							<cfquery name="qCheck" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">					
									SELECT * 
									FROM   OrganizationObjectActionMail
									WHERE  ThreadId = '#Attributes.ActionId#' 
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
													MailFrom,
													MailTo, 
													MailCc,
													MailSubject, 
													MailBody, 
													Priority,													
													OfficerUserId, 
													OfficerLastName, 
													OfficerFirstName)
											VALUES ('#Attributes.ActionId#',
													'#next#', 
													'#Object.ObjectId#',
													'#Object.ActionCode#',
													'#Attributes.ActionId#', 	
													'#User.Account#',
													'#Attributes.MailType#',	
													'#fromm#',		   
													'#eMailAddress#',
													'#addcc#',
													'#sendsubject#',
													'#sendBody#',
													'#sendPriority#',													
													'#SESSION.acc#',
													'#SESSION.last#',
													'#SESSION.first#')
								    </cfquery>	
									
									<!--- record attachement --->									
									
									<cfloop index="att" from="1" to="10" step="1">
													   
									   <cfparam name="mailatt[#Att#][1]" default="none">
									   <cfparam name="mailatt[#Att#][2]" default="normal">									   
									   <cfparam name="mailatt[#Att#][3]" default="">											   
									   
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
						    
						    </cfif>				   
											 
						</cfif>	 
					  
					</cfloop>				
				
				<cfelse>		
												
						<cfmail FROM        = "#fromm#"
								TO          = "#mailto#"
								CC          = "#SendCC#"
								BCC         = "#SendBCC#"								
								SUBJECT     = "#sendSubject#"										
								mailerID    = "#SESSION.welcome# Mail Engine"
								TYPE        = "html"
								replyto     = "#fromm#"
								priority    = "#sendPriority#"
								spoolEnable = "Yes"			
								wraptext    = "100">											
								#sendBody#																
								
								<!--- try to attach possible documents --->
								
								<cftry>
									 		
									<cfloop index="att" from="1" to="10" step="1">											   
									   <cfparam name="mailatt[#Att#][1]" default="none">
									   <cfparam name="mailatt[#Att#][2]" default="none">									   
									   <cfparam name="mailatt[#Att#][3]" default="none">
								   	   <cfif mailatt[att][1] neq "none">	
								            <cfif mailatt[att][2] eq "inline">
											    <cfmailparam file = "#mailatt[att][1]#" contentid="#mailatt[att][3]#" disposition="inline">
											<cfelse>									 
										        <cfmailparam file = "#mailatt[att][1]#">
											</cfif>	
									   </cfif>																	   				  			   
									</cfloop>											
									<cfcatch></cfcatch>
										
								</cftry>
																									
						</cfmail>				
							
					<!--- clear if a record already exists for a draft version --->
				
					<cfquery name="Clear" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						DELETE FROM OrganizationObjectActionMail
						WHERE  ObjectId   = '#Object.ObjectId#'
						AND    ActionCode = '#Object.ActionCode#'
						AND    ActionStatus = '9'			
					</cfquery>	
					
					<cfquery name="checked" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT   TOP 1 SerialNo
						FROM     OrganizationObjectActionMail
						WHERE    ThreadId = '#Attributes.ActionId#'									
						ORDER BY SerialNo DESC
					</cfquery>
					
					<cfif checked.serialno eq "">
					 <cfset next = 1>
					<cfelse>
					 <cfset next = checked.serialno+1> 
					</cfif>				
					<!--- record the action --->
					
					<cfif len(sendto) gt "200">
					  <cfset add = "#left(sendto, 198)#..">
					<cfelse>
					  <cfset add = sendto>  
					</cfif>
					
					<cfif len(sendcc) gte "200">
					  <cfset addcc = "#left(sendcc, 198)#..">
					<cfelse>
					  <cfset addcc = sendcc>  
					</cfif>												
								
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
								MailFrom,
								MailTo, 
								MailCc,
								MailSubject, 
								MailBody, 
								Priority,								
								OfficerUserId, 
								OfficerLastName, 
								OfficerFirstName)
						VALUES ('#Attributes.ActionId#',
								'#next#', 
								'#Object.ObjectId#',
								'#Object.ActionCode#',
								'#Attributes.ActionId#', 
								'#User.Account#',									
								'#Attributes.MailType#',	
								'#fromm#',		   
								'#add#',
								'#addcc#',
								'#sendsubject#',
								'#sendBody#',
								'#sendPriority#',								
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#')
				    </cfquery>		
					
					<!--- record attachement --->									
									
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
					
					<cfif Object.PersonClass eq "Candidate" and Object.personNo neq "">
					
					  <cfquery name="Insert" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO Applicant.dbo.ApplicantMail
							(PersonNo, 
							 MailAddress, 
							 MailAddressFrom, 
							 MailSubject, 
							 MailBody, 
							 MailStatus)
							VALUES ('#Object.personNo#', 
							 	   '#add#',
								   '#mailfrom#',
								   '#sendsubject#', 
								   '#sendBody#',
								   '1')
					  	</cfquery>
					
				  	</cfif>
					
				</cfif>	
						
		  </cfif> 
		  
	</cfif>
	
</cfif>	

