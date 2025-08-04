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