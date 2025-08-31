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
<!--- if the warehouse is the same allow to not change the location or to set a location, 
 if the warehouse is different enforce the selection of the location. --->
 
<cfparam name="url.warehouse" default="">
<cfparam name="url.warehouseto" default="">
  
<cfquery name="Location" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM       WarehouseLocation
		WHERE      Warehouse = '#url.warehouseto#'
		AND        Operational = '1'
		ORDER BY   ListingOrder
</cfquery>

<cfoutput>					
						
	<select name="locationto" id="locationto"
	    class="regularxl" style="font-size:15px;height:36px;width:250px">
		<cfif url.warehouse eq url.warehouseto>
		  <option value="" selected><cf_tl id="Do not change"></option>		
		</cfif>
		<cfloop query="Location">
			<option value="#Location#">#Description#</option>
		</cfloop>
	</select>	
			
</cfoutput>	


