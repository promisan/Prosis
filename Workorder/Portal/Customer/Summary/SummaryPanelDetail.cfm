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
<cfparam name="url.referenceDate" default="#dateFormat(now(),client.dateformatshow)#">

<!--- we select the workorder and pass the workorders into a panel to be refreshed every 60 seconds --->

<cfquery name="WorkOrderBase" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT    *
		FROM      WorkOrder W, ServiceItem S, Customer C
		WHERE     1=1 <!--- Customerid = '#url.customerid#' --->
		AND       W.ServiceItem  = S.Code
		AND       W.CustomerId   = C.CustomerId
		AND       W.Mission      = '#url.mission#'
		AND       ActionStatus   = '1'
		ORDER BY  C.CustomerName
</cfquery>	

<cfinvoke component = "Service.Connection.Connection"  
   method           = "setconnection"    
   object           = "WorkAction" 
   ScopeId          = "#url.systemfunctionid#"
   ControllerNo     = "999"
   ObjectContent    = "#WorkOrderBase#"
   Objectidfield    = "workorderid"
   delay            = "5">	

<cf_pane id="1" search="no" paneItemMinSize="375">

	<cfloop query="workorderBase">
	
		<cf_paneItem id="#workorderid#" 
				systemfunctionid="#url.systemfunctionid#"
				source="Summary/SummaryPanelContent.cfm?workOrderId=#workorderid#&referenceDate=#url.referenceDate#"
				filterValue="#CustomerName# #Reference# #OrderMemo#"
				style="background-color:##F2F2F2; border:1px solid ##F2F2F2; -moz-border-radius:5px; -webkit-border-radius:5px; -ms-border-radius:5px; -o-border-radius:5px; border-radius:5px;"
				headerStyle="font-size:120%; padding-top:10px; padding-bottom:3px; color:##FFFFFF; font-weight:bold; background-color:##52ACD1;"
				width="375px"
				ShowPrint="1"
				Transition="fade"
				TransitionTime="1000"
				IconSet="white"
				IconHeight="18px"
				label="<span>#CustomerName# &nbsp;<span style=font-size:75%;><span style=font-weight:normal;><i>[#Reference#]</i></span></span></span>">
				
	</cfloop>
	
</cf_pane>
