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
<cfparam name="url.init" default="0">

<cfquery name="itm" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   Itemno, ItemDescription
	FROM     Item I
	WHERE    Destination = 'Distribution'
	AND      ItemNo IN (SELECT ItemNo 
	                    FROM   ItemWarehouseLocation 
						WHERE  Warehouse = '#url.warehouse#'	
                        AND    Location = '#url.location#') 
	ORDER BY ItemNo					
</cfquery>

	
	<cfoutput>
		
		<cfset url.itemNo = itm.ItemNo>
		
		<select name = "itemno"  id = "itemno" class="regularxl enterastab"
		  onchange="ptoken.navigate('../Transaction/getUOMSelect.cfm?tratpe=#url.tratpe#&mode=#url.mode#&warehouse=#url.warehouse#&location=#url.location#&ItemNo='+this.value,'uombox')">
			<cfloop query="itm">
				<option value="#itemNo#">#ItemNo# #ItemDescription#</option>
			</cfloop>
		</select>	
		
		<cfif url.init eq "0">
			
		<script>
		 
			ptoken.navigate('../Transaction/getUoMSelect.cfm?tratpe=#url.tratpe#&mode=#url.mode#&warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.itemNo#','uombox')	
	
		</script>
		
		</cfif>
			
	</cfoutput>
	