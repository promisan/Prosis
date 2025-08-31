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
 </cfquery>
		
 <cfloop query="Role">
		<cfset per = PersonNo>	
		<cfset fun = RoleFunction>
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
	 
 <cfset link = "ProgramREM/Portal/Workplan/PAS/PASView.cfm?contractid=#Evaluate.ContractId#">		 
							 
 <cf_ActionListing 
		EntityCode       = "EntPASEvaluation"
		EntityClass      = "#Evaluate.EvaluationType#"
		EntityGroup      = ""
		EntityStatus     = ""
		OrgUnit          = "#Contract.orgunit#"
		PersonNo         = "#Contract.PersonNo#" 
		PersonEMail      = "#Employee.eMailAddress#"
		ObjectReference  = "PAS Recommendation and Review"
		ObjectReference2 = "#Employee.FirstName# #Employee.LastName#"
		ObjectKey1       = "#Evaluate.EvaluationType#"
		ObjectKey4       = "#Evaluate.ContractId#"					
		ObjectURL        = "#link#"
		AjaxId           = "#url.ajaxid#"
		Show             = "Yes"
		CompleteFirst    = "No"
		Toolbar          = "No"				
		Framecolor       = "ECF5FF">	