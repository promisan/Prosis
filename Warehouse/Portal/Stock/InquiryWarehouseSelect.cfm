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
<!---

<cfquery name="WarehouseSelect" datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   DISTINCT WC.ListingOrder, W.warehouseName, W.Warehouse, W.City
	FROM     Warehouse W, Ref_WarehouseCity WC
	WHERE    W.City    = WC.City
	AND      W.Mission = WC.Mission
	AND      W.Mission   = '#url.mission#'	
	AND      W.Warehouse IN (#QuotedValueList(WarehouseList.Warehouse)#)				
	ORDER BY WC.ListingOrder, WarehouseName 
</cfquery>

--->

<form method="post" name="formdefault" id="formdefault" style="width:100%;color:white"">

	<table width="95%" bgcolor="white" cellspacing="0" cellpadding="0" align="center">
		
	<tr class="hide"><td id="selectwarehouse"></td></tr>
	
	<tr>
	<td align="center" colspan="8">
			
			  <cfoutput>
				<input type="button" name="Apply" style="font-size:11;height:23;width:180" value="Refresh selection" class="button10s" onclick="ColdFusion.navigate('Stock/InquiryWarehouseMain.cfm?init=0&systemfunctionid=#url.systemfunctionid#&webapp=#url.webapp#&mission=#url.mission#','whsdetail')">
		   </cfoutput>	
			
			</td>
	</tr>
			
	<cf_PortalDefaultValue 
			systemfunctionid = "#url.systemfunctionid#" 
			key       = "Warehouse" 
			ResultVar = "default">
	
	<cfoutput query="WarehouseSelect" group="ListingOrder">
	
		<tr>
			<td colspan="8" style="height:28" class="labelmedium"><i>#City#</i></td>
		</tr>
		
		<tr><td colspan="8" class="linedotted"></td></tr>
		
		<cfset cnt = 0>
		<cfoutput>
		
		<cfset cnt = cnt + 1>
		
		<cfif cnt eq "1">
			<tr>
		</cfif>
	
			<td style="height:15;padding-left:16px;padding-left:2px">
			
			    <input type    = "checkbox" 
				       onclick = "ColdFusion.navigate('#session.root#/Warehouse/Portal/Stock/InquiryWarehouseSelectSubmit.cfm?systemfunctionid=#url.systemfunctionid#&warehouse=#warehouse#','selectwarehouse','','','POST','formdefault')" 
					   name    = "warehouse" 
					   style   = "padding:0px"
					   value   = "#warehouse#" <cfif findNoCase(warehouse,default)>checked</cfif>></td>
					 
			<td class="labelit" style="width:25%;padding-left:8px">#WarehouseName#</td>
		
		<cfif cnt eq "4">
			</tr>
			<cfset cnt = 0>
		</cfif>
	
		</cfoutput>
	
	</cfoutput>
	
	</table>

</form>