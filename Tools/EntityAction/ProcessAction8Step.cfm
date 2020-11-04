
<cfparam name="url.wfmode" default="8">
<cfparam name="url.windowmode" default="window">

<cfquery name="Action" 
  datasource="AppsOrganization"
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
   SELECT *
   FROM   OrganizationObjectAction OA, 
          Ref_EntityActionPublish P,
		  Ref_EntityAction A		
   WHERE  ActionId = '#URL.ID#' 
   AND    OA.ActionPublishNo = P.ActionPublishNo
   AND    OA.ActionCode = P.ActionCode  
   AND    OA.ActionCode = A.ActionCode 
</cfquery>
		
<cfset CLIENT.prepS = now()>

<cfquery name="Object" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
   SELECT *
   FROM   OrganizationObject O, Ref_Entity R		
   WHERE  ObjectId = '#Action.ObjectId#' 
   AND    O.EntityCode = R.EntityCode
   AND    O.Operational  = 1
</cfquery>
	
<cfoutput query="Action">	

	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" bgcolor="ffffff">
	
    <tr><td height="6"></td></tr>
     		
	<tr><td>
		
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" bgcolor="ffffff">
	
	<cfquery name="EmbedFlow" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
		SELECT *
		FROM   Ref_EntityClass
		WHERE  EntityCode  = '#Object.EntityCode#'
		AND    EntityClass = '#Action.EmbeddedClass#' 
		AND    EmbeddedFlow = '1'
	</cfquery>
	
	<cfquery name="EmbedCompleted" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
		SELECT TOP 1 *
		FROM   OrganizationObject O, OrganizationObjectAction A
		WHERE  O.ObjectId = A.ObjectId
		<!--- both value4 and objectid are the same 
		AND    O.ObjectKeyValue4 = '#URL.ID#'		
		--->
		AND    O.ObjectId        = '#URL.ID#'
		ORDER BY A.ActionStatus
	</cfquery>
	
	<!--- if there is an embedded workflow for this action, show the action for the workflow instead --->	

	<cfquery name="Script" 
	 	datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT TOP 1 IsNull(MethodScript,'') as MethodScript
		 FROM      Ref_EntityActionPublishScript R
		 WHERE     R.ActionPublishNo = '#Action.ActionPublishNo#' 
		 AND       R.ActionCode      = '#Action.ActionCode#' 
		 AND       R.Method          = 'Embed'
		 AND       MethodEnabled = 1
	</cfquery>
			
	<!--- define if condition for embedded workflow would work --->
	<cfset embed = "0">
	<cfset conembed = "1">

	<cfif Script.recordcount eq "1" and TRIM(Script.MethodScript) neq "">
					
			<cfset val         = "#Script.MethodScript#">
			<cfinclude template= "ProcessActionSubmitScript.cfm">
			
			<cftry>
														
			<cfif SQL.recordcount eq "0">
						
				<!--- condition is not met --->
				<cfset conembed = "0">							
							
			</cfif>
			
			<cfcatch>
				<cfset conembed = "0">		
			</cfcatch>
			
			</cftry>
									
	</cfif>

	<!--- check if class exists and object has NOT been completed --->
		
	<cfif Embedflow.recordcount eq "1" and conembed eq "1" and 
		(EmbedCompleted.recordcount eq "0" or EmbedCompleted.ActionStatus eq "0")>
								
		    <!--- embedded workflow is not completed --->
		    <cfset embed = "2">
				
	<cfelseif Embedflow.recordcount eq "1" and conembed eq "1" and 
			EmbedCompleted.recordcount eq "1" and
			EmbedCompleted.ActionStatus gte "2">	
				
			<!--- embedded workflow is completed --->				
			<cfset embed = "1">
												
	</cfif>		
	
	<!--- if there is an embedded workflow for this action, show the action for the workflow instead --->	
			
	<cfif EmbedFlow.recordcount eq "1" and EmbedCompleted.ActionStatus eq "0" and embed neq "0">
	
			<tr><td colspan="2" id="#URL.AjaxId#">
			
							  
			 <cfset link = "#Object.ObjectURL#">
									
				<cf_ActionListing 
					EntityCode       = "#Object.EntityCode#"
					EntityClass      = "#Action.EmbeddedClass#"
					EntityGroup      = "#Object.EntityGroup#"
					EntityStatus     = "#Object.EntityStatus#"
					Mission          = "#Object.mission#"
					OrgUnit          = "#Object.orgunit#"
					PersonNo         = "#Object.PersonNo#" 
					PersonEMail      = "#Object.PersonEMail#"
					ObjectReference  = "#Object.ObjectReference#"
					ObjectReference2 = "Embedded workflow"
					ObjectKey4       = "#URL.ID#"
					ObjectURL        = "#link#"
					Show             = "Yes"
					AjaxId           = "#URL.AjaxId#"
					Toolbar          = "Yes"
					Framecolor       = "ECF5FF"
					CompleteFirst    = "No">
						
			</td></tr>
	
	<cfelse>
	
		<!--- usual process dialog 
		   1. for pending, forward
		   2. granting access to next steps if defined on the workflow
		   3. memo
		   4. custom fields
		   5. functional dialog costing etc.
		--->	
			
		<tr><td colspan="2">
					
		<cfform action="ProcessActionSubmit.cfm?windowmode=#url.windowmode#&wfmode=8&process=#URL.Process#&ID=#URL.ID#&ajaxId=#url.ajaxid#" 
		  name="processaction"  id="processaction">		
		  
		  <table width="100%">
		   					 	
			<cfset wfmode = "8">	 		  		
			<cfif ActionType eq "Action">
			   <cfinclude template="ProcessActionAction.cfm"> 
			<cfelse>
			   <cfinclude template="ProcessActionDecision.cfm">
	    	</cfif>		
					
			 <cfif EmbedFlow.recordcount eq "1" and embed neq "0">
			
				<cfset link = "#Object.ObjectURL#">				
											
				<cf_ActionListing 
					EntityCode       = "#Object.EntityCode#"
					EntityClass      = "#Action.EmbeddedClass#"
					EntityGroup      = "#Object.EntityGroup#"
					EntityStatus     = "#Object.EntityStatus#"
					Mission          = "#Object.mission#"
					OrgUnit          = "#Object.orgunit#"
					PersonNo         = "#Object.PersonNo#" 
					PersonEMail      = "#Object.PersonEMail#"
					ObjectReference  = "#Object.ObjectReference#"
					ObjectReference2 = "Embedded workflow"
					ObjectKey4       = "#URL.ID#"
					ObjectURL        = "#link#"
					Show             = "Yes"
					AjaxId           = "#URL.AjaxId#"
					Toolbar          = "Yes"
					Framecolor       = "ECF5FF"
					CompleteFirst    = "No"
					CloseBox         = "1">
				
			 </cfif>	
			
		   </td></tr>
		  						
		   <cfif entityaccess eq "EDIT">	
		   
			   <cfset url.objectid = action.ObjectId>
			   	
			   <tr><td colspan="2" id="stepflyaccess">
				   <cfinclude template="ActionListingFly.cfm">				 	   			   
			   </td></tr>
		   
		    </cfif> 
		   		   
		   <cfparam name="w" default="184">  
		   	    	   	   	   	     
		   <cfif Action.EnableAttachment eq "1">
		   			  			   
			   <tr><td colspan="2" style="height:2px"></td></tr>
			   	   
			   <tr class="line">
			   			   			  
				   <td width="<cfoutput>#w#</cfoutput>" height="35" style="padding-left:9px" class="labelmedium"><cf_tl id="Other attachment(s)">:</td>
				   <td style="width:90%">
			       <table width="97%" cellspacing="0" cellpadding="0">
				   <tr><td>
				   <cfset mode         = "edit">
				   <cfset box          = "att#currentrow#">
				   <cfset script       = "no">
				   <cfset EntityCode   = "#Object.EntityCode#">
				   <cfset ActionId     = "#Action.ActionId#">				   
					   <cfinclude template = "ProcessActionAttachment.cfm">		 				
				   </td>
				   </TR>
				   </table>
				   </td>
				</tr>   
					   
		   </cfif> 
		   
		   <!---  not a collaborator --->							
		   <cfif entityaccess eq "EDIT" or entityaccess eq "READ">		      	     
			   	     	   				
				<cfinclude template="ProcessActionMemoBase.cfm">
				
		   </cfif>		   
		   
		   
		   <cfif entityaccess eq "EDIT">
				
				 <!--- element 1e of 3 MAIL MEMO --->
		  	   	   
		   		<cfquery name="Mail" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
			   	  SELECT    *
				  FROM      Ref_EntityDocument
				  WHERE     EntityCode = '#Object.EntityCode#' 
				  AND       DocumentType = 'mail' 
				  AND       DocumentMode = 'Edit'
				  AND       DocumentCode IN ('#Action.PersonMailAction#',
				                             '#Action.PersonMailCode#',
											 '#Action.DueMailCode#') 
				</cfquery>
				
				<!--- mail object is defined as editable --->
				
				<cfif mail.recordcount gte "1">											
					
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
								  AA.ActionDenied,
								  AA.ActionProcess,
								  R.MailFrom,
								  R.MailFromAddress,
								  R.EntityDescription,
								  C.EntityClassName
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
						AND       A.ActionId        = '#Action.ActionId#' 	
						AND       O.Operational  = 1
					</cfquery>	
				
					<cfinclude template="ProcessActionMailForm.cfm">
				
				</cfif>			
				  			   
		   	</cfif>	 
						
			</table>
												
			</cfform>	
			
			</td>
		</tr>
		
		<tr><td width="100%" colspan="2">
					   
	   	   <cfform name="formcustomfield" id="formcustomfield" onsubmit="return false"> 	   
			   <cfinclude template="ProcessActionFields.cfm">		   
		    </cfform>
			
	    </td>
	    </tr>    
		
		 <!--- Element 1d of 3 ATTACHMENT DOCUMENT --->		  
				  
	   <cfinclude template="Report/DocumentAttach.cfm">	
				
		<!--- keep outside the BASE form --->
		
		<!--- Element 2 of 3 Embedded Custom dialog Functions --->		
	 	<cfinclude template="ProcessActionFunction.cfm">		
					
		<!--- Element 3 of 3 GENERATE DOCUMENT --->
		<cfinclude template="Report/Document.cfm">  	
		
	</cfif>	 
	
	</table>
	
	</td>
	
	<cfquery name="Function" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	   
	     SELECT    R.*, W.ListingOrder, W.ObjectFilter
		 FROM      Ref_EntityDocument R, Ref_EntityActionPublishDocument  W
		 WHERE     DocumentType = 'function'
		 AND       DocumentCode = 'fmes'
		 AND       R.Operational = 1
		 AND       R.DocumentMode    = 'Embed'
		 AND       R.DocumentId      = W.DocumentId 
		 AND       W.ActionCode      = '#ActionCode#'
		 AND       W.ActionPublishNo = '#Object.ActionPublishNo#' 
		 AND       W.Operational = 1
		 ORDER BY  W.ListingOrder 
	</cfquery>
	
	<cfif function.recordcount eq "1">
	
	<td style="min-width:370px;border-left:1px solid silver" valign="top">
	
	      <cf_divscroll style="height:100%">		  
				<cf_commentlisting objectid="#Object.ObjectId#"  ajax="No">		
		  </cf_divscroll>
		
	</td>
	
	</cfif>
	
	
	
	</tr>			
		   
</table>	   	
	   
</cfoutput>

<cfset ajaxonload("initTextArea")>