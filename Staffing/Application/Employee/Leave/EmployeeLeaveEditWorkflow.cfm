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

<cfset link = "Attendance/Application/LeaveRequest/RequestView.cfm?id=#URL.ajaxid#">

<cfquery name="Leave" 
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *,
		    (SELECT TOP 1 ObjectKeyValue4 
			 FROM     Organization.dbo.OrganizationObject 
			 WHERE    (Objectid   = L.LeaveId OR ObjectKeyValue4 = L.LeaveId)
			 AND      EntityCode = 'EntLVE') as WorkflowId	
    FROM   PersonLeave L
	WHERE  LeaveId = '#URL.ajaxid#'
</cfquery>

<cfif Leave.OrgUnit eq "0">
	
	<cfquery name="orgunit" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	  TOP 1  O.OrgUnit, O.OrgUnitName, O.Mission
	   	FROM 	  PersonAssignment P INNER JOIN Organization.dbo.Organization O ON P.OrgUnit = O.OrgUnit
		WHERE	  P.PersonNo          = '#Leave.PersonNo#'  		
		AND       P.AssignmentStatus  < '8' <!--- planned and approved --->
	    AND       P.AssignmentType    = 'Actual'   	 
		ORDER BY  P.DateEffective DESC <!--- first the highest --->	  
	</cfquery>
	
	<cfquery name="set" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE PersonLeave
		SET  OrgUnit = '#orgunit.orgunit#'	
		WHERE  LeaveId = '#URL.ajaxid#'
	</cfquery>	
			
	<cfset orgunit = orgunit.OrgUnit>
	
<cfelse>

	<cfset orgunit = leave.orgunit>	
	
</cfif>

<cfquery name="qLeaveType" 
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_LeaveType
	WHERE  LeaveType = '#Leave.LeaveType#'
</cfquery>

<cfquery name="LeaveClass" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT *
	   FROM   Ref_LeaveTypeClass
	   WHERE  LeaveType = '#Leave.LeaveType#'
	   AND    Code      = '#Leave.LeaveTypeClass#'  	  
</cfquery>

<!---- LeaveTypeClass has its own workflow --->
<cfif LeaveClass.recordcount eq "1">	
	<cfset ref     = "#LeaveClass.Description#">
<cfelse>	
	<cfset ref     = "#qLeaveType.Description#">
</cfif>

<cfquery name="Person" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Person
	WHERE  PersonNo = '#Leave.PersonNo#' 
</cfquery>


<cfif (Leave.Status eq "8" or Leave.Status eq "9") and Leave.WorkflowId eq "">


	<!--- do not show the workflow if status is cancelled and there is no workflow to prevent it is generated --->
	
<cfelseif (Leave.Status eq "8" or Leave.Status eq "9") and Leave.WorkflowId neq "">

		<cfif LeaveClass.EntityClass neq "">
		    <cfset WFClass = "#LeaveClass.EntityClass#">
   	    <cfelse>
		    <cfset WFClass = "#qLeaveType.entityClass#">
		</cfif>		

		<cf_ActionListing 
			    EntityCode       = "EntLVE"	
				EntityClass      = "#trim(WFClass)#"
				EntityGroup      = ""						
				Personno         = "#Person.PersonNo#"
				ObjectReference  = "#qLeaveType.Description#"
				ObjectReference2 = "#Person.FirstName# #Person.LastName#"
			    ObjectKey1       = "#Person.PersonNo#"
				ObjectKey4       = "#URL.ajaxid#"
				AjaxId           = "#URL.ajaxid#"	
				Show             = "Yes"
				HideCurrent      = "No" <!--- disactivates the current workflow to trigger a new one --->
				CompleteCurrent  = "Yes"
				ObjectURL        = "#link#">		

<cfelse>	

	
	<cfquery name="Object" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Organization.dbo.OrganizationObject
		WHERE  ObjectId = '#Leave.WorkflowId#' 
	</cfquery>	
				
	<cf_ActionListing 
	    EntityCode       = "EntLVE"	
		EntityClass      = "#Object.EntityClass#"	
		EntityGroup      = ""
		EntityStatus     = ""
		PersonNo         = "#Person.PersonNo#"	
		OrgUnit          = "#OrgUnit#"
		ObjectReference  = "#ref# #dateformat(Leave.DateEffective,client.dateformatshow)# #dateformat(Leave.DateExpiration,client.dateformatshow)#"
		ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
		AjaxId           = "#URL.ajaxid#"	
		ObjectKey1		 = "#Person.PersonNo#"
	    ObjectKey4       = "#URL.ajaxid#"
		ObjectDue        = "#dateformat(Leave.DateEffective,client.dateSQL)#" 
		ObjectURL        = "#link#"
		Show             = "Yes"
		HideCurrent      = "No"
		CompleteCurrent  = "No"
		Toolbar			 = "show"
		FlyActor         = "#Leave.FirstReviewerUserid#"
		FlyActorAction   = "#qLeaveType.ReviewerActionCodeOne#"
		FlyActor2        = "#Leave.SecondReviewerUserid#"
		FlyActor2Action  = "#qLeaveType.ReviewerActionCodeTwo#"
		FlyActor3        = "#Leave.HandoverUserId#"
		FlyActor3Action  = "#qLeaveType.HandoverActionCode#">	
		
</cfif>



	
		
	
