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

<cfquery name="getItemUoM" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT      I.ItemNo, I.UoM, I.UoMDescription
	FROM        ItemWarehouse AS IW INNER JOIN
                         ItemUoM AS I ON IW.ItemNo = I.ItemNo and IW.UoM = I.UoM
	WHERE       IW.Warehouse = '#url.warehouse#'
	AND         I.ItemNo = '#url.itemno#'	
</cfquery>

<select name="itemuom" style="width:140px" class="regularxl">	
	<cfoutput query="getItemUoM">
		<option value="#uom#" <cfif url.itemuom eq uom>selected</cfif>>#UoMDescription#</option>
	</cfoutput>			
</select>		