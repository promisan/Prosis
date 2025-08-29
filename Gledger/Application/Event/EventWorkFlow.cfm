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
<cfset link = "Gledger/Application/Event/EventView.cfm?ID=#url.ajaxid#">

<cfquery name="Get" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM   Event
		WHERE  EventId = '#URL.AjaxId#'
</cfquery>
		
<cf_ActionListing 
	EntityCode       = "GLEvent"
	EntityClass      = "#get.EntityClass#"
	EntityGroup      = ""
	EntityStatus     = ""		
	Mission          = "#get.mission#"
	OrgUnit          = "#get.OrgUnit#"
	ObjectReference  = "#Get.EventDescription#"			   
	ObjectKey4       = "#Get.EventId#"
	AjaxId           = "#Get.EventId#"
	ObjectURL        = "#link#"
	Show             = "Yes"		
	Toolbar          = "Yes">