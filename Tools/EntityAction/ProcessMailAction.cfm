
<cfparam name="subjecttype" default="Notification">

<cfif NextCheck.DueMailCode eq "">	

        <!--- default formatted PERFOM Action mail --->		
  
        <cf_ProcessMailText
			to          = "#to#" 
			accesslevel = "#accesslevel#"
			objectId    = "#Object.ObjectId#"
			actioncode  = "#NextCheck.ActionCode#"
			text        = "#subjecttype#"
			sendAttObj  = "#NextCheck.NotificationAttachment#">
				
<cfelse>

	    <!--- custom action mail using the ProcessMailHolder template to trigger this --->	
			
		<cfquery name="CheckMail" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		    SELECT    P.ActionCode, M.*
		    FROM      Ref_EntityDocument M INNER JOIN
		              Ref_EntityActionPublish P ON M.DocumentCode = P.DueMailCode
		    WHERE     M.DocumentType    = 'mail' 
		    AND       P.ActionCode      = '#NextCheck.ActionCode#'
			AND       P.ActionPublishNo = '#Object.ActionPublishNo#'  
			AND       M.EntityCode      = '#Object.EntityCode#' 
		</cfquery>
		
		<cfparam name="Form.actionMail" default="">
		<cfparam name="ThisAction.PersonMailObjectAttach" default="0">
				
		<cfif CheckMail.recordcount eq "1">		
				
			<cf_ProcessMailHolder
			     sendto      = "#to#"
				 actionId    = "#ActionId#"
				 mailobject  = "#CheckMail.DocumentId#"
				 text        = "#subjecttype#"
				 sendAttObj  = "#NextCheck.NotificationAttachment#">
					
		</cfif>				
			
</cfif>