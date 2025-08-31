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
<cfquery name="WarehouseList" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   * 
		FROM     Warehouse P
		WHERE    Mission = '#URL.Mission#' 
		AND      Warehouse IN (SELECT Warehouse 
		                       FROM   WarehouseCategory 
							   WHERE  Warehouse = P.Warehouse
							   AND    Category  = '#url.Category#'
                               AND    Operational = 1
							   AND    SelfService = 1)
		AND      Distribution = 1										   
						   
		ORDER BY WarehouseDefault DESC
</cfquery>
   
<cfif WarehouseList.recordcount eq "0">
   
	   <cfquery name="WarehouseList" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   * 
			FROM     Warehouse P
			WHERE    Mission = '#URL.Mission#' 
			AND      Distribution = 1	
			ORDER BY WarehouseDefault DESC
	   </cfquery>
   						   
</cfif>
 						  
<cfquery name="WarehouseSelect" datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    * 
		FROM      Warehouse
		WHERE     City IN (SELECT City 
		                   FROM   Warehouse 
						   WHERE  Warehouse = '#url.Warehouse#')									 			   												   
		ORDER BY  WarehouseDefault DESC
</cfquery>

<cfif url.directtowarehouse eq "">

<select class="regularxl enterastab" style="width:100%" name="warehouseTo" id="warehouseTo">
	<cfoutput query="WarehouseList">
		<option value="#Warehouse#" <cfif WarehouseSelect.warehouse eq Warehouse>selected</cfif>>#WarehouseName# #Warehouse#</option>
	</cfoutput>
</select>	

<cfelse>

<select class="regularxl enterastab" style="width:100%" name="warehouseTo" id="warehouseTo">
	<cfoutput query="WarehouseList">
		<option value="#Warehouse#" <cfif url.directtowarehouse eq Warehouse>selected</cfif>>#WarehouseName# #Warehouse#</option>
	</cfoutput>
</select>	

</cfif>	