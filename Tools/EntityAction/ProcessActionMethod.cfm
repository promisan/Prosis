
<!--- performs the defined events --->

<cfparam name="Attributes.MethodName"      default="Submit">  <!--- Submit, Due, Condition --->
<cfparam name="Attributes.Location"        default="Text">    <!--- text, file --->
<cfparam name="Attributes.ActionCode"      default="">
<cfparam name="Attributes.Datasource"      default="AppsOrganization">
<cfparam name="Attributes.ActionPublishNo" default="">
<cfparam name="Attributes.ActionCodeGoTo"  default="">
<cfparam name="Attributes.wfmode"          default="0">
<cfparam name="Attributes.actionid"        default="{00000000-0000-0000-0000-000000000000}">

<cfparam name="url.id" default="{00000000-0000-0000-0000-000000000000}">

<cfset tmpid = url.id>

<cfset form.MethodName = Attributes.MethodName>

<cfquery name="Object" 
 datasource="#attributes.Datasource#"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT TOP 1 O.*, 
		     R.*, 
			 C.EnableEMail as ClassMail
	  FROM   Organization.dbo.OrganizationObject O, 
		     Organization.dbo.Ref_Entity R, 
		     Organization.dbo.Ref_EntityClass C
      WHERE  ObjectId = '#Attributes.ObjectId#'
	  AND    O.EntityCode  = R.EntityCode
	  AND    O.EntityCode  = C.EntityCode 
	  AND    O.EntityClass = C.EntityClass  
	  ORDER BY O.Operational DESC 

	  /* originally this was the query but it was resetting the object ant thus fields like EnableEmail were not found
	 SELECT TOP 1 *
	 FROM Organization.dbo.OrganizationObject
	 WHERE ObjectId = '#Attributes.ObjectId#'
	 ORDER BY Operational DESC  
	 */
</cfquery>

<cfquery name="Action" 
 datasource="#attributes.Datasource#"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT TOP 1 *
	 FROM Organization.dbo.OrganizationObjectAction
	 WHERE ActionId = '#Attributes.ActionId#'
</cfquery>

<cfset ActionId        = Attributes.ActionId>
<cfset Location        = Attributes.Location>
<cfset ActionCode      = Attributes.ActionCode>
<cfset ActionPublishNo = Attributes.ActionPublishNo>
<cfset ActionCodeGoTo  = Attributes.ActionCodeGoTo>

<cfoutput>
<cfif attributes.wfmode eq "8">
   <cfset ret = "ajax">
   <cfset loc = "ProcessAction8Step.cfm?wfmode=8&process=#URL.process#&id=#url.id#&ajaxid=#url.ajaxid#">
<cfelse>
   <cfset ret = "back"> 
   <cfset loc = "">  
</cfif>
</cfoutput>

<cfset dsn = "AppsOrganization">

<cfif ActionCodeGoTo eq "">

		<!--- regular method --->
		
		<cfquery name="Method" 
		 datasource="#attributes.Datasource#"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT *, 
		        '0' as ConditionMemo 
		 FROM   Organization.dbo.Ref_EntityActionPublish 
		 WHERE  ActionCode      = '#preservesinglequotes(ActionCode)#' 
		 AND    ActionPublishNo = '#ActionPublishNo#' 		 
       </cfquery>
	   
<cfelse>

		<!--- special goto methods --->
		<cfquery name="Method" 
		 datasource="#attributes.Datasource#"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT * 
		 FROM   Organization.dbo.Ref_EntityActionPublishProcess  
		 WHERE  ActionCode      = '#preservesinglequotes(ActionCode)#'
		 AND    ActionPublishNo = '#ActionPublishNo#' 	
		 AND    ProcessClass = 'GoTo'
		 AND    ProcessActionCode = '#ActionCodeGoTo#'	
       </cfquery>
	   
	   <cfset dsn = Method.ConditionDataSource>

</cfif>

<cfif Method.recordcount eq "1">
	
	<cfswitch expression="#Attributes.MethodName#">	  
	   		
		<cfcase value="Due">
		
			    <!--- perform status update action --->
				
				<cfif Method.DueEntityStatus neq "">
								
					<cfquery name="Check" 
					 datasource="#attributes.Datasource#"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 SELECT * 
					 FROM   Organization.dbo.Ref_EntityStatus
					 WHERE  EntityCode   = '#Object.EntityCode#'
					 AND    EntityStatus = '#Method.DueEntityStatus#'					 	
				    </cfquery>
					
					<cfif check.recordcount eq "1">									
				
						<cfquery name="SetObject" 
						 datasource="#attributes.Datasource#"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 UPDATE Organization.dbo.OrganizationObject
						 SET EntityStatus = '#Method.DueEntityStatus#'
						 WHERE ObjectId   = '#Attributes.ObjectId#' 				
					    </cfquery>
						
						<cfquery name="doc" 
						 datasource="#attributes.Datasource#"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT TOP 1 *
						 FROM   Organization.dbo.Ref_Entity
						 WHERE  EntityCode = '#Object.EntityCode#' 
						</cfquery>
						
						<!--- try updating master table --->
						
						<cftry>	
										
							<cfquery name="Update" 
							 datasource="#dsn#"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								 UPDATE #doc.EntityTableName#
								 SET ActionStatus = '#Method.DueEntityStatus#' 
								 WHERE 1=1 
								 <cfif doc.EntityKeyField1 neq "" and doc.EntityKeyField4 eq "">
								 AND #doc.EntityKeyField1# = '#object.ObjectKeyValue1#'
								 </cfif>
								 <cfif doc.EntityKeyField2 neq "">
								 AND #doc.EntityKeyField2# = '#object.ObjectKeyValue2#'
								 </cfif>
								 <cfif doc.EntityKeyField3 neq "">
								 AND #doc.EntityKeyField3# = '#object.ObjectKeyValue3#'
								 </cfif>
								 <cfif doc.EntityKeyField4 neq "">
								 AND #doc.EntityKeyField4# = '#object.ObjectKeyValue4#'
								 </cfif> 
							</cfquery>
							
							<cfcatch></cfcatch>
						
						</cftry>
												
						
						<cftry>	
																
							<cfquery name="Update" 
							 datasource="#dsn#"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								 UPDATE #doc.EntityTableName#
								 SET Status = '#Method.DueEntityStatus#' 
								 WHERE 1=1 
								 <cfif doc.EntityKeyField1 neq "" and doc.EntityKeyField4 eq "">
								 AND #doc.EntityKeyField1# = '#object.ObjectKeyValue1#'
								 </cfif>
								 <cfif doc.EntityKeyField2 neq "">
								 AND #doc.EntityKeyField2# = '#object.ObjectKeyValue2#'
								 </cfif>
								 <cfif doc.EntityKeyField3 neq "">
								 AND #doc.EntityKeyField3# = '#object.ObjectKeyValue3#'
								 </cfif>
								 <cfif doc.EntityKeyField4 neq "">
								 AND #doc.EntityKeyField4# = '#object.ObjectKeyValue4#'
								 </cfif> 
							</cfquery>
							
							<cfcatch></cfcatch>
						
						</cftry>
									
					</cfif>
								
				</cfif>
														
				<cfif location eq "Text">
				
					<!--- check if record is found --->
				
					<cfquery name="Script" 
					 	datasource="#attributes.Datasource#"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT TOP 1 *
						 FROM      Organization.dbo.Ref_EntityActionPublishScript R
						 WHERE     R.ActionPublishNo = '#ActionPublishNo#' 
						 AND       R.ActionCode      = '#ActionCode#' 
						 AND       R.Method          = 'Due'
						 AND       MethodEnabled = 1
					</cfquery>					
					
					<cfif TRIM(Script.MethodScript) neq "">
					
						<cfset val         = "#Script.MethodScript#">
						<cfset dsn         = "#script.MethodDataSource#">
						
						<cfinclude template= "ProcessActionSubmitScript.cfm">						
						
					<!--- check the table instead --->						
				
					</cfif>					
					
				
				<cfelse>
							
						<cfquery name="Script" 
					 	datasource="#attributes.Datasource#"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT TOP 1 *
						 FROM      Organization.dbo.Ref_EntityActionPublishScript R
						 WHERE     R.ActionPublishNo = '#ActionPublishNo#' 
						 AND       R.ActionCode      = '#ActionCode#' 
						 AND       R.Method          = 'Due'
						 AND       MethodEnabled = 1
						</cfquery>
						
						<cfif Script.recordcount eq "1" and Script.documentId neq "">
							
							<cfquery name="ScriptFile" 
						 	 datasource="#attributes.Datasource#"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								SELECT *
								FROM      Organization.dbo.Ref_EntityDocument
								WHERE     DocumentId = '#Script.documentId#' 					 
							</cfquery>
																									
							<cfinclude template="../../#ScriptFile.DocumentTemplate#"> 
							
						<cfelse>	
						
							<!--- needs to be phased out used for some templates still 
							
							<cfif FileExists("#SESSION.rootPath#\Tools\Process\EntityAction\#ActionCode#_Submit.cfm")>
								<cfinclude template="../Process/EntityAction/#ActionCode#_Submit.cfm">
							</cfif>	
							
							--->
							
						</cfif>		
									
						
				</cfif>		
												
				
		</cfcase>				

		<cfcase value="Condition">		
				
				<cfif location eq "Text">
				
					<!--- check if record is found --->
				
					<cfquery name="Script" 
					 	datasource="#attributes.Datasource#"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT TOP 1 *
						 FROM      Organization.dbo.Ref_EntityActionPublishScript R
						 WHERE     R.ActionPublishNo = '#ActionPublishNo#' 
						 AND       R.ActionCode      = '#ActionCode#' 
						 AND       R.Method          = 'Condition'
						 AND       MethodEnabled = 1
					</cfquery>					
										
					<cfif TRIM(Script.MethodScript) neq "" and Method.ConditionField gt "a">
					
						<cfset val         = "#Script.MethodScript#">
						<cfset dsn         = "#script.MethodDataSource#">
						
						<cfinclude template= "ProcessActionSubmitScript.cfm">
						
						<cfset field     = evaluate("SQL.#Method.ConditionField#")>					 							  
						<cfset condition = "'#field#' #Method.ConditionValue#">			 
																  
						<cftry>
							  			
							  <cfif evaluate(condition)>						 
							 					 								  
								   <cf_message message = "Problem: #Method.ConditionMessage#"
								          return = "no"
										  location  = "#loc#">
										  
									<!--- return current action as pending --->
									<cfquery name="UpdateStatus" 
										 datasource="AppsOrganization"
										 username="#SESSION.login#" 
										 password="#SESSION.dbpw#">
										 UPDATE OrganizationObjectAction 		
										 SET    ActionStatus = '0' 
										 WHERE  ActionId = '#attributes.actionid#' 
									</cfquery>	  										  
										  
								   <cfabort>
											   
							  </cfif>	
							  
							  <cfcatch>								  
								   <cf_message message = "Condition (#condition#) could not be verified" location  = "#loc#" return = "no">
								   
								   <!--- return current action as pending --->
									<cfquery name="UpdateStatus" 
										 datasource="AppsOrganization"
										 username="#SESSION.login#" 
										 password="#SESSION.dbpw#">
										 UPDATE OrganizationObjectAction 		
										 SET    ActionStatus = '0' 
										 WHERE  ActionId = '#attributes.actionid#' 
									</cfquery>	  
								   
								   <cfabort>	
								   							  
							  </cfcatch>
							  
						</cftry>	  
					
					
					<!--- ------------------------------------------------ --->
					<!--- backward compatibility for data in the old field --->	
					<!--- ------------------------------------------------ --->
					
					<cfelseif Method.ConditionScript neq "" and Method.ConditionField gt "a">
					
						  <cfset val = "#Method.ConditionScript#">
						  
						  <cfinclude template="ProcessActionSubmitScript.cfm">
						  
						  <cfset field     = evaluate("SQL.#Method.ConditionField#")>					 							  
						  <cfset condition = "'#field#' #Method.ConditionValue#">			 
																  
						  <cftry>
							  			
						  	<cfif evaluate(condition)>						 
						 					 								  
							   <cf_message message = "Problem: #Method.ConditionMessage#"
							          return = "#ret#"
									  location  = "#loc#">
									  
								 <!--- return current action as pending --->
									<cfquery name="UpdateStatus" 
										 datasource="AppsOrganization"
										 username="#SESSION.login#" 
										 password="#SESSION.dbpw#">
										 UPDATE OrganizationObjectAction 		
										 SET    ActionStatus = '0' 
										 WHERE  ActionId = '#attributes.actionid#' 
									</cfquery>	  
								   	  
									  
									  
							   <cfabort>
										   
						  	</cfif>	
							  
							  <cfcatch>								  
								   <cf_message message = "Condition (#condition#) could not be verified" location  = "#loc#" return = "#ret#">
								   
								    <!--- return current action as pending --->
									<cfquery name="UpdateStatus" 
										 datasource="AppsOrganization"
										 username="#SESSION.login#" 
										 password="#SESSION.dbpw#">
										 UPDATE OrganizationObjectAction 		
										 SET    ActionStatus = '0' 
										 WHERE  ActionId = '#attributes.actionid#' 
									</cfquery>	  
								   
								   
								   <cfabort>								  
							  </cfcatch>
							  
						 </cftry>		  									
				
					</cfif>	
				
				<cfelse>
							
						<cfquery name="Script" 
					 	datasource="#attributes.Datasource#"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT TOP 1 *
						 FROM      Organization.dbo.Ref_EntityActionPublishScript R
						 WHERE     R.ActionPublishNo = '#ActionPublishNo#' 
						 AND       R.ActionCode      = '#ActionCode#' 
						 AND       R.Method          = 'Condition'
						 AND       MethodEnabled = 1
						</cfquery>
						
						<cfif Script.recordcount eq "1" and Script.documentId neq "">
							
							<cfquery name="ScriptFile" 
						 	 datasource="#attributes.Datasource#"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								SELECT *
								FROM      Organization.dbo.Ref_EntityDocument
								WHERE     DocumentId = '#Script.documentId#' 					 
							</cfquery>
							
							<cfinclude template="../../#ScriptFile.DocumentTemplate#"> 
							
							<cfset field     = evaluate("#Method.ConditionField#")>					 							  
						    <cfset condition = "'#field#' #Method.ConditionValue#">			 
																  
						    <cftry>
							  			
							    <cfif evaluate(condition)>						 
							 					 								  
								   <cf_message message = "Problem: #Method.ConditionMessage#"
								          return = "#ret#"
										  location  = "#loc#">
										  
										   <!--- return current action as pending --->
									<cfquery name="UpdateStatus" 
										 datasource="AppsOrganization"
										 username="#SESSION.login#" 
										 password="#SESSION.dbpw#">
										 UPDATE OrganizationObjectAction 		
										 SET    ActionStatus = '0' 
										 WHERE  ActionId = '#attributes.actionid#' 
									</cfquery>	  
								   

									<script>
										Prosis.busy('No') 
									</script> 

								   
								   <cfabort>
											   
							    </cfif>	
							  
								  <cfcatch>								  
									   <cf_message message = "Condition (#condition#) could not be verified" location  = "#loc#" return = "#ret#">
									   
									    <!--- return current action as pending --->
									<cfquery name="UpdateStatus" 
										 datasource="AppsOrganization"
										 username="#SESSION.login#" 
										 password="#SESSION.dbpw#">
										 UPDATE OrganizationObjectAction 		
										 SET    ActionStatus = '0' 
										 WHERE  ActionId = '#attributes.actionid#' 
									</cfquery>	  
								   
								   
									   <cfabort>								  
								  </cfcatch>
							  
						    </cftry>	  						
													
					  </cfif>		
						
				</cfif>					       
						
				<cfif Method.ConditionMemo eq "1">
				
					<cfif FORM.ActionMemo eq "">
					
						 <cf_message message = "Problem: You must provide a justification for your action in the memo area."
					          return = "no">
							  
							   <!--- return current action as pending --->
									<cfquery name="UpdateStatus" 
										 datasource="AppsOrganization"
										 username="#SESSION.login#" 
										 password="#SESSION.dbpw#">
										 UPDATE OrganizationObjectAction 		
										 SET    ActionStatus = '0' 
										 WHERE  ActionId = '#attributes.actionid#' 
									</cfquery>	  
						
						 <script>
							Prosis.busy('No')
						 </script>		   
						
					     <cfabort>
									
					</cfif>
								
				</cfif>			
				
				<cfif ActionCodeGoTo neq "">
								
						<cfif Method.MailCode neq "">
													
							<!--- query potential document holder for eMail --->
							
							<cfquery name="CheckMail" 
							 datasource="#attributes.Datasource#"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
							 SELECT    *
						     FROM      Organization.dbo.Ref_EntityDocument
						     WHERE     DocumentCode = '#Method.MailCode#' 
							 AND       DocumentType = 'mail'      
							 AND       EntityCode   = '#Object.EntityCode#'  
							</cfquery>
							
							<cfif CheckMail.recordcount eq "1">
							
								<cfparam name = "Form.ActionMailSubject"    default="">
								<cfparam name = "Form.ActionMailPriority"   default="">	
								<cfparam name = "Form.ActionMailBody"       default="">
								<cfparam name = "Form.ActionMailAttachment" default="99999">	
								
								<!--- this method passes default mail settings and has enough
								values to run a linked template to populate mail values
								to, subject, text, att --->
								
								<cfif Form.ActionMailPriority neq "0">
													
								<cf_ProcessMailHolder
									actionId     = "#ActionId#"
									mailobject   = "#CheckMail.DocumentId#"					
									mailType     = "GoTo"
									sendSubject  = "#Form.ActionMailSubject#"	
									sendPriority = "#Form.ActionMailPriority#"							
									sendText     = "#Form.ActionMailBody#"
									sendAtt      = "#Form.ActionMailAttachment#"
									sendAttDoc   = "">		
									
								</cfif>						
											
							</cfif> 
				
						</cfif>
														
				</cfif>	
						
		</cfcase>
	
		<cfcase value="Submission">
		
				<cfif location eq "Text">				
				
				<!--- check if record is found --->
				
					<cfquery name="Script" 
					 	datasource="#attributes.Datasource#"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT TOP 1 *
						 FROM      Organization.dbo.Ref_EntityActionPublishScript R
						 WHERE     R.ActionPublishNo = '#ActionPublishNo#' 
						 AND       R.ActionCode      = '#ActionCode#' 
						 AND       R.Method  IN ('Submit','Submission')
						 AND       MethodEnabled = 1 
					</cfquery>
					
					<cfif TRIM(Script.MethodScript) neq "">
					
					    <cfset dsn         = "#script.MethodDataSource#">
						<cfset val         = "#Script.MethodScript#">
						<cfinclude template= "ProcessActionSubmitScript.cfm">						
					
					</cfif>	
							
				<cfelse>
				
					<cfquery name="Script" 
					 	datasource="#attributes.Datasource#"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT TOP 1 *
						 FROM   Organization.dbo.Ref_EntityActionPublishScript
						 WHERE  ActionCode      = '#ActionCode#'
						 AND    ActionPublishNo = '#ActionPublishNo#' 
						 AND    Method          IN ('Submit','Submission')
						 AND    MethodEnabled = 1
					</cfquery>
							
						<cfif Script.recordcount eq "1" and Script.documentId neq "">
							
							<cfquery name="ScriptFile" 
						 	 datasource="#attributes.Datasource#"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								SELECT *
								FROM      Organization.dbo.Ref_EntityDocument
								WHERE     DocumentId = '#Script.documentId#' 					 
							</cfquery>
																					
							<cfinclude template="../../#ScriptFile.DocumentTemplate#"> 
							
						<cfelse>	
						
							<!--- needs to be phased out used for some templates still --->
							
							<cfif FileExists("#SESSION.rootPath#\Tools\Process\EntityAction\#ActionCode#_Submit.cfm")>
								<cfinclude template="../Process/EntityAction/#ActionCode#_Submit.cfm">
							</cfif>	
							
						</cfif>				
		
				</cfif>
		
		
		</cfcase>
		
		<cfcase value="Deny">
		
				<cfif location eq "Text">
				
					<!--- check if record is found --->
				
					<cfquery name="Script" 
					 	datasource="#attributes.Datasource#"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT TOP 1 *
						 FROM      Organization.dbo.Ref_EntityActionPublishScript R
						 WHERE     R.ActionPublishNo = '#ActionPublishNo#' 
						 AND       R.ActionCode      = '#ActionCode#' 
						 AND       R.Method  IN ('Deny')
						 AND       MethodEnabled = 1
					</cfquery>
					
					<cfif TRIM(Script.MethodScript) neq "">
					
					    <cfset dsn         = "#script.MethodDataSource#">
						<cfset val         = "#Script.MethodScript#">
						<cfinclude template= "ProcessActionSubmitScript.cfm">						
					
					</cfif>	
								
				<cfelse>
				
					<cfquery name="Script" 
					 	datasource="#attributes.Datasource#"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT TOP 1 *
						 FROM   Organization.dbo.Ref_EntityActionPublishScript
						 WHERE  ActionCode      = '#ActionCode#'
						 AND    ActionPublishNo = '#ActionPublishNo#' 
						 AND    Method          = 'Deny'
						 AND    MethodEnabled = 1
					</cfquery>
							
						<cfif Script.recordcount eq "1" and Script.documentId neq "">
							
							<cfquery name="ScriptFile" 
						 	 datasource="#attributes.Datasource#"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								SELECT *
								FROM      Organization.dbo.Ref_EntityDocument
								WHERE     DocumentId = '#Script.documentId#' 					 
							</cfquery>
							
							<cfinclude template="../../#ScriptFile.DocumentTemplate#"> 
																	
						</cfif>				
		
				</cfif>
		
		</cfcase>	
	
	</cfswitch>
	
</cfif>	


<cfset url.id = tmpid>