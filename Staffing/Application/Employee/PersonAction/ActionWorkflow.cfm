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
<cfparam name="url.drillid" default="">
<cfparam name="url.ajaxid" default="#url.drillid#">

<cfif url.ajaxid eq "">

	<table align="center">
	   <tr><td><font size="2" color="gray">Workflow could not be initialised. Please contact your administrator.</td></tr>
	</table>
	<cfabort>

</cfif>

<cfquery name="Action" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
     	SELECT * 
		FROM   EmployeeAction A, Ref_Action R
		WHERE  A.ActionCode       = R.ActionCode
		AND    A.ActionDocumentNo = '#url.ajaxid#'	
</cfquery>

<cfif Action.mission eq "">

<table align="center"><tr><td><font size="2" color="gray">Workflow could not be initialised as entity could not be determined</td></tr></table>

<cfelse>
	
	<cfquery name="Person" 
	 	datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Person
			WHERE  PersonNo = '#Action.ActionPersonNo#' 
	</cfquery>
		
	<cfset link = "#SESSION.root#/Staffing/Application/Employee/PersonAction/ActionDialog.cfm?drillid=#URL.ajaxid#">
		
	<cf_ActionListing 
	    EntityCode       = "PersonAction"
		EntityClass      = "Standard"
		EntityGroup      = ""
		EntityStatus     = ""
		Mission          = "#Action.mission#"
		PersonNo         = "#Action.ActionPersonNo#"
		ObjectReference  = "#Action.Description#"
		ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
	    ObjectKey1       = "#Action.ActionDocumentNo#"	
		ObjectFilter     = "PersonAction"
		ajaxId           = "#url.ajaxid#"
		ObjectURL        = "#link#"
		Show             = "Yes"						
		CompleteFirst    = "No">	
		
</cfif>	
		 
		
		
