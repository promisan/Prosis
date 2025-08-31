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
<cfquery name="Observation" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    Observation
		WHERE   ObservationId = '#URL.AjaxId#'
</cfquery>

<cfquery name="Requester" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    UserNames
		WHERE   Account = '#Observation.Requester#'
</cfquery>

<cfquery name="Object" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    OrganizationObject
		WHERE   ObjectkeyValue4 = '#URL.AjaxId#'
</cfquery>

<!--- 1. test EntityGroup and EntityClass at runtime from the table itself 
2. do I need to submit both ?
3. what happens if group changes
--->

<cfset link = "System/Modification/DocumentView.cfm?id=#URL.AjaxId#">
	
<cf_ActionListing 
	EntityCode       = "#Object.EntityCode#"	
	EntityGroup      = "#Object.EntityGroup#" 
	EntityClass      = "#Object.EntityClass#"
	PersonEmail      = "#Object.PersonEmail#"	
	EntityStatus     = ""		
	Owner            = "#Observation.Owner#"	
	ObjectReference  = "#Object.ObjectReference#"
	ObjectReference2 = "#Requester.firstName# #Requester.lastName#"
	ObjectKey4       = "#Observation.ObservationId#"
	ObjectURL        = "#link#"
	Show             = "Yes"
	AjaxId           = "#URL.AjaxId#"
	Toolbar          = "Yes"
	Annotation       = "No"
	Framecolor       = "ECF5FF"
	CompleteFirst    = "No">