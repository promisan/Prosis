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
<cfquery name="Delete" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		DELETE FROM	ItemVendor
		WHERE	ItemNo = '#url.id#'
		AND		UoM = '#url.uom#'
		AND		OrgUnitVendor = #url.orgunitvendor#
</cfquery>

<cfoutput>
	<script>
		ColdFusion.navigate('#SESSION.root#/Warehouse/Maintenance/ItemMaster/vendors/vendorListing.cfm?id=#url.id#&mission=#url.mission#','divVendorListing');
	</script>
</cfoutput>

