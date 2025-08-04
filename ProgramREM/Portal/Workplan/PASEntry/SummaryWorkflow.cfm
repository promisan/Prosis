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
<cfset link = "ProgramREM/Portal/Workplan/PAS/PASView.cfm?contractid=#URL.ajaxid#">
			 		
<cfquery name="Contract" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     Contract C LEFT OUTER JOIN Ref_ContractPeriod R ON C.Period = R.Code
		WHERE    ContractId = '#URL.ajaxid#'
</cfquery>
   
<cfquery name="Employee" 
		datasource="appsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   Person
			WHERE  PersonNo = '#Contract.PersonNo#'
</cfquery>	


<cfquery name="Role" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     ContractActor C 
		WHERE    ContractId = '#URL.ajaxid#'
		AND      ActionStatus = '1' 
		AND      Role = 'Evaluation'
		AND      RoleFunction = 'FirstOfficer'
</cfquery>

<cfloop query="Role">

	<cfquery name="Account" 
	datasource="appsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    UserNames
		WHERE   PersonNo = '#PersonNo#'
	</cfquery>

	<cfset acc = Account.account>
	
</cfloop>	
								 
<cf_ActionListing 
	EntityCode       = "EntPAS"
	EntityGroup      = ""
	EntityStatus     = ""
	OrgUnit          = "#Contract.orgunit#"
	PersonNo         = "#Contract.PersonNo#" 
	PersonEMail      = "#Employee.eMailAddress#"
	ObjectReference  = "PAS Approval"
	ObjectReference2 = "#Employee.FirstName# #Employee.LastName#"
	ObjectKey4       = "#url.ajaxid#"
	ObjectURL        = "#link#"
	FlyActor         = "#acc#"
	FlyActorAction   = "PAS02"
	AjaxId           = "#URL.AjaxId#"
	Show             = "Yes"
	Toolbar          = "No"
	Framecolor       = "ECF5FF">	 
					