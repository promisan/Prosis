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
datasource="appsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   	SELECT 	  L.Mission, 
	          L.ServiceItem,
			  S.Description AS ServiceItemDescription,
			  L.ServiceUsageSerialNo,
			  L.SelectionDateStart,
			  L.SelectionDateEnd,
			  L.Memo,
			  L.ActionStatus,
			  L.UsageLoadId
	FROM 	  ServiceItemLoad L
	INNER JOIN ServiceItem S ON S.Code = L.ServiceItem
	WHERE UsageLoadId = '#URL.ajaxId#'
</cfquery>
	
<cfset link = "">			
	
 <cf_ActionListing 
    EntityCode       = "WorkOrderLoad"
	EntityClass      = "Standard"
	EntityGroup      = ""
	EntityStatus     = ""
	Mission          = "#get.mission#"	
	ObjectReference  = "#get.ServiceItem#"
	ObjectReference2 = "#get.ServiceItemDescription#" 	
	ObjectKey1       = "#get.ServiceUsageSerialNo#"
	ObjectKey4       = "#URL.ajaxId#"
	AjaxId           = "#URL.ajaxId#"
	ObjectURL        = "#link#"	
	Show             = "Yes">
	
	
