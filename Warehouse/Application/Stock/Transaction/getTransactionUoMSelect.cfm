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
<cfparam name="url.selected" default="">

<cfquery name="uomlist" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM   ItemWarehouseLocationUoM 
	WHERE  Warehouse = '#url.warehouse#'	
    AND    Location  = '#url.location#'	
	AND    ItemNo    = '#url.itemno#' 		
	AND    UoM       = '#url.uom#' 		
	ORDER BY MovementDefault DESC			
</cfquery>

<cfif uomlist.recordcount gte "1">

	<cfoutput>
	
		<select name="movementuom" id="movementuom" class="regularxl enterastab">
			<cfloop query="uomlist">
				<option value="#MovementUoM#" <cfif url.selected eq MovementUoM>selected</cfif>>#MovementUoM#</option>
			</cfloop>
		</select>			
	
	</cfoutput>
	
<cfelse>

	<cf_compression>
	
</cfif>
