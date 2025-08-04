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
<cfquery name="getCategory" 
	datasource="AppsMaterials">
		SELECT 	C.*
		FROM	WarehouseCategory WC
				INNER JOIN Ref_Category C
					ON WC.Category = C.Category
		WHERE 	WC.Operational = '1'
		AND 	WC.SelfService = '1'
		<cfif url.warehouse neq "">
		AND 	WC.Warehouse = '#url.warehouse#'
		</cfif>
		ORDER BY Description
</cfquery>

<cfif getCategory.recordCount gt 1>

	<div class="form-group">
		<label class="control-label"><cf_tl id="Category">:</label>
		<div class="input-group" style="width:100%;">
			<select class="form-control m-b filterElement" name="category" id="category">
				<option value=""> - <cf_tl id="All"> -
				<cfoutput query="getCategory">
					<option value="#category#">#Description#
				</cfoutput>
			</select>
		</div>
	</div>
	
<cfelse>

	<input type="Hidden" class="filterElement" name="category" id="category" value="">

</cfif>

<cfdiv id="divCategoryItem" bind="url:#session.root#/warehouse/portal/requester/search/getCategoryItem.cfm?mission=#url.mission#&warehouse=#url.warehouse#&category={category}">