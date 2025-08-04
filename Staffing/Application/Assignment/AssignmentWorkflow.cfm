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
<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   * 
    FROM     OrganizationObject
	WHERE    ObjectKeyValue1 =  '#URL.AjaxId#'
</cfquery>

<cfparam name="URL.Mission" default = "#Object.Mission#">

<cfquery name="Get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM   PersonAssignment
		WHERE  AssignmentNo = '#URL.AjaxId#'
</cfquery>

<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Person
		WHERE  PersonNo = '#Get.PersonNo#' 
</cfquery>
			
<!--- defined the unit of the mission --->
	

<cfset link = "Staffing/Application/Employee/PersonView.cfm?ID=#Get.PersonNo#&template=position">
			
	  <cf_ActionListing 
		    EntityCode       = "Assignment"
			EntityClass      = "#Object.EntityClass#"
			EntityGroup      = ""
			EntityStatus     = ""
			Mission          = "#url.mission#"
			PersonNo         = "#Get.PersonNo#"											
			ObjectReference  = "#Object.ObjectReference#"
			ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
			ObjectFilter     = "#Object.ObjectFilter#"
		    ObjectKey1       = "#get.AssignmentNo#"							
			AjaxId           = "#url.ajaxid#"
			ObjectURL        = "#link#"
			Show             = "Yes"> 
		

