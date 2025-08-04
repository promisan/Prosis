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
<cfquery name="thisItem" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Item
		WHERE 	ItemNo = '#url.id#'
</cfquery>

<cfquery name="wh" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM   	Warehouse
		WHERE	Mission = '#thisItem.Mission#'
</cfquery>

<table width="100%" align="center">
	<tr><td height="5"></td></tr>
	<tr>
		<td style="width:100px" class="labelmedium"><cf_tl id="Warehouse">:</td>
		<td>
		
			<select class="regularxl" name="lwarehouse" id="lwarehouse">
				<cfoutput query="wh">
					<option value="#warehouse#">#warehouse# - #warehouseName#
				</cfoutput>
			</select>
		</td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr>
		<td colspan="2">
			<cf_securediv id="divItemPriceSchedule" 
			 bind="url:#SESSION.root#/Warehouse/Maintenance/Warehouse/Category/PriceSchedule/PriceScheduleForm.cfm?warehouse={lwarehouse}&category=#thisItem.Category#&isReadOnly=1">
		</td>
	</tr>
</table>