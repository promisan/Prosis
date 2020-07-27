<cfset dateValue = "">
<cf_dateConvert value="#url.dateeffective#">
<cfset vDateEffective = dateValue>

<cfquery name="categories" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT
				R.TabOrder,
				R.Category, 
				R.Description,
				(
					SELECT 	PriceSchedule
					FROM	CustomerSchedule
					WHERE	CustomerId = '#url.CustomerId#'
					AND		Category = R.Category
					AND		DateEffective = #vDateEffective#
				) AS Selected
		FROM    Customer C 
				INNER JOIN Warehouse W 
					ON C.Mission = W.Mission 
				INNER JOIN WarehouseCategory WC 
					ON W.Warehouse = WC.Warehouse 
				INNER JOIN Ref_Category R 
					ON WC.Category = R.Category
		WHERE	C.CustomerId = '#url.customerId#'
		AND		R.Operational = 1
		ORDER BY R.TabOrder
</cfquery>

<cfquery name="priceSchedule" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	Ref_PriceSchedule
		ORDER BY ListingOrder
</cfquery>

<cf_tl id="Please, select a valid price schedule" var="errorMessage">
<cf_tl id="Select a Price Schedule" var="selectMessage">

<!-- <cfform name="dummy"> -->
	<table width="100%" class="navigation_table">
		<tr>
			<td class="labelmedium" width="25%">
				<cf_tl id="Category">
			</td>
			<td class="labelmedium">
				<cf_tl id="Price Schedule">
			</td>
			<td class="labelmedium" width="25%">
				<cf_tl id="Category">
			</td>
			<td class="labelmedium">
				<cf_tl id="Price Schedule">
			</td>
		</tr>
		
		<tr><td height="5"></td></tr>
		<tr><td colspan="2" class="linedotted"></td></tr>
		<tr><td height="5"></td></tr>
		
		<cfset row = "0">
		
		<cfoutput query="categories">
		
			<cfset row = row + 1>
			<cfif row eq "1">
			<tr class="navigation_row">
			</cfif>
						
				<td class="labelmedium">#Description#</td>
				<td class="labelmedium" style="padding:2px;">
					<cfselect 
						name="PriceSchedule_#trim(Category)#" 
						id="PriceSchedule_#trim(Category)#" 
						query="priceSchedule" 
						display="Description" 
						value="Code" 
						class="regularxl selPriceSchedule" 
						required="Yes" 
						selected="#Selected#" 
						message="#errorMessage#" 
						queryposition="below">
						<option value="">-- #selectMessage# --
					</cfselect>
					<cfif currentrow eq 1 AND recordCount gt 1>
						<a style="color:##369CF5; padding-left:15px;" href="javascript:$('.selPriceSchedule').val($('##PriceSchedule_#trim(Category)#').val());">[ <cf_tl id="Same for all"> ]</a>
					</cfif>
				</td>
			<cfif row eq "2">	
			</tr><cfset row = "0">
			</cfif>
		</cfoutput>
	</table>
<!-- </cfform> -->

<cfset AjaxOnLoad("doHighlight")>

<script>
	Prosis.busy('no')
</script>