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

<!--- passtru template to show the postings --->

<cfparam name="url.referenceid" default="#url.workorderid#">

<cfquery name="workorder" 
    datasource="AppsWorkOrder" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT   *
		FROM     WorkOrder	
		WHERE    WorkOrderId = '#url.workorderid#'		
</cfquery>

<cfquery name="customer" 
    datasource="AppsWorkOrder" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT   *
		FROM     Customer	
		WHERE    CustomerId = '#workorder.customerid#'		
</cfquery>

<cfquery name="getServiceItem" 
    datasource="AppsWorkOrder" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT   *
		FROM     ServiceItem S INNER JOIN ServiceItemMission M ON S.Code = M.ServiceItem		
		WHERE    Mission     = '#workorder.mission#'
		AND      ServiceItem = '#workorder.serviceitem#'
	</cfquery>

<cfquery name="header" 
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT   TOP 1 *
		FROM     TransactionHeader	
		WHERE    ReferenceId = '#url.workorderid#'		
		ORDER BY Created DESC
</cfquery>

<!---
<cfif header.recordcount eq "0">
	
	<table width="100%" height="100%">
		<tr><td align="center"><font face="Verdana">No charges were posted for this workorder.</font></td></tr>
	</table>

<cfelse>

--->
	
	<cfparam name="url.mission"   default="#workorder.mission#">
	<cfparam name="url.period"    default="#header.accountperiod#">
	
	<cfquery name="getServiceItem" 
	    datasource="AppsWorkOrder" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT   *
			FROM     ServiceItem S INNER JOIN ServiceItemMission M ON S.Code = M.ServiceItem		
			WHERE    Mission = '#workorder.mission#'
			AND      ServiceItem = '#workorder.serviceitem#'
		</cfquery>
		
		<!--- pending a true ajax mode --->
		
		<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
		<cfset mid = oSecurity.gethash()/>   
		
		<cfoutput>
		<iframe src="../../../../Gledger/Application/Transaction/Journal.cfm?mission=#workorder.mission#&referenceorgunit=#customer.orgunit#&referenceid=#url.workorderid#&period=#header.accountperiod#&mid=#mid#" 	
		  width="100%" height="98%" frameborder="0"></iframe>
		</cfoutput>

<!---	
</cfif>
--->

