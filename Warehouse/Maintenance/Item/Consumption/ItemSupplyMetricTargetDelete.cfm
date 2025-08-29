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