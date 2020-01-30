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