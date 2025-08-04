<!--
    Copyright © 2025 Promisan

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

<!--- enter steps initially --->
<!--- define the first step and then loop through to the first decision --->
<!--- once the decision is made, locate the decision, define the next step (YES, NO) and loop further until decision --->

		
<cfquery name="Action" 
	 datasource="#attributes.Datasource#"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT    ActionCode,
	 		   ActionParent,
			   ActionType,
			   EnableNotification,
			   PersonMailCode,
			   PersonMailAction
	 FROM      Organization.dbo.Ref_EntityActionPublish R 
	 WHERE     R.ActionPublishNo = '#ActionPublishNo#' 
	 AND       ActionOrder >= #Order# 
	 ORDER BY  ActionOrder
</cfquery>


<cfset insert = "Yes">
<cfset parent = "">
<cfset row    = 0>

<cfif EntityClass.EnableActionOwner eq "1">
				
	<cfquery name="InsertObject" 
		 datasource="#attributes.Datasource#"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 INSERT INTO Organization.dbo.OrganizationObjectActionAccess
				 (ObjectId,
				  ActionCode,
				  UserAccount,
				  AccessLevel,
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName)
			  
			 SELECT DISTINCT '#objectid#',ActionCode,'#SESSION.acc#','1','#SESSION.acc#','#SESSION.last#','#SESSION.first#'
			 FROM   Organization.dbo.Ref_EntityActionPublish
			 WHERE  ActionPublishNo = '#ActionPublishNo#'
			 AND    DisableOwner = '0'
			 AND    ActionCode NOT IN (SELECT ActionCode
			                           FROM   Organization.dbo.OrganizationObjectActionAccess
						    		   WHERE  ObjectId = '#objectid#'
									   AND    UserAccount = '#SESSION.acc#')
	</cfquery>		
		
</cfif>

<cfset nextactioncode = "">

<cfloop query="Action">

	<cfif parent neq ActionParent>
	   <cfset row = row+1>
	</cfif>
			
	<cfset parent = ActionParent>
	
	<!--- while condition to stop if insert = no --->
	
    <cfif insert eq "Yes">
		
	    <cfif (Attributes.CompleteFirst eq "Yes" or attributes.questionaire eq "Yes") and currentRow eq "1">
				
			<cf_assignId>
										
			<cfquery name="InsertStep" 
				 datasource="#attributes.Datasource#"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 INSERT INTO Organization.dbo.OrganizationObjectAction
				          (<cfif Attributes.OrgUnit neq "">OrgUnit,</cfif> 
						   ObjectId,
						   ActionId,
						   ActionPublishNo,
						   ActionCode, 
						   ActionFlowOrder, 
						   ActionStatus,
						   ActionTakeAction,
						   TriggerActionType,
						   TriggerActionId,
						   TriggerDate,
						   OfficerUserId,
						   OfficerLastName,
						   OfficerFirstName,
						   OfficerDate,
						   CreatedUserId)
				 SELECT    <cfif Attributes.OrgUnit neq "">'#Attributes.OrgUnit#',</cfif>
				           '#objectid#', 
						   '#rowguid#',
						   R.ActionPublishNo,
						   R.ActionCode, 
						   #floword#+#row#, 
						   '0',
						   R.ActionTakeAction,
						   <cfif Trigger neq "">
						      '#triggerType#',
						      '#trigger#',
						      getDate(),
						   <cfelse>
						       NULL,
							   NULL, 
							   NULL,
						   </cfif>
						   '#SESSION.acc#',
						   '#SESSION.last#',
						   '#SESSION.first#',
						   getDate(),
						   '#SESSION.acc#'
				 FROM      Organization.dbo.Ref_EntityActionPublish R 
				 WHERE     R.ActionPublishNo = '#ActionPublishNo#' 
				 AND       R.ActionCode      = '#ActionCode#'
				</cfquery>
				
				<cfif attributes.questionaire eq "Yes">
												
					<!--- questionaire input --->
					
					<cfquery name="Questionaire" 
						datasource="#attributes.Datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    SELECT     D.DocumentId, 
						           D.DocumentCode, 
								   D.DocumentDescription,
								   A.ActionCode
					    FROM       Organization.dbo.Ref_EntityActionDocument A INNER JOIN
					               Organization.dbo.Ref_EntityDocument D ON A.DocumentId = D.DocumentId
					    WHERE     (A.ActionCode = '#actioncode#') AND (D.DocumentType = 'Question')
						<!--- enabled for this workflow --->
						AND        D.DocumentId IN (SELECT DocumentId
						                           FROM   Organization.dbo.Ref_EntityActionPublishDocument 
												   WHERE  ActionPublishNo = '#ActionPublishNo#' 
												   AND    ActionCode      = '#actionCode#' 
												   AND    Operational     = 1)
					    ORDER BY   D.DocumentOrder 
						
					</cfquery>	
					
					<cfset url.objectid = objectid>
					<cfset url.actioncode = actioncode>
					
					<cfloop query="Questionaire">							
						
						<cfquery name="Content" 
						datasource="#attributes.Datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    	SELECT     *								
						    FROM       Organization.dbo.Ref_EntityDocumentQuestion P
						    WHERE      DocumentId = '#documentid#'	
						    ORDER BY   ListingOrder
					    </cfquery>				
						
						<cfloop query="content">					
							
							<cfset url.questionid = questionid>		
							<cfset url.field = "score">				
							<cfset url.formfield = "score_#left(QuestionId,8)#">			
							<!--- save questionaire --->						
							<cfinclude template="ProcessActionQuestionaireSubmit.cfm">
							<cfset url.field = "memo">		
							<cfset url.formfield = "memo_#left(QuestionId,8)#">						
							<!--- save questionaire --->						
							<cfinclude template="ProcessActionQuestionaireSubmit.cfm">
						
						</cfloop>
					
					</cfloop>	
								
				</cfif>
												
				<!--- perform the script action linked to completion of step 1 --->
				
				<cfquery name="Object" 
				 datasource="#attributes.Datasource#"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 SELECT TOP 1 *
					 FROM   Organization.dbo.OrganizationObject
					 WHERE  ObjectId = '#ObjectId#'
					 AND    Operational  = 1
				</cfquery>
				
				<cfset key1     = "#Object.ObjectKeyValue1#">
				<cfset key2     = "#Object.ObjectKeyValue2#">
				<cfset key3     = "#Object.ObjectKeyValue3#">
				<cfset key4     = "#Object.ObjectKeyValue4#">
								
				<!--- do not RUN DUE due script --->		
				
				<!--- disabled running of due script if first action is included, this
				is not good for triggers that should run only when the step
				is reverted.
						
				--->
								
				<cf_ProcessActionMethod
				    methodname       = "Submission"
					datasource       = "#attributes.Datasource#"
					Location         = "Text"
					ObjectId         = "#Object.ObjectId#"
					ActionId         = "#rowguid#"
					actioncode       = "#ActionCode#"
					actionpublishno  = "#ActionPublishNo#">		
					
				<cf_ProcessActionMethod
				    methodname       = "Submission"
					datasource       = "#attributes.Datasource#"
					Location         = "File"
					ObjectId         = "#Object.ObjectId#"
					ActionId         = "#rowguid#"
					actioncode       = "#ActionCode#"
					actionpublishno  = "#ActionPublishNo#">		
				
				<!--- set the step to value = 2 --->
					
				<cfquery name="Update" 
				 datasource="#attributes.Datasource#"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">			 
					 UPDATE Organization.dbo.OrganizationObjectAction 		
					 SET    ActionStatus = '2'
					 WHERE  ActionId = '#rowguid#' 					 
				</cfquery>																				
																														
				<cfset rw = "2">
																							
		<cfelse>
		
				
			<cfif nextactioncode eq "">		
				<cfset nextactioncode = actioncode>
			</cfif>	
		
			<cf_assignId>
			
			<cfquery name="Check" 
				 datasource="#attributes.Datasource#"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT *
				 FROM   Organization.dbo.OrganizationObjectAction
				 WHERE  ObjectId = '#objectid#'
				 AND    ActionFlowOrder = #floword#+#row#
			</cfquery>	  
																
			<cfquery name="InsertSteps" 
				 datasource="#attributes.Datasource#"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 INSERT INTO Organization.dbo.OrganizationObjectAction
				          (<cfif #Attributes.OrgUnit# neq "">OrgUnit,</cfif>  
						   ObjectId,
						   ActionId,
						   ActionPublishNo, 
						   ActionCode, 
						   ActionFlowOrder, 
						   <cfif check.recordcount gte "1">
						   ActionConcurrent,
						   </cfif>
						   ActionTakeAction,
						   TriggerActionType,
						   TriggerActionId,
						   TriggerDate,
						   CreatedUserId)
				 SELECT    <cfif Attributes.OrgUnit neq "">'#Attributes.OrgUnit#',</cfif>
				           '#objectid#', 
						   '#rowguid#',
						   R.ActionPublishNo,
						   R.ActionCode, 
						   #floword#+#row#, 						    
						   <cfif check.recordcount gte "1">
						   1,
						   </cfif>
						   R.ActionTakeAction,
						   <cfif Trigger neq "">
						      '#triggerType#',
						      '#trigger#',
						      getDate(),
						   <cfelse>
						       NULL,
							   NULL, 
							   NULL,
						   </cfif>
						   '#SESSION.acc#'
				 FROM      Organization.dbo.Ref_EntityActionPublish R 
				 WHERE     R.ActionPublishNo = '#ActionPublishNo#' 
				 AND       R.ActionCode      = '#ActionCode#' 
				
				</cfquery>		
				
							
																
				<cfif currentrow eq "1" or (Attributes.CompleteFirst eq "Yes" and currentRow eq "2")>
																
					<!--- run predefined script --->
									
					<cf_ProcessActionMethod
					    methodname       = "Due"
						datasource       = "#attributes.Datasource#"
						Location         = "Text"
						ObjectId         = "#ObjectId#"
						actioncode       = "#ActionCode#"
						actionpublishno  = "#ActionPublishNo#">		
						
					<cf_ProcessActionMethod
					    methodname       = "Due"
						datasource       = "#attributes.Datasource#"
						Location         = "File"
						ObjectId         = "#ObjectId#"
						actioncode       = "#ActionCode#"
						actionpublishno  = "#ActionPublishNo#">	
					
				</cfif>	
								
				<cfset rw = "1">
			
		</cfif>
				
		<!--- now generate action DUE eMail --->
		
		<cfquery name="Object" 
			 datasource="#attributes.Datasource#"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT DISTINCT O.*, OA.OrgUnit, R.*
			 FROM   Organization.dbo.OrganizationObject O, 
			        Organization.dbo.OrganizationObjectAction OA,
					Organization.dbo.Ref_Entity R
			 WHERE  OA.ActionId = '#rowguid#'
			 AND    O.ObjectId = OA.ObjectId
			 AND    O.EntityCode = R.EntityCode    
			 AND    O.Operational  = 1
		</cfquery>		
		
		<cfif Object.enableEMail eq "1">		
		
			<cfif EnableNotification eq "1" 
			    and CurrentRow eq "2" 
				and Attributes.CompleteFirst eq "Yes">
																		
				<cfquery name="NextCheck" 
				 datasource="#attributes.Datasource#"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT    *
				 FROM      Organization.dbo.Ref_EntityActionPublish R 
				 WHERE     R.ActionPublishNo = '#ActionPublishNo#' 
				 AND       ActionCode        = '#ActionCode#' 
				</cfquery>
															
				<cfif Entity.enableEMail eq "1" and NextCheck.NotificationManual eq "0">
							
				    <cfset actionId = rowguid>
					<cfinclude template="ProcessMail.cfm">
					
				</cfif>				
				
			</cfif>
			
		</cfif>
		
		<cfif Object.enableEMail eq "1">

			<!--- 2. generate USER action eMail for currentrow = 1--->	
			<cfif PersonMailAction neq "" and currentrow eq "1"
			    and Attributes.CompleteFirst eq "Yes">
		
				<!--- query potential document holder for eMail --->
				
				<cfquery name="CheckMail" 
				 datasource="#attributes.Datasource#"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT    P.ActionCode, M.*
			     FROM      Organization.dbo.Ref_EntityDocument M INNER JOIN
			               Organization.dbo.Ref_EntityActionPublish P ON M.DocumentCode = P.PersonMailAction
			     WHERE     M.DocumentType = 'mail' 
			     AND       P.ActionCode   = '#ActionCode#' 
			     AND       P.ActionPublishNo = '#Object.ActionPublishNo#'
				 AND       M.EntityCode   = '#Object.EntityCode#' 
				</cfquery>
				
				<cfif CheckMail.recordcount eq "1">
				
					<cf_ProcessMailHolder
					actionId    = "#rowguid#"
					mailType    = "Action"		
					mailobject  = "#CheckMail.DocumentId#">
													
					<cfset actionmail   = "1">
				
				</cfif> 
		
		    </cfif>
							
			<!--- 3. generate USER due email for currentrow =2 --->
							
			<cfif PersonMailCode neq "" 
			    and (currentrow eq "1" or (currentrow eq "2" and Attributes.CompleteFirst eq "Yes"))>
				
			<!--- query potential document holder for eMail --->
				
				<cfquery name="NextCheck" 
				 datasource="#attributes.Datasource#"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT    ActionCode
				 FROM      Organization.dbo.Ref_EntityActionPublish R 
				 WHERE     R.ActionPublishNo = '#ActionPublishNo#' 
				 AND       ActionCode = '#ActionCode#' 
				</cfquery>
				
				<cfquery name="CheckMail" 
				 datasource="#attributes.Datasource#"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT    P.ActionCode, M.*
			     FROM      Organization.dbo.Ref_EntityDocument M INNER JOIN
			               Organization.dbo.Ref_EntityActionPublish P ON M.DocumentCode = P.PersonMailCode
			     WHERE     (M.DocumentType = 'mail') 
			     AND       P.ActionCode = '#NextCheck.ActionCode#'
				  AND      P.ActionPublishNo = '#Object.ActionPublishNo#'
				 AND       M.EntityCode = '#Object.EntityCode#' 
				 </cfquery>
				 
				 <cfif CheckMail.recordcount eq "1">
				 
				 	 <cf_ProcessMailHolder
					  actionId    = "#rowguid#"
					  mailType    = "Due"		
					  mailobject  = "#CheckMail.DocumentId#">
				 											
				</cfif> 
								
			</cfif>	
			
		</cfif>
					
	</cfif>		
				
	<cfif ActionType eq "Decision">
	       <cfset insert = "No">
	</cfif>	
			
</cfloop>
