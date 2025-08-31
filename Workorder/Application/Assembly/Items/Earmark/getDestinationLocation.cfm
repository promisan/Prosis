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
<cfquery name="Warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    *
    FROM      Warehouse
    WHERE     Warehouse = '#url.warehouse#'    									  	
</cfquery>


<cfquery name="WarehouseLocation" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    *
    FROM      WarehouseLocation
    WHERE     Warehouse = '#url.warehouse#'    									  
	AND Operational = 1
</cfquery>

<select name="destinationlocation" id="destinationlocation" class="regularxl">			
	
	<cfoutput query="warehouselocation">
	<option value="#location#" <cfif warehouse.LocationReceipt eq location>selected</cfif>>#Description#</option>
	</cfoutput>
	
</select>
		