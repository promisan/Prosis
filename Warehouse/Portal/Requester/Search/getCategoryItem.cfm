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
<cfquery name="getCategoryItem" 
	datasource="AppsMaterials">
		SELECT 	*
		FROM	Ref_CategoryItem
		WHERE	1=1
		<cfif url.category neq "">
		AND 	Category = '#url.category#'
		</cfif>
		ORDER BY CategoryItemName
</cfquery>

<cfif getCategoryItem.recordCount gt 1>

	<div class="form-group">
		<label class="control-label"><cf_tl id="Category Item">:</label>
		<div class="input-group" style="width:100%;">
			<select class="form-control m-b filterElement" name="categoryItem" id="categoryItem">
				<option value=""> - <cf_tl id="All"> -
				<cfoutput query="getCategoryItem">
					<option value="#categoryItemId#">#CategoryItemName#
				</cfoutput>
			</select>
		</div>
	</div>
	
<cfelse>

	<input type="Hidden" class="filterElement" name="categoryItem" id="categoryItem" value="">

</cfif>