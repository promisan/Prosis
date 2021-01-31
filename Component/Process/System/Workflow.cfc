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