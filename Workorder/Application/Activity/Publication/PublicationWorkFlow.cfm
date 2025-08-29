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
<cfquery name="Publication" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT    *
	FROM      Publication
	WHERE     PublicationId = '#url.ajaxid#'  
</cfquery>	

<cfquery name="WorkOrder" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT    *
	FROM      WorkOrder
	WHERE     1=1
		<cfif TRIM(Publication.WorkOrderId) neq "">
			AND WorkOrderId = '#Publication.WorkOrderId#'  
		<cfelse>
			AND WorkOrderId = '00000000-0000-0000-0000-000000000000'  
		</cfif>

</cfquery>	

<cfif WorkOrder.recordcount gte 1>

<cfset link = "WorkOrder/Application/Activity/Publication/PublicationWorkFlow.cfm?publicationid=#URL.Ajaxid#">

<cf_ActionListing 
    EntityCode      = "WrkPublish"
	EntityClass     = "Standard"
	EntityGroup     = ""
	EntityStatus    = ""
	AjaxId          = "#url.ajaxid#"
	Mission         = "#WorkOrder.Mission#"
	OrgUnit         = "#WorkOrder.OrgUnitOwner#"
	ObjectReference = "#Publication.Description#"   
	ObjectKey4      = "#url.ajaxid#"
	ObjectURL       = "#link#">

</cfif>