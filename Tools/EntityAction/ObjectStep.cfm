<!--- define which steps will need to be added --->
<!--- start from the beginning, check if exists, otherwise add --->
<!--- if action = decision, check result 4 : yes, 5, no --->
<!--- locate the actionorder for YES --->
<!--- start steps from this order --->
<!--- add steps until type = decision is reached --->
 
<cfparam name="Attributes.resubmit" default="No">	

<!--- added a provision to automtically process a step once a 
        parameter was set for resubmission ---> 
		
<cfset dueactioncode = "">		
	 
<cfif Attributes.Resubmit eq "Yes">

        <!--- special feature for travel claim to resubmit
		  --->

        <cfquery name="First" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT   TOP 1 ActionCode 
			 FROM     OrganizationObjectAction OA
			 WHERE    OA.ObjectId = '#objectid#'
			 ORDER BY ActionFlowOrder
		</cfquery>

		<cfquery name="Last" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT   MIN(ActionFlowOrder) as ActionFlowOrder
			 FROM     OrganizationObjectAction OA
			 WHERE    OA.ObjectId = '#objectid#'
			 AND      OA.ActionStatus = '0'  
			 
			 <!--- define the action which is the first in the sequence--->
			 
			 AND      OA.ActionCode =  (SELECT   TOP 1 ActionCode 
							   		    FROM     OrganizationObjectAction OA
									    WHERE    OA.ObjectId = '#objectid#'
									    ORDER BY ActionFlowOrder)
			 ORDER BY ActionFlowOrder DESC
		</cfquery>
				
		<!--- close the very last record --->
				
		<cfif Last.recordcount eq "1">

			<cfquery name="Update" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 UPDATE OrganizationObjectAction 		
			 SET    ActionStatus     = '2',
			 	    OfficerUserId    = '#SESSION.acc#',
				    OfficerLastName  = '#SESSION.last#',
				    OfficerFirstName = '#SESSION.first#', 
				    OfficerDate      = getDate()
			 WHERE  ObjectId         = '#objectid#' 
			 AND    ActionFlowOrder  = '#Last.ActionFlowOrder#'
			</cfquery>
		
		</cfif>
		
		<cfset client.resubmit = "No">
		
<cfelse>	

	<cfquery name="Due" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT   MIN(ActionFlowOrder) as ActionFlowOrder
			 FROM     OrganizationObjectAction OA
			 WHERE    OA.ObjectId = '#objectid#'
			 AND      OA.ActionStatus = '0'  			
			 ORDER BY ActionFlowOrder DESC
		</cfquery>
		
		<cfquery name="DueList" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT *
			 FROM   OrganizationObjectAction 					
			 WHERE  ObjectId         = '#objectid#' 
			 AND    ActionFlowOrder  = (
			 
										SELECT  TOP 1 MIN(ActionFlowOrder) as ActionFlowOrder
										FROM     OrganizationObjectAction OA
										WHERE    OA.ObjectId = '#objectid#'
										AND      OA.ActionStatus = '0'  			
										ORDER BY ActionFlowOrder DESC
										
										)
		</cfquery>
		
									 				
		<cfloop query="DueList">
		
		    <cfset dueactioncode = "#dueactioncode#,#actioncode#">
				
			<cf_ProcessActionMethod
			    methodname       = "Due"
				Location         = "Text"
				ObjectId         = "#ObjectId#"
				ActionId         = "#ActionId#"
				actioncode       = "#ActionCode#"
				actionpublishno  = "#ActionPublishNo#">		
				
			<cf_ProcessActionMethod
			    methodname       = "Due"
				Location         = "File"
				ObjectId         = "#ObjectId#"
				ActionId         = "#ActionId#"
				actioncode       = "#ActionCode#"
				actionpublishno  = "#ActionPublishNo#">		
						
		</cfloop>	
				

</cfif>
		
<cfquery name="LastDecision" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   TOP 1 ActionFlowOrder
	 FROM     OrganizationObjectAction OA, 
	          Ref_EntityActionPublish R
	 WHERE    OA.ObjectId = '#objectid#'
	 AND      OA.ActionPublishNo = R.ActionPublishNo
	 AND      OA.ActionCode      = R.ActionCode 
	 AND      R.ActionType       = 'Decision'
	 ORDER BY ActionFlowOrder DESC, 
	          TriggerActionType 
</cfquery>

<cfquery name="LastAction" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   TOP 1 ActionFlowOrder
	 FROM     OrganizationObjectAction OA, 
	          Ref_EntityActionPublish R
	 WHERE    OA.ObjectId = '#objectid#'
	 AND      OA.ActionPublishNo = R.ActionPublishNo
	 AND      OA.ActionCode      = R.ActionCode 
	 AND      R.ActionType = 'Action'
	 ORDER BY ActionFlowOrder DESC, TriggerActionType 
</cfquery>

<cfset act = "">

<cfif LastDecision.ActionFlowOrder gte LastAction.ActionFlowOrder>

    <!--- now create entries for next range of actions --->

	<cfquery name="Decision" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT   OA.ActionId, OA.ActionStatus, OA.ActionPublishNo, 
		          R.ActionGoToYes, R.ActionGoToNo
		 FROM     OrganizationObjectAction OA, 
	              Ref_EntityActionPublish R
		 WHERE    ObjectId = '#objectid#'
		 AND      OA.ActionPublishNo = R.ActionPublishNo
    	 AND      OA.ActionCode      = R.ActionCode 
		 AND      ActionFlowOrder    = '#LastDecision.ActionFlowOrder#' 
	</cfquery>
	
	<cfset triggerType = "Decision">
	<cfset trigger     = "#Decision.ActionId#">
	<cfset orgunit     = "#Object.OrgUnit#">
	<cfset pub         = "#Decision.ActionPublishNo#">

	<cfif Decision.ActionStatus eq "2Y">
	    <cfset act = "'#Decision.ActionGoToYes#'">
	<cfelseif Decision.ActionStatus eq "2N">
		<cfset act = "'#Decision.ActionGoToNo#'">	 
	</cfif>	
		
	<!--- create decision flow action steps --->
	
	<cfif Act neq "">
		 			
		<cfquery name="NextCheck" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT *
		 FROM Ref_EntityActionPublish R
		 WHERE     R.ActionPublishNo = '#pub#' 
		 AND       R.ActionCode      = #preservesinglequotes(Act)# 
		</cfquery>
						
		<cfif NextCheck.recordcount gte "1">
		     <cfinclude template="ObjectStepAdd.cfm">
		</cfif>
					
		<cfif Object.enableEMail eq "1">		
						
			<cfif NextCheck.EnableNotification eq "1">
									
					<!--- get the next pending action --->									
					
					<cfquery name="NextStep" 
						 datasource="AppsOrganization"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
							 SELECT    TOP 1 A.ActionFlowOrder 
							 FROM      OrganizationObject O INNER JOIN
							           OrganizationObjectAction A ON O.ObjectId = A.ObjectId
							 WHERE     O.ObjectId = '#Object.Objectid#' 
							 AND       A.ActionStatus = '0' 
							 AND       O.Operational  = 1  
							 ORDER BY  A.ActionFlowOrder  
					 </cfquery>	
						 
					 <!--- retrieve details beased on the defined step --->
					
				     <cfquery name="NextAction" 
						 datasource="AppsOrganization"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT    A.ActionCode, 
						           A.ActionPublishNo, 
								   A.OrgUnit, 
								   A.ActionFlowOrder,
								   A.ActionId
						 FROM      OrganizationObject O INNER JOIN
						           OrganizationObjectAction A ON O.ObjectId = A.ObjectId
						 WHERE     O.ObjectId        = '#Object.Objectid#' 
						 AND       A.ActionStatus    = '0' 
						 AND       A.ActionFlowOrder = '#NextStep.ActionFlowOrder#'
						 AND       O.Operational     = 1  	
					 </cfquery>			
					 
					 <!--- aded condition 11/4/2013 --->																		
				    
					<cfif NextAction.recordcount gte "1">
					
						<cfquery name="NextCheck" 
						 datasource="AppsOrganization"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT    *
						 FROM      Ref_EntityActionPublish R 
						 WHERE     R.ActionPublishNo = '#Object.ActionPublishNo#' 
						 AND       ActionCode        = '#NextAction.ActionCode#' 
						</cfquery>
					
					    <cfif Object.enableEMail eq "1" and NextCheck.NotificationManual eq "0">
						
							<cfset actionId = NextAction.ActionId> 
							<cfinclude template="ProcessMail.cfm">
							<!--- prevents process mail to be executed again --->
							<cfset processmailexecuted = "1">
						
						</cfif>
						
						
					</cfif>
					
			</cfif>
						
		</cfif>				
				
	<cfelse>
	
	<cfquery name="DueAction" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   TOP 1 ActionFlowOrder
	 FROM     OrganizationObjectAction
	 WHERE    ObjectId = '#objectid#'
	 AND      ActionStatus = '0'
	 ORDER BY ActionFlowOrder 
	 </cfquery>
	 	
	 <cfquery name="NextAction" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     OrganizationObjectAction 
	 WHERE    ObjectId = '#objectid#'
	 AND      ActionStatus = '0' 
	 AND      ActionFlowOrder = '#DueAction.ActionFlowOrder#'	
	 </cfquery>
	 	 
	 <cfloop query="NextAction">
	 
	    <cfif find(actioncode,dueactioncode)>
		
		    <!--- no action --->
		
		<cfelse>
	 	
			<cf_ProcessActionMethod
			    methodname       = "Due"
				Location         = "Text"
				ObjectId         = "#ObjectId#"
				ActionId         = "#ActionId#"
				actioncode       = "#ActionCode#"
				actionpublishno  = "#pub#">												
									
			<cf_ProcessActionMethod
			    methodname       = "Due"
				Location         = "File"
				ObjectId         = "#ObjectId#"
				ActionId         = "#ActionId#"
				actioncode       = "#ActionCode#"
				actionpublishno  = "#pub#">		
			
		</cfif>	
			
		</cfloop>		
			
	
	</cfif>
	
	
</cfif>