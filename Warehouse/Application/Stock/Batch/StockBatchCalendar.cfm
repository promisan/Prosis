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
<!--- capture the selected warehouse --->

<cfoutput>
<input type="hidden" id="warehouseselected" value="#url.warehouse#">
</cfoutput>

  <cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Warehouse
	  WHERE  Warehouse = '#url.warehouse#'
  </cfquery>	  

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
			  
	<tr><td valign="top">		
	
			<cfparam name="client.selecteddate" default="#now()#">
			
			<cfif client.selecteddate lt (now()-300)>
			   <cfset client.selecteddate = now()>
			</cfif>	
			
			<cfparam name="url.selecteddate" default="#client.selecteddate#">								
								
			<cf_calendarView 
			   title          = "#get.WarehouseName#"	
			   selecteddate   = "#url.selecteddate#"
			   relativepath   =	"../../.."				
			   autorefresh    = "0"				   
			   preparation    = "Warehouse/Application/Stock/Batch/StockBatchPrepare.cfm"	    				  
			   content        = "Warehouse/Application/Stock/Batch/StockBatchCalendarDate.cfm"			  
			   target         = "Warehouse/Application/Stock/Batch/StockBatchCalendarList.cfm"
			   condition      = "mission=#url.mission#&warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#&status=#url.status#"		   
			   cellwidth      = "fit"
			   cellheight     = "fit">
			
	</td></tr> 

</table>
 