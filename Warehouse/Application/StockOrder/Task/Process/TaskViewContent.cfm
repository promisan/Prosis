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
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Warehouse
	  WHERE Warehouse = '#url.warehouse#'
</cfquery>	  			

<cfparam name="client.selecteddate" default="#now()#">
<cfparam name="url.selecteddate" default="#client.selecteddate#">

<cfoutput>
<input type="hidden" id="warehouseshow" value="#url.warehouse#">
</cfoutput>
								
<cf_calendarView 
   title          = "#get.WarehouseName#"	
   selecteddate   = "#url.selecteddate#"
   relativepath   =	"../../.."						    				  
   content        = "Warehouse/Application/StockOrder/Task/Process/TaskViewDate.cfm"			  
   target         = "Warehouse/Application/StockOrder/Task/Process/TaskViewDetail.cfm"
   condition      = "mission=#url.mission#&warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#"		   
   cellwidth      = "fit"
   cellheight     = "40">