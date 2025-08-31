<!--
    Copyright © 2025 Promisan B.V.

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

1. Revoke review record
2. verify if No of position < candidates with status 2s
      reset master track to step selection
	  
--->

<cftransaction action="BEGIN">

<!--- revoke track --->

<cfquery name="RevokeTrack" 
 datasource="AppsVacancy" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 DELETE FROM Organization.dbo.OrganizationObject
	 WHERE  ObjectKeyValue1 = '#URL.ID#' 
	 AND    ObjectKeyValue2 = '#URL.ID1#'
	 AND    EntityCode = 'VacCandidate' 
	 AND    Operational  = 1
</cfquery>

<cfquery name="ResetCandidate" 
 datasource="AppsVacancy" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 UPDATE DocumentCandidate
	 SET    EntityClass = NULL
	 WHERE  DocumentNo = '#URL.ID#' 
	 AND    PersonNo   = '#URL.ID1#'
</cfquery>

<!--- open last step document level --->

<cfquery name="LastStep" 
 datasource="AppsVacancy" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT TOP 1 O.ObjectId, max(ActionFlowOrder) as ActionFlowOrder
	 FROM   Organization.dbo.OrganizationObject O, 
	        Organization.dbo.OrganizationObjectAction OA
	 WHERE  O.ObjectKeyValue1 = '#URL.ID#' 
	 AND    O.ObjectId = OA.ObjectId 
	 AND    O.EntityCode = 'VacDocument' 
	 AND    O.Operational  = 1
	 GROUP BY O.ObjectId
</cfquery>

<cfquery name="Update" 
 datasource="AppsVacancy" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 UPDATE Organization.dbo.OrganizationObjectAction
	 SET    ActionStatus = '0',
	        TriggerActionType = 'Detail'
	 WHERE  ObjectId        = '#LastStep.ObjectId#'
	 AND    ActionFlowOrder = '#LastStep.ActionFlowOrder#' 
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
		 AND    Status != '0'
	</cfquery>

</cftransaction>

<script>
 window.close()
 try {
 opener.history.go()
 } catch(e) {}
</script>
