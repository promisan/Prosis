<cfparam name="url.type" default="Item">

<cfset vField = "ItemNo">
<cfset vPrefix = "">
<cfset vLabel = "Master">

<cfif url.type eq "AssetItem">
	<cfset vField = "AssetId">
	<cfset vPrefix = "Asset">
	<cfset vLabel = "Asset">
</cfif>


<cfquery name="delete" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM	#vPrefix#ItemSupplyMetricTarget
	WHERE	#vField# 		= '#url.id#'
	AND 	SupplyItemNo 	= '#url.SupplyItemNo#' 
	AND 	SupplyItemUoM 	= '#url.SupplyItemUoM#'
	AND		Metric 			= '#url.metric#'
	<cfif url.type eq "Item">
	AND		Mission 		= '#url.mission#'
	AND		Location 		<cfif trim(url.location) eq "">IS NULL<cfelse>= '#url.location#'</cfif>
	</cfif>
	<cfif url.type eq "AssetItem">
	AND		DateEffective 	= '#url.dateEffective#'
	</cfif>
</cfquery>

<cfoutput>
	<script>
		ColdFusion.navigate('Consumption/ItemSupplyMetricTargetListing.cfm?id=#url.id#&supplyitemno=#url.supplyitemno#&supplyitemuom=#url.supplyitemuom#&supplyitemuomdescription=#url.supplyitemuomdescription#&metric=#url.metric#&type=#url.type#','divSupplyMetricTarget_#url.metric#');
	</script>
</cfoutput>