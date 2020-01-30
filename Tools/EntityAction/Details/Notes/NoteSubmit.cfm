
<cfparam name="Form.sendTo"       default="">
<cfparam name="Form.sendCc"       default="">
<cfparam name="Form.ActionCode"   default="">
<cfparam name="Form.DocumentId"   default="">
<cfparam name="Form.DocumentItem" default="">
<cfparam name="Form.MailSubject"  default="">
<cfparam name="Form.MailDate"     default="01/01/2008">
<cfparam name="Form.Priority"     default="">

<cfset dateValue = "">
<CF_DateConvert Value="#Form.MailDate#">
<cfset DTE = dateValue>

<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   OrganizationObjectActionMail
		WHERE  ObjectId  = '#Form.ObjectId#'
		<cfif Form.ThreadId neq "" and Form.SerialNo neq "">
		AND    ThreadId   = '#Form.ThreadId#'
		AND    SerialNo   = '#Form.SerialNo#' 
		<cfelse>
		AND 1 = 0
		</cfif>		
</cfquery>

<cfif check.recordcount eq "0">
	
	<cfif form.threadid neq "">
		  
	   <cfset id = form.threadid>   
	   
	   <cfquery name="Check" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT Max(SerialNo) as Last
				FROM   OrganizationObjectActionMail
				WHERE  ObjectId  = '#Form.ObjectId#'
				AND    ThreadId  = '#Form.ThreadId#'						
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
		SELECT TOP 1 * 
		FROM   OrganizationObjectAction
		WHERE  ObjectId    = '#Form.ObjectId#'
		AND    ActionCode  = '#Form.ActionCode#'		
		ORDER BY Created DESC
	</cfquery>

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
		  '#form.attachid#',
		  '#SESSION.acc#',
		  '#SESSION.last#',
		  '#SESSION.first#')
	</cfquery>
	
	<cfif url.type eq "Mail">
	
		 <cfmail     to= "#form.SendTo#"
	        from       = "#client.eMail#"
			FailTo     = "#client.eMail#" 
	        subject    = "#form.MailSubject#"
	        cc         = "#form.Sendcc#"				
			bcc        = "#Form.SendBcc#"
	        type       = "HTML"
	        mailerID   = "#id#"
	        spoolEnable= "Yes"
			priority   = "#form.priority#">
							
			 <cfoutput>#MailBody#</cfoutput>				
			
		     <cfdirectory action="LIST"
             directory="#SESSION.rootDocumentPath#\#form.entitycode#\#Form.attachid#"
             name="GetFiles"
             sort="DateLastModified DESC"
             type="file"
             listinfo="name">
			
			<cfloop query="getfiles">
				<cfmailparam file="#SESSION.rootDocumentPath#\#form.entitycode#\#Form.attachid#\#name#">
			</cfloop>
			
			<!--- disclaimer --->
			<cf_maildisclaimer context="wfthread" id="#id#">
														
		</cfmail>
	
	</cfif>
	
<cfelse>

	<cfquery name="Edit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE OrganizationObjectActionMail
		SET ActionCode = '#Form.ActionCode#',
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

<cfif url.mode eq "actor">

     <!--- insight portal mode --->
	
	 <script>	   
		 window.dialogArguments.opener.listcontent()
		 window.close()
	 </script>
		
<cfelse>
	
	 <script>		  
	    try {      
		parent.opener.ColdFusion.navigate('#SESSION.root#/tools/entityaction/details/notes/NoteList.cfm?box=#url.box#&mode=#url.mode#&objectid=#Form.ObjectId#&actioncode=#Form.ActionCode#','#url.box#')		
		} catch(e) {}
		window.close()
	 </script>

</cfif>	

</cfoutput>

	
