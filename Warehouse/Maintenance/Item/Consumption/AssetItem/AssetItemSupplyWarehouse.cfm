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
<cftry>
	<cfquery name="insert" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO AssetItemSupply	(
				AssetId,
				SupplyItemNo,
				SupplyItemUoM,
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName
			)
		VALUES	(
				'#url.itemno#',
				'#url.supply#',
				'#url.uom#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#'
			)
	</cfquery>
	
	<script>
		document.getElementById('autoInserted').value = 1;
	</script>
	
	<cfcatch></cfcatch>
</cftry>


<cfquery name="warehouse" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*,
			(SELECT WarehouseName FROM Warehouse WHERE Warehouse = S.Warehouse) as WarehouseName
	FROM 	AssetItemSupplyWarehouse S
	WHERE 	1=1
	<cfif url.itemno neq "">
		AND 	AssetId = '#url.itemno#'
	</cfif>
	AND 	SupplyItemNo = '#url.supply#'
	AND		SupplyItemUoM = '#url.uom#'
</cfquery>

<cfset whList = "">
<cfset whList = valueList(warehouse.WarehouseName)>
<cfset whList = replace(whList,",", ", ", "ALL")>

<cfif trim(whList) eq "">
	<cfset whList = "[Any warehouse]">
</cfif>

<table>
	<tr>
		<td class="labelmedium">
			<cfoutput>
			<cfif url.supply neq "" and url.uom neq "">
				<font color="808080">#whList#</font>
				<cfif url.itemno neq "">
					&nbsp;
					<a title="Edit warehouses" href="javascript:supplyeditwarehouse('#url.itemno#','#url.supply#','#url.uom#')"><font color="6688aa">[Edit]</font></a>
				</cfif>
			<cfelse>
				<font color="gray">Select a valid supply item</font>
			</cfif>	
			</cfoutput>
		</td>
	</tr>
</table>
