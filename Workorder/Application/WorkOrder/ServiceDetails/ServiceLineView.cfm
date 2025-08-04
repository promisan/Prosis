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


<cfparam name="url.id"       default="">   
<cfparam name="url.drillid"  default="#url.id#">
<cfparam name="url.openmode" default="dialog">
<cfparam name="url.workorderline" default="0">

<cfif url.drillid neq "">
	
	<cfquery name="Line" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrderLine
		 WHERE   WorkOrderLineId     = '#url.drillid#'	
	</cfquery>
	
	<cfif Line.recordcount eq "0">
	
	<cfquery name="Line" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrderLineItem
		 WHERE   WorkOrderItemId     = '#url.drillid#'	
	</cfquery>
	
	</cfif>
	
	<cfset url.workorderline = line.workorderline>
	<cfset url.workorderid   = line.workorderid>
	
<cfelse>

	<cfquery name="Line" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrderLine
		 WHERE   WorkOrderId     = '#url.workorderid#'	
		 AND     WorkOrderLine   = '#url.workorderline#'	
		  
	</cfquery>
		
</cfif>		

<cfquery name="WorkOrder" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrder
	 WHERE   WorkOrderId     = '#url.workorderid#'	
</cfquery>

<cfquery name="Item" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    ServiceItem
	 WHERE   Code   = '#workorder.serviceitem#'	
</cfquery>

<cfquery name="Domain" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Ref_ServiceItemDomain
	 WHERE   Code   = '#item.servicedomain#'	
</cfquery>

<cfquery name="Customer" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Customer
	 WHERE   CustomerId = '#workorder.customerid#'	
</cfquery> 

<!--- -----------load the scripts-------- --->
<cfinclude template="ServiceLineScript.cfm">
<!--- ----------------------------------- --->

<cf_screentop label="#Customer.CustomerName# / #Item.Description#" 
   height        = "100%" 
   scroll        = "Yes" 
   html          = "No"
   systemmodule  = "WorkOrder"
   functionclass = "Window"
   functionName  = "WorkOrder Line"
   layout        = "webapp" 
   line          = "no" 
   busy          = "busy10.gif" 
   banner        = "blue" 
   bannerforce   = "Yes" 
   jQuery        = "yes">
 
<cf_listingScript gadgets="Yes">
  
<cfif domain.description neq "">
	<cfset option = "#Domain.description#">
<cfelse>
    <cfset option = "">
</cfif>

<cfset option = "#option#">
    			
<cfif Line.recordcount eq "1">				
	<cfinclude template="ServiceLineFormEdit.cfm">		
<cfelse>		
    <!--- no longer relevant, redirect to service line form entry --->		
	<cfinclude template="ServiceLineFormEntry.cfm">				
</cfif>	
	
	
	
