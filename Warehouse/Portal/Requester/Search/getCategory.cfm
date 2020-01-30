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