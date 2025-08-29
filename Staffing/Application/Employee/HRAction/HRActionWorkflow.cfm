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
<cfquery name="get" 
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  PersonAction
	WHERE PersonActionId = '#URL.ajaxId#'
</cfquery>

<cfquery name="getAction" 
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_Action
	WHERE ActionCode = '#get.ActionCode#'
</cfquery>

<!--- determine action --->

<cfquery name="Action" 
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  EmployeeActionSource
	WHERE ActionSource   = '#getAction.ActionSource#'
	AND   ActionSourceId = '#URL.ajaxId#'
</cfquery>

<cfquery name="Person" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Person
	WHERE  PersonNo = '#get.PersonNo#' 
</cfquery>	
	
<cfset link = "Staffing/Application/Employee/HRAction/HRActionEdit.cfm?id=#Person.personNo#&id1=#url.ajaxid#">			

<cfparam name="url.show" default="yes">
		
<cf_ActionListing 
	    EntityCode       = "HRAction"
		EntityClass      = "#get.EntityClass#"
		EntityGroup      = ""
		EntityStatus     = ""
		Mission          = "#get.mission#"		
		PersonNo         = "#Person.Personno#"
		SourceActionNo   = "#Action.ActionDocumentNo#"
		ObjectReference  = "#getAction.Description#"
		ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
		ObjectFilter     = "#get.ActionCode#"  
	    ObjectKey1       = "#Person.Personno#"
		ObjectKey4       = "#URL.ajaxId#"
		AjaxId           = "#URL.ajaxId#"
		ObjectURL        = "#link#"
		Reset            = "Limited"
		Show             = "#url.show#">	
	
