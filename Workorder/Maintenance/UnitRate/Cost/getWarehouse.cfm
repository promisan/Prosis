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

<cfquery name="getWarehouse" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Materials.dbo.Warehouse
	WHERE  Mission = '#url.mission#'
	AND    SaleMode != '0'
</cfquery>

<cfif getWarehouse.recordcount eq "0">
	
	<cfquery name="getWarehouse" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Materials.dbo.Warehouse
		WHERE  Mission = '#url.mission#'	
	</cfquery>

</cfif>

<cfparam name="url.itemno" default="">


<select name="Warehouse" class="regularxl" onchange="_cf_loadingtexthtml='';ColdFusion.navigate('getWarehouseItem.cfm?warehouse='+this.value+'&itemno=#url.itemno#','itembox')">
	<option value="">Not applicable</option>
	<cfoutput query="getWarehouse">
		<option value="#warehouse#" <cfif url.selected eq warehouse>selected</cfif>>#WarehouseName#</option>
	</cfoutput>			
</select>		
