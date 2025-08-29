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
 <cfquery name="Document" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
    FROM  EmployeeAction
	WHERE ActionSourceNo = '#url.ajaxid#' 		
	AND   ActionSource = 'Assignment'
 </cfquery>

 <cfset link = "">
	  
 <cfquery name="Person" 
 	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT *
			FROM Person
			WHERE PersonNo = '#Document.ActionPersonNo#' 
 </cfquery>
		
 <cf_ActionListing 
	    EntityCode       = "Assignment"
		EntityClass      = "Standard"
		EntityGroup      = ""
		EntityStatus     = ""
		Mission          = "#Document.mission#"
		PersonNo         = "#Document.ActionPersonNo#"											
		ObjectReference  = "Move to another position"
		ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
		ObjectFilter     = "#document.ActionCode#"
		ajaxid           = "#Document.ActionSourceNo#"
	    ObjectKey1       = "#Document.ActionSourceNo#"							
		ObjectURL        = "#link#"
		Show             = "Yes"> 