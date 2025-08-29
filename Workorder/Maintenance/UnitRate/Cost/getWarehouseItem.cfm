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
<cfparam name="url.itemuom" default="">

<cfif url.warehouse eq "">

	<script>
	 document.getElementById('itemline').className = "hide"
	</script>

<cfelse>

	<script>
	 document.getElementById('itemline').className = "regular"
	</script>
	
	<cfquery name="getItem" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT      I.ItemNo, I.ItemDescription
		FROM        ItemWarehouse AS IW INNER JOIN
	                         Item AS I ON IW.ItemNo = I.ItemNo
		WHERE       IW.Warehouse = '#url.warehouse#'
		AND         I.Operational = 1
		ORDER BY    I.ItemNo ASC
	</cfquery>
	
	<cfset itm = getItem.ItemNo>
	
	<cfoutput>
	
	
	<select style="width:320px" name="ItemNo" class="regularxl" 
	     onchange="_cf_loadingtexthtml='';ptoken.navigate('getWarehouseItemUoM.cfm?warehouse=#url.warehouse#&itemno='+this.value,'itemuom')">	
	   	<cfloop query="getItem">
			<option value="#ItemNo#" <cfif url.itemno eq itemno>selected</cfif>>#ItemNo# - #ItemDescription#</option>
			
			<cfif url.itemno eq itemno>
				<cfset itm = itemno>
			</cfif>
			
		</cfloop>			
	</select>		
	
	
	<script>
		ptoken.navigate('getWarehouseItemUoM.cfm?warehouse=#url.warehouse#&itemno=#itm#&itemuom=#url.itemuom#','itemuom')		
	</script>	
	
	</cfoutput>

</cfif>