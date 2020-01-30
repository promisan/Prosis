<cfquery name="getCategoryItem" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	*
		FROM	Ref_CategoryItem
		WHERE	Category = '#url.category#'
		ORDER BY CategoryItemName ASC
</cfquery>

<cfoutput>
	<select 
		id="fltCategoryItem" 
		name="fltCategoryItem" 
		class="regularxl" 
		onchange="ColdFusion.navigate('ForecastEntryDetail.cfm?serviceItem=#url.serviceItem#&customerid=#url.customerid#&year='+$('##fltYear').val()+'&period='+$('##fltPeriod').val()+'&category='+$('##fltCategory').val()+'&categoryItem='+this.value,'divFCEntryDetail');">
			<option value=""> -- <cf_tl id="Select a category item"> --
			<cfloop query="getCategoryItem">
				<option value="#CategoryItem#"> #CategoryItemName#
			</cfloop>
	</select>
</cfoutput>