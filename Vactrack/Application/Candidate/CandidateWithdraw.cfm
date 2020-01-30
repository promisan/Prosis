<!--- 
1. set candidate status = 9
2. verify if No of position < candidates with status 2s
      reset master track to step selection	  
--->

<cftransaction action="BEGIN">

<cfquery name="Status" 
 datasource="AppsVacancy" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 UPDATE DocumentCandidate
	 SET    Status = '9',
	        StatusDate = getDate(),
			StatusOfficerUserId    = '#SESSION.acc#',
			StatusOfficerLastName  = '#SESSION.last#',
			StatusOfficerFirstName = '#SESSION.first#'
	 WHERE  DocumentNo             = '#URL.ID#' 
	 AND    PersonNo               = '#URL.ID1#'
</cfquery>

<cfquery name="Check1" 
 datasource="AppsVacancy" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT count(*) as Candidates
	 FROM   DocumentCandidate
	 WHERE  DocumentNo  = '#URL.ID#' 
	 AND    Status = '2s'
</cfquery>

<cfquery name="Check2" 
 datasource="AppsVacancy" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT COUNT(*) as Posts
	 FROM DocumentPost
	 WHERE  DocumentNo  = '#URL.ID#' 
</cfquery>

<cfif Check1.Candidates lt Check2.Posts>

	<cfquery name="LastStep" 
	 datasource="AppsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT TOP 1 O.ObjectId, max(ActionFlowOrder) as ActionFlowOrder
		 FROM   Organization.dbo.OrganizationObject O, 
		        Organization.dbo.OrganizationObjectAction OA
		 WHERE  O.ObjectKeyValue1 = '#URL.ID#' 
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
		 WHERE  DocumentNo      = '#URL.ID#'
	</cfquery>

</cfif>

</cftransaction>

<cfif Check1.Candidates lt Check2.Posts>
	<cflocation url="../Document/DocumentEdit.cfm?ID=#URL.ID#" addtoken="No">
<cfelse>
	<cflocation url="CandidateEdit.cfm?ID=#URL.ID#&ID1=#URL.ID1#" addtoken="No">
</cfif>
