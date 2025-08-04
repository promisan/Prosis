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
   
<cfquery name="get"
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	  	SELECT    *
		FROM      WorkOrderLineAction WLA INNER JOIN WorkOrder W ON WLA.WorkOrderid = W.WorkOrderId
		WHERE     WorkActionId = '#url.AjaxId#' 			
</cfquery>	

<cfset link = "Warehouse\Application\Stock\Delivery\DeliveryView.cfm?ajaxid=#url.ajaxid#">
		
<cf_ActionListing 
	    EntityCode       = "Workorder"
		EntityClass      = "Deliver"
		EntityGroup      = ""
		EntityStatus     = ""		
		Mission          = "#get.Mission#"
		OrgUnit          = "#get.OrgUnitOwner#"
		ObjectReference  = "Delivery"			    
		ObjectKey4       = "#get.WorkActionId#"
		AjaxId           = "#get.WorkActionId#"
		ObjectURL        = "#link#"
		Show             = "Yes"		
		Toolbar          = "Yes">
				
		
	