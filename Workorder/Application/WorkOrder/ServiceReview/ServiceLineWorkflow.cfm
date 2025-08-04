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
datasource="appsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  WorkOrderEvent
	WHERE WorkOrderEventId = '#URL.ajaxId#'
</cfquery>

<cfquery name="GetObject" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   OrganizationObject
  WHERE  ObjectKeyValue4 = '#get.WorkOrderEventId#'
</cfquery>

<cfquery name="workorder" 
datasource="appsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  WorkOrder
	WHERE WorkOrderId = '#get.WorkOrderId#'
</cfquery>

<cfquery name="serviceitem" 
datasource="appsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  ServiceItem
	WHERE Code = '#workorder.serviceitem#'
</cfquery>
	
<cfset link = "WorkOrder/Application/WorkOrder/WorkOrderView/WorkOrderView.cfm?workorderid=#get.WorkOrderId#&selected=servicelevel">			
		
<cf_ActionListing 
	    EntityCode       = "WrkEvent"
		EntityClass      = "#getObject.EntityClass#"
		EntityGroup      = ""
		EntityStatus     = ""
		Mission          = "#workorder.mission#"				
		ObjectReference  = "#get.EventReference#"
		ObjectReference2 = "#serviceitem.description#" 			    
		ObjectKey4       = "#URL.ajaxId#"
		AjaxId           = "#URL.ajaxId#"
		ObjectURL        = "#link#"
		Reset            = "Limited"
		Show             = "Yes">	
	
	
