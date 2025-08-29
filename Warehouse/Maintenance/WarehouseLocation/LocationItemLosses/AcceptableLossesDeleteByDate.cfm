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
<cfset vyear = mid(url.dateEffective, 1, 4)>
<cfset vmonth = mid(url.dateEffective, 6, 2)>
<cfset vday = mid(url.dateEffective, 9, 2)>

<cfset vDateEffective = createDate(vyear, vmonth, vday)>

<cfquery name="delete" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 DELETE FROM ItemWarehouseLocationLoss
		 WHERE		Warehouse = '#url.warehouse#'
		 AND       	Location = '#url.location#'		
		 AND		ItemNo = '#url.itemNo#'
		 AND		UoM = '#url.UoM#'
		 AND		DateEffective = #vDateEffective#
</cfquery>


<cfoutput>
	<script>
		ColdFusion.navigate('../LocationItemLosses/AcceptableLosses.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#','contentbox2');
	</script>
</cfoutput>