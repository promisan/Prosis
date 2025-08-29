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
<cfparam name="url.mode" default="FinalProduct">

<cfquery name="get" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT  *
		FROM    WorkOrder
		WHERE   WorkOrderId = '#url.workorderid#'			
</cfquery>	

<cfquery name="getCategory" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT DISTINCT I.Category, R.Description
		FROM   WorkOrderLineResource WOLR INNER JOIN
               Materials.dbo.Item I ON WOLR.ResourceItemNo = I.ItemNo INNER JOIN
               Materials.dbo.Ref_Category R ON I.Category = R.Category
		WHERE  WOLR.WorkOrderId = '#url.workorderid#' 
		AND    WOLR.WorkOrderLine = '#url.workorderline#'
</cfquery>

<cfoutput>

<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">

	<tr>
		<td width="220" style="height:40px" class="labelmedium"><cf_tl id="Required Item Category">:</td>
		<td>
		
		<table>
		
			<tr>
			
			<input type="hidden" id="categoryselect" value="#getcategory.category#">
				
			<cfloop query="getCategory">			
			
				<td style="padding-left:1px">
				<input onclick="document.getElementById('categoryselect').value='#category#';_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('#session.root#/workorder/Application/Assembly/Items/BOM/ItemListing.cfm?mode=#url.mode#&systemfunctionid=#url.systemfunctionid#&mission=#get.mission#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&category=#category#','itembox')"
				   type="radio" name="category" id="category" value="#category#" <cfif currentrow eq "1">checked</cfif> style="height:19px;width:19px">
				</td>
				<td style="padding-left:6px;padding-right:10px" class="labelmedium">#Description#</td>
				
			</cfloop>
			
			</tr>
		
		</table>
				
		</td>
		
		<td style="padding-left:6px;padding-right:10px" class="labelmedium" align="right">
			<cf_tl id="Print Bill of Materials" var="1">
			<cfset vPrintOut = "custom/hicosa/workorder/printout/bom.cfr">
			<img src="#client.root#/images/print.png" style="height:25px;" onclick="printBOM('#url.workorderid#','#url.workorderline#',document.getElementById('categoryselect').value,'#vPrintOut#');" title="#lt_text#">
		</td>
	
	</tr>
	
	<tr><td style="height:100%" class="line" colspan="3" valign="top">	
	    <cf_getMID>
	    <cfdiv id="itembox" 
		   style="height:100%" bind="url:#session.root#/workorder/Application/Assembly/Items/BOM/ItemListing.cfm?mode=#url.mode#&systemfunctionid=#url.systemfunctionid#&mission=#get.mission#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&category=#getcategory.category#&mid=#mid#">		
	</td></tr>
	
</table>

</cfoutput>

