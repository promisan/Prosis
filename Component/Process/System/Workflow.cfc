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
<cfcomponent>
    <cfproperty name="name" type="string">
    <cfset this.name = "Workflow actions">

	
	<cffunction name="ProcessStep"
        access="public"
        returntype="string">
		
		<cfargument name="DataSource"      type="string"  required="true" default="appsOrganization">	 
		<cfargument name="ObjectId"        type="string"  required="false">	
		<cfargument name="ActionId"        type="string"  required="false">	 		 		
		<cfargument name="Action"          type="string"  required="true" default="skip">	<!--- skip | external | ---> 	
		<cfargument name="ActionDecision"  type="string"  required="true" default="Submit">							
		<cfargument name="Memo"            type="string"  required="true" default="">	
					
		<cfif Action eq "skip">
			
			<cfif actionId neq "">

				<cfquery name="get" 
					   datasource="#attributes.DataSource#" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#"> 
						SELECT  R.*
						FROM    Organization.dbo.OrganizationObjectAction A INNER JOIN
				                Organization.dbo.Ref_EntityActionPublish R ON A.ActionPublishNo = R.ActionPublishNo AND A.ActionCode = R.ActionCode
						WHERE   A.ActionId = '#actionid#'
				</cfquery>	
			
				<cfif get.ActionType eq "Action">
					<cfset st = "2">		
				<cfelse>
					<cfset st = "2y">		
				</cfif>
				
				<cfquery name="ProcessStep" 
				   datasource="#DataSource#" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#"> 
				    UPDATE Organization.dbo.OrganizationObjectAction
				    SET    ActionStatus     = '#st#',
				           ActionMemo       = '#Memo#',
				           OfficerUserId    = '#session.acc#',
				           OfficerLastName  = 'Agent',
				           OfficerFirstName = 'System',            
				           OfficerDate      = getDate()          
				    WHERE  ActionId         = '#ActionId#'
				    AND    ActionStatus     = '0'    
				</cfquery>
				
				 <!--- process the submit/approve method --->								
				 			
				 <cf_ProcessActionMethod
					    methodname       = "submission"
						location         = "file"
						ObjectId         = "#get.ObjectId#"
						ActionId         = "#get.ActionId#"
						actioncode       = "#get.ActionCode#"
						actionpublishno  = "#get.ActionPublishNo#"					
						wfmode           = "0">			
					
			</cfif>		
			
		<cfelseif action eq "external">
			
			<!--- get the open action and determined if it is an API --->
								
			<cfquery name="get" 
			   datasource="#DataSource#" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#"> 
				SELECT  TOP 1 ObjectId, ActionId, R.*
				FROM    Organization.dbo.OrganizationObjectAction A INNER JOIN
		                Organization.dbo.Ref_EntityActionPublish R ON A.ActionPublishNo = R.ActionPublishNo AND A.ActionCode = R.ActionCode
				WHERE   A.ObjectId = '#objectId#'
				AND     A.ActionStatus IN ('0','2N')
				ORDER BY ActionFlowOrder				
			</cfquery>				
		
			<cfif get.actiontrigger eq "external">
						
				<cfif actionDecision eq "Submit">
							
					<cfif get.ActionType eq "Action">
						<cfset st = "2">		
					<cfelse>
						<cfset st = "2y">		
					</cfif>
													  	  
					<cfquery name="UpdateWorkflow"
					   datasource="#DataSource#"
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">	  
					   UPDATE    Organization.dbo.OrganizationObjectAction
					   SET       ActionStatus     = '#st#', 
					             OfficerUserId    = '#SESSION.acc#',
								 OfficerLastName  = '#SESSION.last#',
								 OfficerFirstName = '#SESSION.first#', 
								 ActionMemo       = '#memo#',
								 OfficerDate      = getDate()
					   WHERE     ActionId         = '#get.actionId#'
					</cfquery> 
										  					
				    <!--- process the submit/approve method --->								
				 			
				    <cf_ProcessActionMethod
					    methodname       = "submission"
						DataSource       = "#DataSource#"
						location         = "file"
						ObjectId         = "#get.ObjectId#"
						ActionId         = "#get.ActionId#"
						actioncode       = "#get.ActionCode#"
						actionpublishno  = "#get.ActionPublishNo#"					
						wfmode           = "0">		
						
					 <cf_ProcessActionMethod
					    methodname       = "submission"
						DataSource       = "#DataSource#"
						location         = "text"
						ObjectId         = "#get.ObjectId#"
						ActionId         = "#get.ActionId#"
						actioncode       = "#get.ActionCode#"
						actionpublishno  = "#get.ActionPublishNo#"					
						wfmode           = "0">		
						
				<cfelseif actionDecision eq "Deny">					
				
					<cfset st = "2N">		
													  	  
					<cfquery name="UpdateWorkflow"
					   datasource="#DataSource#"
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">	  
					   UPDATE    Organization.dbo.OrganizationObjectAction
					   SET       ActionStatus     = '#st#', 
					             OfficerUserId    = '#SESSION.acc#',
								 OfficerLastName  = '#SESSION.last#',
								 OfficerFirstName = '#SESSION.first#', 
								 ActionMemo       = '#memo#',
								 OfficerDate      = getDate()
					   WHERE     ActionId         = '#get.actionId#'
					   
					</cfquery> 
										  					
				    <!--- process the submit/approve method --->								
				 			
				    <cf_ProcessActionMethod
					    methodname       = "deny"
						DataSource       = "#DataSource#"
						location         = "file"
						ObjectId         = "#get.ObjectId#"
						ActionId         = "#get.ActionId#"
						actioncode       = "#get.ActionCode#"
						actionpublishno  = "#get.ActionPublishNo#"					
						wfmode           = "0">		
						
					 <cf_ProcessActionMethod
					    methodname       = "deny"
						DataSource       = "#DataSource#"
						location         = "text"
						ObjectId         = "#get.ObjectId#"
						ActionId         = "#get.ActionId#"
						actioncode       = "#get.ActionCode#"
						actionpublishno  = "#get.ActionPublishNo#"					
						wfmode           = "0">		
										
				</cfif>					
										
			</cfif>	
				
		</cfif>			
			
	</cffunction>
		
</cfcomponent>			 