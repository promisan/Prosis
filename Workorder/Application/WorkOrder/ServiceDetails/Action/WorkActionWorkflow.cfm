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
<cfquery name="WorkorderLineAction" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * FROM WorkOrderLineAction
		WHERE  WorkActionId  = '#URL.AjaxId#'			
</cfquery>

<cfquery name="Object" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   OrganizationObject
		WHERE  ObjectKeyValue4  = '#URL.AjaxId#'	
		AND    Operational = 1		
</cfquery>

<cfif WorkOrderLineAction.recordcount eq "0">

	<table align="center"><tr><td align="center" class="labelmedium"><cf_tl id="Record is no longer in the database"></td></tr></table>

<cfelse>

	<cfquery name="wfWorkorder" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM   WorkOrder
			WHERE  WorkOrderId   = '#WorkorderLineAction.WorkOrderId#'			
	</cfquery>
	
	<cfquery name="wfCustomer" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM   Customer
			WHERE  CustomerId   = '#wfWorkorder.CustomerId#'			
	</cfquery>
	
	<cfquery name="wfWorkorderLine" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM   WorkOrderLine
			WHERE  WorkOrderId   = '#WorkorderLineAction.WorkOrderId#'	
			AND    WorkorderLine = '#WorkorderLineAction.workorderline#'	
	</cfquery>
	
	<cfquery name="Serviceitem" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM   ServiceItem
			WHERE  Code   = '#wfworkorder.serviceitem#'		
	</cfquery>	
		
	<cfquery name="Domain" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * FROM Ref_ServiceItemDomain
			WHERE  Code   = '#serviceitem.servicedomain#'		
		</cfquery>		
		
	<cfquery name="Action" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_Action
			WHERE  Code  = '#WorkorderLineAction.ActionClass#'		
	</cfquery>	
	
	<cfset link = "WorkOrder/Application/WorkOrder/ServiceDetails/Action/WorkActionView.cfm?drillid=#url.ajaxid#">			
		
	<cf_stringtoformat value="#wfworkorderline.reference#" format="#domain.DisplayFormat#">	
					
	<cf_ActionListing 
	    EntityCode       = "WorkOrder"
		EntityClass      = "#Object.EntityClass#"
		EntityGroup      = "#domain.code#"
		EntityStatus     = ""
		Mission          = "#wfWorkorder.mission#"		
		OrgUnit          = "#wfWorkorderLine.OrgUnitImplementer#"	  				
		ObjectReference  = "#Serviceitem.Description#: #val#"	
		ObjectReference2 = "#wfCustomer.CustomerName# #Action.description#" 					  
		ObjectKey4       = "#url.ajaxid#"	
		AjaxId           = "#url.ajaxid#" 		
		Toolbar          = "Hide"		
		Show             = "Yes">  

</cfif> 	
	
