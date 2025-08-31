<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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