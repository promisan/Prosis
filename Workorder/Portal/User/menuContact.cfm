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
<cfset url.mission = "OICT">

<cfquery name="List" 
	datasource="AppsWorkOrder"
     username="#SESSION.login#"
     password="#SESSION.dbpw#">							
	  SELECT     TOP 1 W.*	 
	  FROM       ServiceItemClass C INNER JOIN
	             ServiceItem S ON C.Code = S.ServiceClass INNER JOIN
				 Ref_ServiceItemDomain D ON D.Code = S.ServiceDomain INNER JOIN
                 WorkOrder W ON S.Code = W.ServiceItem INNER JOIN
                 WorkOrderLine WL ON W.WorkOrderId = WL.WorkOrderId
      WHERE      WL.PersonNo = '#client.personno#' AND
	  			 WL.Operational = '1' AND
				 S.Operational = 1 AND
				 S.Selfservice = 1 AND
				 (WL.DateExpiration is NULL or DateExpiration > getDate()-50) AND
				 W.Mission = '#url.mission#'
	  ORDER BY   C.Description, S.Description, WL.Reference						  
</cfquery>	
	
<cfset url.scope = "portal">	

<cfif list.recordcount eq "1">	


<table width="96%" height="100%" align="center"><tr><td>

	<cfset url.init = 0>
        <cfset url.scope = "portal">
	<cfset url.workorderid = "#list.workorderid#">
	<cfinclude template="../../../custom/portal/muc/WorkOrderAddress.cfm">
	
	</td></tr></table>

</cfif>