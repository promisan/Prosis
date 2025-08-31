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
<cfquery name="ContractSel" 
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  PersonContract
	WHERE Contractid = '#URL.ajaxId#'
</cfquery>

<!--- determine action --->

<cfquery name="Action" 
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  EmployeeActionSource
	WHERE ActionSource   = 'Contract'
	AND   ActionSourceId = '#URL.ajaxId#'
</cfquery>

<cfquery name="CheckIncrement" 
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * FROM Employee.dbo.EmployeeAction
	WHERE ActionDocumentNo='#Action.ActionDocumentNo#'
	AND ActionCode = '3004'
</cfquery>	

<cfif CheckIncrement.recordCount neq 0>
	<cfset vAction = "Step Increment ">
<cfelse>
	<cfset vAction = "">
</cfif>	

<cfquery name="Person" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Person
	WHERE  PersonNo = '#ContractSel.PersonNo#' 
</cfquery>

<!--- check first which workflow to show, recruitment or contract : disabled, this can have its own workflow 

<cfquery name="Recruitment" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
      SELECT * 
	  FROM   OrganizationObject
	  WHERE  ObjectId  =  '#url.ajaxid#'	
	  AND    EntityCode = 'VacCandidate'	  						 
	  AND    Operational = 1
</cfquery>

<cfif Recruitment.recordcount eq "1">
  	
	<cfset link = "Staffing/Application/Employee/Contract/ContractEdit.cfm?id=#Person.personNo#&id1=#url.ajaxid#">			
	
	<cf_ActionListing   
	    EntityCode       = "VacCandidate"
		EntityClass      = "#Recruitment.EntityClass#"
		EntityGroup      = "#Recruitment.Owner#"
		EntityStatus     = ""
		Mission          = "#Recruitment.Mission#"
		OrgUnit          = "#Recruitment.OrgUnit#"								
		AjaxId           = "#URL.ajaxId#"
		ObjectKey1       = "#Recruitment.ObjectkeyValue1#"
		ObjectKey2       = "#Recruitment.ObjectkeyValue2#"
	  	ObjectURL        = "#link#">
		
<cfelse>

--->
	
	<cfquery name="EntityClass" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	      SELECT * 
		  FROM   Ref_ContractType
		  WHERE  ContractType =  '#ContractSel.ContractType#'	
		   <!--- published workflow --->	    			
		  AND    EntityClass IN (SELECT EntityClass
								 FROM   Organization.dbo.Ref_EntityClassPublish
							 	 WHERE  EntityCode = 'PersonContract') 
		  						 
	</cfquery>
	
	<cfset link = "Staffing/Application/Employee/Contract/ContractEdit.cfm?id=#Person.personNo#&id1=#url.ajaxid#">			
	
			
	<cf_ActionListing 
	    EntityCode       = "PersonContract"
		EntityClass      = "#EntityClass.EntityClass#"
		EntityGroup      = ""
		EntityStatus     = ""
		Mission          = "#contractsel.mission#"
		SourceActionNo   = "#Action.ActionDocumentNo#"
		PersonNo         = "#Person.Personno#"
		ObjectReference  = "#vAction##ContractSel.ContractLevel#/#ContractSel.ContractStep#"
		ObjectReference2 = "#Person.FirstName# #Person.LastName#" 		
	    ObjectKey1       = "#Person.Personno#"
		ObjectKey4       = "#URL.ajaxId#"
		AjaxId           = "#URL.ajaxId#"
		ObjectURL        = "#link#"
		Reset            = "Limited" <!--- limited menu reset options --->
		Show             = "Yes">	
		
		<!--- ObjectFilter     = "#ContractSel.ActionCode#"   t21/4/2018 
		his was creating a new workflow in Case of Karin upon opening as actions of contractsel <> action in the worflow --->

<!---		
</cfif>		
--->
	
