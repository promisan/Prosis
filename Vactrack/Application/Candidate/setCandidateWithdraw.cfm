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
<!--- 
1. set candidate status = 9
2. verify if No of position < candidates with status 2s
      reset master track to step selection	  
--->

<cftransaction action="BEGIN">

<cfquery name="Doc" 
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Vacancy.dbo.DocumentCandidate	
	 WHERE  DocumentNo             = '#URL.ID#' 
	 AND    PersonNo               = '#URL.ID1#'
</cfquery>

<cfquery name="Status" 
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 UPDATE Vacancy.dbo.DocumentCandidate
	 SET    Status = '9',
	        StatusDate             = getDate(),
			StatusOfficerUserId    = '#SESSION.acc#',
			StatusOfficerLastName  = '#SESSION.last#',
			StatusOfficerFirstName = '#SESSION.first#'
	 WHERE  DocumentNo             = '#URL.ID#' 
	 AND    PersonNo               = '#URL.ID1#'
</cfquery>

 <cf_ActionListing 
    EntityCode       = "VacCandidate"		
	EntityClass      = "#Doc.EntityClass#"			
	EntityGroup      = ""
	EntityStatus     = ""					
    ObjectKey1       = "#URL.ID#"		
	ObjectKey2       = "#URL.ID1#"		
	Show             = "No"				
	CompleteCurrent  = "Yes">	 

<cfquery name="Check1" 
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT count(*) as Candidates
	 FROM   Vacancy.dbo.DocumentCandidate
	 WHERE  DocumentNo  = '#URL.ID#' 
	 AND    Status = '2s'
</cfquery>

<cfquery name="Check2" 
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT COUNT(*) as Posts
	 FROM   Vacancy.dbo.DocumentPost
	 WHERE  DocumentNo  = '#URL.ID#' 
</cfquery>

<cfif Check1.Candidates lt Check2.Posts>

	<cfquery name="LastStep" 
	 datasource="AppsOrganization" 
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
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 UPDATE Organization.dbo.OrganizationObjectAction
		 SET    ActionStatus      = '0',
		        TriggerActionType = 'Detail'
		 WHERE  ObjectId          = '#LastStep.ObjectId#'
		 AND    ActionFlowOrder   = '#LastStep.ActionFlowOrder#' 
	</cfquery>
	
	<cfquery name="Update" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 UPDATE Vacancy.dbo.Document
		 SET    Status                 = '0',
		        StatusDate             = getDate(),
				StatusOfficerUserId    = '#SESSION.acc#',
				StatusOfficerLastName  = '#SESSION.last#',
				StatusOfficerFirstName = '#SESSION.first#'
		 WHERE  DocumentNo      = '#URL.ID#'
	</cfquery>

</cfif>

</cftransaction>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfif Check1.Candidates lt Check2.Posts>
	<cflocation url="../Document/DocumentEdit.cfm?ID=#URL.ID#&mid=#mid#" addtoken="No">
<cfelse>
	<cflocation url="CandidateEdit.cfm?ID=#URL.ID#&ID1=#URL.ID1#&mid=#mid#" addtoken="No">
</cfif>
