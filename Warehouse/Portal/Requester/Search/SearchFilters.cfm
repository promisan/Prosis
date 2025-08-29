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
<cfquery name="getWarehouse" 
	datasource="AppsMaterials">
		SELECT 	*
		FROM	Warehouse
		WHERE	Mission     = '#url.mission#'
		AND 	Operational = '1'
		ORDER BY WarehouseName
</cfquery>

<div class="form-group">
	<label class="control-label"><cf_tl id="Warehouse">:</label>
	<div class="input-group" style="width:100%;">
		<select class="form-control m-b filterElement" name="warehouse" id="warehouse">
			<option value=""> - <cf_tl id="Select a warehouse"> -
			<cfoutput query="getWarehouse">
				<option value="#warehouse#">#WarehouseName#
			</cfoutput>
		</select>
	</div>
</div>

<cfdiv id="divCategory" bind="url:#session.root#/warehouse/portal/requester/search/getCategory.cfm?mission=#url.mission#&warehouse={warehouse}">

<div class="form-group">
    <label class="control-label"><cf_tl id="Item">:</label>
    <div class="input-group date" style="width:100%;">
        <input 
			type="text" 
			class="form-control filterElement" 
			name="item" 
			id="item"
			onkeyup="_mobile_applyFilterOnEnter(event);"  
			value="">
    </div>
</div>