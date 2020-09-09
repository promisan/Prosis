
<cf_param name="URL.Type"            default="Comment" type="string">
<cf_param name="URL.ObjectId"        default="Comment" type="string">

<cfparam name="Form.sendTo"         default="">
<cfparam name="Form.sendCc"         default="">
<cfparam name="Form.ActionCode"     default="">
<cfparam name="Form.DocumentId"     default="">
<cfparam name="Form.DocumentItem"   default="">
<cfparam name="Form.MailSubject"    default="">
<cfparam name="Form.MailDate"       default="01/01/2008">
<cfparam name="Form.Priority"       default="">
<cfparam name="Form.MailScope"      default="all">
<cfparam name="Form.Mode"           default="">
<cfparam name="form.MailAddress"    default="">

<cfset dateValue = "">
<CF_DateConvert Value="#Form.MailDate#">
<cfset DTE = dateValue>

<cfquery name="get" 
	datasource="AppscONTROL" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Observation
		WHERE  ObservationId  = '#Form.ObjectId#'		
</cfquery>

<cfquery name="Object" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   OrganizationObject
		WHERE  ObjectId  = '#Form.ObjectId#'		
</cfquery>

<cfquery name="Entity" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT      *				
	FROM        Ref_Entity
	WHERE       EntityCode = '#Object.EntityCode#'	
</cfquery>

<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   OrganizationObjectActionMail
		WHERE  ObjectId  = '#Form.ObjectId#'
		AND    MailType = 'Comment'
		<cfif Form.ThreadId neq "" and Form.SerialNo neq "">
		AND    1 = 0
		<!---
		AND    ThreadId   = '#Form.ThreadId#'
		AND    SerialNo   = '#Form.SerialNo#' 
		--->
		<cfelse>
		AND    1 = 0
		</cfif>		
</cfquery>

<cfif check.recordcount eq "0">
	
	<cfif form.threadid neq "">
		  
	   <cfset id = form.threadid>   
	   
	   <cfquery name="Check" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT MAX(SerialNo) as Last
				FROM   OrganizationObjectActionMail
				WHERE  ThreadId  = '#Form.ThreadId#'										
	   </cfquery>			
		  
	   <cfif Check.last gte "1">
	      <cfset ser = check.last+1>
	   <cfelse>
	      <cfset ser = 1>	  
	   </cfif>	 	      
	   
	<cfelse>
	
	   <cf_assignid>
	   <cfset id = rowguid>	
	   <cfset ser = 1>
	   
	</cfif>
	
	<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 * 
		FROM     OrganizationObjectAction
		WHERE    ObjectId    = '#Form.ObjectId#'
		AND      ActionCode  = '#Form.ActionCode#'		
		ORDER BY Created DESC
	</cfquery>
	
	<cfquery name="getPrior" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   * 
		FROM     OrganizationObjectActionMail
		WHERE    ObjectId = '#Form.Objectid#'
		<cfif check.recordcount eq "1">
		AND      ActionId = '#Check.actionId#'
		</cfif>
		<cfif Form.MailScope eq "all">
	    AND      MailScope = 'all'
		</cfif>	
		AND      MailType = 'Comment'	
		ORDER BY Created DESC
	</cfquery>	
	
	<cfset att = evaluate("FORM.#attbox#_attachsubdir")>		
		
	<cfquery name="Insert" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO  OrganizationObjectActionMail
			( ThreadId,
			  SerialNo,
			  ObjectId,
			  ActionCode,
			  <cfif check.recordcount eq "1">
			  ActionId,
			  </cfif>
			  <cfif form.documentitem neq "">
			  DocumentId,
			  DocumentItem,
			  </cfif>
			  MailScope,
			  MailType,
			  <cfif url.type eq "Notes">
			  MailDate,
			  </cfif>
			  MailFrom,
			  MailTo,
			  MailCc,
			  MailSubject,
			  MailBody,		
			  Priority, 
			  ActionStatus,
			  AttachmentId,
			  OfficerUserId,
			  OfficerLastName,
			  OfficerFirstName)
		VALUES 
			( '#id#',
			  '#ser#',
			  '#Form.ObjectId#',
			  '#Form.ActionCode#',
			  <cfif check.recordcount eq "1">
			  '#Check.actionId#',
			  </cfif>
			  <cfif form.documentitem neq "">
			  '#Form.documentId#',
			  '#Form.DocumentItem#',
			  </cfif>
			  '#Form.MailScope#',
			  '#URL.type#',		  
			  <cfif url.type eq "Notes">
			  #DTE#,
			  </cfif>
			  '#client.eMail#',
			  '#Form.SendTo#',
			  '#Form.SendCC#',
			  '#Form.MailSubject#',
			  '#Form.MailBody#',
			  '#form.Priority#',
			  '1',
			  '#att#',
			  '#SESSION.acc#',
			  '#SESSION.last#',
			  '#SESSION.first#')
			 
	</cfquery>	
	
	
	<cfquery name="getFlyActors" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  U.eMailAddress,
				U.Account AS UserAccount, 
				U.FirstName, 
				U.LastName	
		FROM    System.dbo.UserNames U 		
		<cfif form.MailAddress neq "">		
		WHERE 	U.Account IN (#preserveSingleQuotes(Form.MailAddress)#)
		<cfelse>
		WHERE    1=0
		</cfif>
		AND     U.eMailAddress != ''
		AND     U.Pref_WorkFlowMailAccount IN ('Primary','Both')
		
		UNION ALL
		
		SELECT  U.eMailAddressExternal as eMailAddress,
				U.Account AS UserAccount, 
				U.FirstName, 
				U.LastName		
		FROM    System.dbo.UserNames U 				
		<cfif form.MailAddress neq "">
		WHERE 	U.account IN (#preserveSingleQuotes(Form.MailAddress)#)
		<cfelse>
		WHERE    1=0
		</cfif>
		AND     U.eMailAddress != ''
		AND     U.Pref_WorkFlowMailAccount IN ('Secundary','Both')
			
	</cfquery>		
		
	<cfparam name="form.Mode" default="0">
			
	<cfset maillist = valuelist(getFlyActors.eMailAddress)>
	<cfif isValid("email",Object.PersonEMail) and Form.MailScope neq "Support">
		<cfset maillist = "#maillist#,#Object.PersoneMail#">
	</cfif>	
	
	<cfif getFlyActors.recordcount gte "1">
	
		<cfquery name="Attachment" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
		    FROM      System.dbo.Ref_Attachment
			WHERE     DocumentPathName = '#Object.entitycode#'	
		</cfquery>
		
		<cfif attachment.recordcount eq "1">
		    <cfset DocumentHost = Attachment.DocumentFileServerRoot>
		<cfelse>
			<cfset DocumentHost = SESSION.rootDocumentPath>
		</cfif>
		
		<cfif form.Mode eq "Mail">		
						
			<cfoutput>
			
			<cfif entity.MailFromAddress eq "">
				<cfset fromm = client.eMail>
			<cfelse>
				<cfset fromm = Entity.MailFromAddress>
			</cfif>
				
			 <cfmail to    = "#maillist#"
		        from       = "#fromm#"											
				replyto    = "NOREPLY"
		        subject    = "RESPONSE on #Object.ObjectReference#"	       			
				bcc        = "#client.eMail#"
		        type       = "HTML"
		        mailerID   = "#id#"
		        spoolEnable= "Yes"
				priority   = "#Form.Priority#">
				
				<table width="100%">
				<tr><td>				
					<!--- workflow object --->
					<cf_mailworkflowobject context="comment" objectid="#url.ObjectId#">				
				</td></tr>
				
				<cfif get.RequestName neq "">				
				
					<tr><td height="5" border="0"></td></tr>				
					<tr>
						<td style="padding-left:10px"><font face="Verdana" size="2" color="808080"><B>#get.RequestName#</td>
					</tr>
					<tr><td style="border-top:1px solid silver;"></td></tr>
					<tr>
						<td style="padding-left:10px"><font face="Verdana" size="2" color="808080">#get.ObservationOutline#</td>
					</tr>								
					
				
				</cfif>
				
				<tr><td style="border:1px solid silver" border="1"></td></tr>
				<tr>
					<td style="padding-top:5px;padding-bottom:5px;padding-left:10px"><font face="Verdana" size="3" color="6688AA">#Form.MailBody#</td>
				</tr>
				
				<!--- other messages under this action --->
				
				<cfloop query="getPrior">
				
					<tr><td style="border-top:1px solid silver" border="1"></td></tr>
					<tr>
						<td style="padding-left:10px"><font face="Verdana" size="2"><b>From:</b> #officerfirstname# #officerlastname#</td>
					</tr>
					<tr>
						<td style="padding-left:10px"><font face="Verdana" size="2"><b>Sent:</b> #dateformat(created,"DDDD")#, #dateformat(created,"MMM DD YYYY")# #timeformat(created,"HH:MM")#</td>
					</tr>
					<tr>
						<td style="background-color:eaeaea;padding-top:5px;padding-bottom:5px;padding-left:10px"><font face="Verdana" size="2">#ParagraphFormat(MailBody)#</td>
					</tr>			
				
				</cfloop>	
												
				<tr><td style="border-top:1px solid silver" border="1"></td></tr>
				
				<tr><td height="6"></td></tr>
				<tr>
					<td align="center"><b><font face="Verdana" size="2" color="808080">DO NOT REPLY TO THIS EMAIL INSTEAD OPEN THE LINK</b></td>
				</tr>				
				<tr><td height="6"></td></tr>
																
				<tr><td>				
					<!--- disclaimer --->
					<cf_maildisclaimer context="wfthread" id="#id#">				
				<tr><td>
				
				</table>
				
				
										
				<cfdirectory action="LIST"
		             directory="#documentHost#\#Object.entitycode#\#att#"
		             name="GetFiles"
		             sort="DateLastModified DESC"
		             type="file"
		             listinfo="name">
				
				<cfloop query="getfiles">
					<cfmailparam file="#documentHost#\#Object.entitycode#\#att#\#name#">
				</cfloop>
															
			</cfmail>
									
			</cfoutput>
								
		</cfif>					
			
	</cfif>	
				
	<!--- we reset the attach id --->
	<cf_assignid>
	
	<cfoutput>
		<script>
			document.getElementById('#url.attbox#_attachsubdir').value = '#rowguid#'
			document.getElementById('att_#url.attbox#_refresh').click()
		</script>
	</cfoutput>
	
<cfelse>

	<cfquery name="Edit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE OrganizationObjectActionMail
		SET    ActionCode = '#Form.ActionCode#',
		       MailSubject = '#Form.MailSubject#'
			<cfif url.type neq "Exchange">
			   ,MailBody    = '#Form.MailBody#' 
			</cfif>
			   ,MailDate=#DTE#
		<cfif form.documentitem neq "">
		       ,DocumentId   = '#Form.documentId#'
		       ,DocumentItem = '#Form.DocumentItem#'
		</cfif>
		WHERE  ObjectId  = '#Form.ObjectId#'
		AND    ThreadId   = '#Form.ThreadId#'
		AND    SerialNo   = '#Form.SerialNo#'
	</cfquery>
	
</cfif>	

<cfoutput>

<cfset vURLObjectId = replace(url.objectId,"-","","ALL")>

<script language="JavaScript">
  
   // refresh view
   
 	_cf_loadingtexthtml='';	  
   	ptoken.navigate('#session.root#/Tools/EntityAction/Details/Comment/CommentListingContent.cfm?objectid=#form.objectid#','communicatecomment_#vURLObjectId#')
   
   // refresh document attachments
   
    
   // refresh textbox
   CKEDITOR.instances['MailBody'].setData( '');

   // document.getElementById("MailBody").setData('')

</script>

</cfoutput>