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
<cfset vField = "ItemNo">
<cfset vPrefix = "">

<cfif url.type eq "AssetItem">
	<cfset vField = "AssetId">
	<cfset vPrefix = "Asset">
	
	<cfquery name="clearWarehouses" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM AssetItemSupplyWarehouse
		WHERE   AssetId = '#URL.id#'
	</cfquery>
	
</cfif>

<cfquery name="delete" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM #vPrefix#ItemSupply
	WHERE   #vField#      = '#URL.id#'
	AND     SupplyItemNo  = '#URL.supply#' 
	AND		SupplyItemUoM = '#URL.supplyuom#' 
</cfquery>	

<cfoutput>
	<script>
		ColdFusion.navigate('#SESSION.root#/Warehouse/Maintenance/Item/Consumption/ItemSupplyListing.cfm?type=#url.type#&id=#url.id#','supplylist')
	</script> 
</cfoutput>
