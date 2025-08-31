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
<cfquery name="Evaluate" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     ContractEvaluation
		WHERE    EvaluationId = '#URL.ajaxid#'
</cfquery>

<cfquery name="Workflow" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT OOA.ActionId
		FROM   OrganizationObject AS OO INNER JOIN
		       OrganizationObjectAction AS OOA ON OO.ObjectId = OOA.ObjectId
		WHERE  OO.ObjectKeyValue4 = '#Evaluate.ContractId#' 
		AND    OO.ObjectKeyValue1 = 'midterm' 
		AND    OO.Operational = 1 
		AND    OOA.ActionStatus = '0'
</cfquery>

<cfif workflow.recordcount eq "0">

	<!--- has been completed --->
	
	<cfquery name="setEvaluate" 
		datasource="AppsEPAS" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE   ContractEvaluation
			SET      ActionStatus = '2'
			WHERE    EvaluationId = '#URL.ajaxid#'
	</cfquery>

</cfif>

<!--- check for pending workflows --->
			 		
<cfquery name="Contract" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     Contract  
		WHERE    ContractId = '#Evaluate.ContractId#'
</cfquery>

<cfquery name="Role" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   ContractActor
		WHERE  Contractid     = '#Evaluate.ContractId#' 
		AND    Role           = 'Evaluation'						
		AND    ActionStatus   = '1'
		AND    RoleFunction   = 'FirstOfficer'
</cfquery>
		
<cfloop query="Role">

		<cfset per = PersonNo>	
		<cfinclude template="../PASView/CreateEvaluationAccessWorkflow.cfm">					
		
</cfloop>
   
<cfquery name="Employee" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Person
		WHERE  PersonNo = '#Contract.PersonNo#'
</cfquery>	
					 
<cfset link = "ProgramREM/Portal/Workplan/PAS/PASView.cfm?contractid=#Contract.ContractId#">
				 				 										 
<cf_ActionListing 
	EntityCode       = "EntPASEvaluation"
	EntityClass      = "#Evaluate.EvaluationType#"
	EntityGroup      = ""
	EntityStatus     = ""
	OrgUnit          = "#Contract.orgunit#"
	PersonNo         = "#Contract.PersonNo#" 
	PersonEMail      = "#Employee.eMailAddress#"
	ObjectReference  = "PAS Midpoint"
	ObjectReference2 = "#Employee.FirstName# #Employee.LastName#"
	ObjectKey1       = "#Evaluate.EvaluationType#"
	ObjectKey4       = "#Evaluate.ContractId#"
	ObjectURL        = "#link#"
	AjaxId           = "#url.ajaxid#"
	Show             = "Yes"
	Toolbar          = "No"				
	Framecolor       = "ECF5FF">						