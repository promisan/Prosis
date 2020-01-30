
<!--- withdraw script --->

<cfif Form.actionStatus eq "2" or Form.actionStatus eq "2Y">
	
	<cftransaction action="BEGIN">
	
	<cfquery name="Status" 
	 datasource="AppsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE DocumentCandidate
	 SET    Status                 = '9',
	        StatusDate             = getDate(),
			StatusReason           = '#Form.StatusReason#',
			StatusOfficerUserId    = '#SESSION.acc#',
			StatusOfficerLastName  = '#SESSION.last#',
			StatusOfficerFirstName = '#SESSION.first#'
	 WHERE  DocumentNo   = '#Form.Key1#'
	   AND  PersonNo     = '#Form.Key2#'  
	</cfquery>
	
	<cfquery name="Check1" 
	 datasource="AppsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT count(*) as Candidates
	 FROM   DocumentCandidate
	 WHERE  DocumentNo   = '#Form.Key1#' 
	 AND    Status = '2s'
	</cfquery>
	
	<cfquery name="Check2" 
	 datasource="AppsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT COUNT(*) as Posts
	 FROM DocumentPost
	 WHERE  DocumentNo   = '#Form.Key1#'
	</cfquery>
	
	<cfif Check1.Candidates lt Check2.Posts>
	
		<cfquery name="LastStep" 
		 datasource="AppsVacancy" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT TOP 1 O.ObjectId, max(ActionFlowOrder) as ActionFlowOrder
			 FROM   Organization.dbo.OrganizationObject O, 
			        Organization.dbo.OrganizationObjectAction OA
			 WHERE  O.ObjectKeyValue1 = '#Form.Key1#'
			 AND    O.ObjectId        = OA.ObjectId 
			 AND    O.EntityCode      = 'VacDocument' 
			 AND    O.Operational     = 1
			 GROUP BY O.ObjectId
		</cfquery>
		
		<cfquery name="Update" 
		 datasource="AppsVacancy" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE Organization.dbo.OrganizationObjectAction
			 SET    ActionStatus      = '0',
			        TriggerActionType = 'Detail'
			 WHERE  ObjectId          = '#LastStep.ObjectId#'
			 AND    ActionFlowOrder   = '#LastStep.ActionFlowOrder#' 
		</cfquery>
		
		<cfquery name="Update" 
		 datasource="AppsVacancy" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE Document
			 SET    Status                 = '0',
			        StatusDate             = getDate(),
					StatusOfficerUserId    = '#SESSION.acc#',
					StatusOfficerLastName  = '#SESSION.last#',
					StatusOfficerFirstName = '#SESSION.first#'
			WHERE  DocumentNo   = '#Form.Key1#'
		</cfquery>
	
	</cfif>
	
	</cftransaction>
	
</cfif>	


		 



