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

<cfquery name="getObject" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT *
	 FROM  OrganizationObject 
	 WHERE Objectid = '#URL.ajaxid#'	 
</cfquery>

<cfquery name="getPosition" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT *
	 FROM  Position		 
	 WHERE PositionNo = '#getObject.ObjectKeyValue1#'	 
</cfquery>

<cfif getObject.recordcount gte "1">
	
	<cfset link = "Staffing/Application/Assignment/Review/AssignmentView.cfm?id1=#getObject.ObjectKeyValue1#">			
	
	<cf_ActionListing 
	    EntityCode       = "PositionReview"
		EntityClass      = "Standard"
		EntityGroup      = ""
		EntityStatus     = ""
		tablewidth       = "100%"
		Mission          = "#getPosition.mission#"	
		OrgUnit          = "#getPosition.OrgUnitOperational#"
		ObjectReference  = "Incumbency review"
		ObjectReference2 = "#getPosition.PostGrade#" 	
	    ObjectKey1       = "#getObject.ObjectKeyValue1#"	
		AjaxId           = "#URL.ajaxId#"
		ObjectURL        = "#link#"
		Show             = "Yes"
		Create           = "No"
		HideCurrent      = "No">
		
</cfif>	