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