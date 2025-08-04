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
											
	<!--- now process reset action by creating another action record --->
	
	<cfparam name="keepopen" default="">
	<cfparam name="Form.ActionDateInput" default="">
	
	<cfif Form.ActionDateInput neq "">
	
	 	<cfset dateValue = "">
		<CF_DateConvert Value="#Form.ActionDateInput#">
		<cfset DTE = dateValue>
	
	</cfif>
				
	<cfquery name="Update" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		 UPDATE OrganizationObjectAction 		
		 SET <cfif keepopen eq "">	 	 
		     ActionStatus = '#Form.ActionStatus#', 
			 ActionMemo   = '#memotext#',
			 <cfelse>
			 ActionStatus = '1',
			 ActionMemo   = '#keepopen#',
			 </cfif>
			 <cfif Form.ActionStatus eq "1">
			    ActionCodeOnHold = '#Form.ActionCodeOnHold#', 
			 </cfif>
			 OfficerUserId    = '#SESSION.acc#',
			 OfficerLastName  = '#SESSION.last#',
			 OfficerFirstName = '#SESSION.first#', 
			 OfficerDate       = getDate(),
			 <cfif Form.ActionDateInput eq "">				
			  OfficerActionDate = getdate()
			 <cfelse>
			  OfficerActionDate = #DTE#
			 </cfif>
		 WHERE ActionId = '#URL.ID#' 
	</cfquery>		
	
	<!--- ------------------------ --->			
	<!--- USER selected SUBMIT/YES --->
	<!--- ------------------------ --->	
	
	<cfif Form.actionStatus eq "2" or Form.actionStatus eq "2Y">
	
	    <!--- process the submit text --->
		
		<cf_ProcessActionMethod
		    methodname       = "submission"
			location         = "text" 
			ObjectId         = "#Object.ObjectId#"
			ActionId         = "#Action.ActionId#"
			actioncode       = "#Action.ActionCode#"
			actionpublishno  = "#Action.ActionPublishNo#"					
			wfmode           = "#url.wfmode#">																		
											
	<!--- ------------------- --->			
	<!--- USER selected GO TO --->
	<!--- ------------------- --->	
	
	<cfelseif Form.actionStatus eq "1">
	
	        <!--- ------------------------------------------ --->
			<!--- define if the condition for moving was met --->
			<!--- ------------------------------------------ --->
			
			<cf_ProcessActionMethod
		    methodname       = "Condition"
			ObjectId         = "#Object.ObjectId#"
			ActionId         = "#Action.ActionId#"
			actioncode       = "#Action.ActionCode#"
			actionpublishno  = "#Action.ActionPublishNo#"
			actioncodegoto   = "#Form.ActionCodeOnHold#"
			wfmode           = "#url.wfmode#">							
								
			<!--- set current action as completed --->
			<cfquery name="UpdateStatus" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 UPDATE OrganizationObjectAction 		
				 SET    ActionStatus = '2' 
				 WHERE  ActionId = '#URL.ID#' 
			</cfquery>
			
			<!--- remove future actions as workflow is reset --->
						
			<cfquery name="RemovePending" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 DELETE FROM  OrganizationObjectAction 		
			 WHERE  ObjectId = '#Action.ObjectId#'
			 AND    ActionStatus = '0'
			</cfquery>
									
			<!--- Now also add the steps following until the decision if this step = 'action' --->
										
			<cfset trigger      = "#URL.ID#">
			<cfset triggerType  = "SendBack">
			<cfset orgunit      = "#Action.OrgUnit#">
			<cfset pub          = "#Object.ActionPublishNo#">
			<cfset act          = "#Form.ActionCodeOnHold#">
			
			<!--- ------------------------------------- --->						
			<!--- run DUE templates for arriving action --->
			<!--- ------------------------------------- --->	
						
			<cf_ProcessActionMethod
			    methodname       = "Due"
				Location         = "Text"
				ObjectId         = "#Object.ObjectId#"
				ActionId         = "#Action.ActionId#"					
				actioncode       = "#preserveSingleQuotes(act)#"
				actionpublishno  = "#pub#"					
				wfmode           = "#url.wfmode#">												
						
			<cf_ProcessActionMethod
			    methodname       = "Due"
				Location         = "File"
				ObjectId         = "#Object.ObjectId#"
				ActionId         = "#Action.ActionId#"
				actioncode       = "#preserveSingleQuotes(act)#"
				actionpublishno  = "#pub#"					
				wfmode           = "#url.wfmode#">						
			
			<!--- emergency conversion 9/4/2008 --->
			<cfset act = "'#act#'">
					
			<cfinclude template = "ObjectStepAdd.cfm">			
																				
	<cfelseif Form.actionStatus eq "2N">
					
			<!--- ---------------------------------- --->						
			<!--- run condition script ------------- --->
			<!--- ---------------------------------- --->		
			
			<!--- 14/7/2009 : Hanno 
			I am not sure if this is correct here as part of the deny 
			
			<cf_ProcessActionMethod
		    methodname       = "Condition"
			ObjectId         = "#Object.ObjectId#"
			ActionId         = "#Action.ActionId#"
			actioncode       = "#Action.ActionCode#"
			actionpublishno  = "#Action.ActionPublishNo#"
			actioncodegoto   = "#Action.ActionGoToNo#"
			wfmode           = "#url.wfmode#">	
			
			--->
								
			<!--- ---------------------------------- --->						
			<!--- run deny script ------------------ --->
			<!--- ---------------------------------- --->											
			
			<cf_ProcessActionMethod
		    methodname       = "Deny"
			Location         = "Text"
			ObjectId         = "#Object.ObjectId#"
			actioncode       = "#Action.ActionCode#"
			actionpublishno  = "#Action.ActionPublishNo#"					
			wfmode           = "#url.wfmode#">											
		
												
	</cfif>
	
	<!--- ---------------------------------- --->						
	<!--- -- Go to the next steps onwards--- --->
	<!--- ---------------------------------- --->	
			
	<cfinclude template="ObjectStep.cfm">					
