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
<cfquery name="qLot" 
datasource="AppsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT  DISTINCT TransactionLot
	FROM    ItemUoMMissionLot
	WHERE   TransactionLot > '0' 
	AND     Mission      	= '#url.warehouse#'
	AND     ItemNo         	= '#url.id#' 
	AND     UoM 			= '#url.UoM#'
</cfquery>

<cfoutput>				
	<select name="sLot" id="sLot" class="regularxl" id="sLot" onChange="updateButton('#url.id#','#url.uom#',document.getElementById('labels').value,document.getElementById('sWarehouse').value)">
	    <option value="">No lot</option>
		<cfloop query="qLot">
			<option value="#TransactionLot#">#TransactionLot#</option>
		</cfloop>
	</select>
</cfoutput>